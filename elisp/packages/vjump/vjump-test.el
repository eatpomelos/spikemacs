;;; vjump-test.el --- Behavior assertions for vjump -*- lexical-binding: t; -*-

;; Copyright (C) 2026  spikely
;; Author: spikely <spikeluoyu@outlook.com>
;; Keywords: navigation
;; Package-Requires: ((emacs "28.1") (vjump "0.1"))

;; vjump 的行为断言（AGENTS.md「领域不变量」层）。
;; 断言行为契约，不写实现细节；不依赖 GUI / 网络 / LSP。
;; vjump--t-* 是自测专用全局，包运行时不读写。

;;; Code:

(require 'vjump)
(require 'cl-lib)

;; --- 内置自测：行为断言（AGENTS.md「领域不变量」层） ---
;; 断言行为契约，不写实现细节；不依赖 GUI / 网络 / LSP。
;; vjump-list 的显示属活体验证，不在覆盖范围。
;; vjump--t-* 是自测专用全局，包运行时不读写。

(defvar vjump--t-pass 0)
(defvar vjump--t-fail 0)
(defvar vjump--t-dir nil)
(defvar vjump--t-a nil)
(defvar vjump--t-b nil)
(defvar vjump--t-c nil)
(defvar vjump--t-d nil)
(defvar vjump--t-e nil)

(defvar vjump--t-target nil
  "模拟跳转命令的目标文件。")

(defun vjump--t (desc expr)
  "断言 EXPR 非空，按 DESC 记账。"
  (if expr
      (progn (cl-incf vjump--t-pass) (message "  PASS %s" desc))
    (cl-incf vjump--t-fail) (message "  FAIL %s" desc)))

(defun vjump--t-reset (funcs)
  "重置全部状态，用 FUNCS 作为采集清单重开 mode。"
  (when vjump-mode (vjump-mode -1))
  (setq vjump--log nil
        vjump--cur 0
        vjump--pending nil
        vjump-functions funcs
        vjump-limit 200
        vjump-position-delta 100
        vjump-ignored-buffers '("*vjump-list*"))
  (remove-hook 'post-command-hook #'vjump--pending-commit)
  (vjump-mode +1))

(defun vjump--t-file (name)
  "在自测临时目录造 40 行文本文件。"
  (let ((f (expand-file-name name vjump--t-dir)))
    (unless (file-exists-p f)
      (with-temp-file f
        (dotimes (i 40)
          (insert (format "line %d %s\n" i name)))))
    f))

(defun vjump--t-jump ()
  "模拟同步跳转（xref-find-definitions 形态）：命令内完成位移。"
  (find-file vjump--t-target)
  (goto-char (point-min)))

(defun vjump--t-async-jump ()
  "模拟异步跳转（lsp-bridge-find-def 形态）：命令返回时未位移，
位移由命令之外的外部回调完成。"
  nil)

(defvar vjump--t-dest 1
  "模拟同文件跳转命令的目标位置。")

(defun vjump--t-goto ()
  "模拟同文件同步跳转：位移到 vjump--t-dest。"
  (goto-char vjump--t-dest))

;; 场景 7 在运行期才 defun 此符号（验证 advice 先挂、函数后定义），编译期声明前向引用
(declare-function vjump--t-lazy-fn ())

(defun vjump--t-all ()
  ;; --- 1. 同步采集 + back/forward ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)
  (vjump--t "采集: 双记录 [dest, origin]" (= (length vjump--log) 2))
  (vjump--t "采集: cur=0" (zerop vjump--cur))
  (vjump--t "采集: head 指向目的地"
            (eq (vjump--rec-live-buf (nth 0 vjump--log))
                (get-file-buffer vjump--t-b)))
  (vjump-back)
  (vjump--t "back: 回到 origin buffer"
            (eq (current-buffer) (get-file-buffer vjump--t-a)))
  (vjump--t "back: 回到 origin point" (= (point) 10))
  (vjump--t "back: cur=1" (= vjump--cur 1))
  (vjump-forward)
  (vjump--t "forward: 回到目的地"
            (and (eq (current-buffer) (get-file-buffer vjump--t-b))
                 (zerop vjump--cur)))

  ;; --- 2. 去重 ---
  (let ((n (length vjump--log)))
    (setq vjump--t-target vjump--t-b)   ; 已在 b 的 point-min，跳同位置
    (vjump--t-jump)
    (vjump--t "去重: 同位置跳转不入账" (= (length vjump--log) n)))

  ;; --- 3. 历史中段新跳转：双记录保线程 ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                        ; [B,A]
  (vjump-back)                           ; 在 A，cur=1
  (setq vjump--t-target vjump--t-c)
  (vjump--t-jump)                        ; 中段跳转 → [C,A,B,A]
  (vjump--t "中段跳转: 四条记录" (= (length vjump--log) 4))
  (vjump--t "中段跳转: cur=0" (zerop vjump--cur))
  (vjump-back)
  (vjump--t "线程: back 先回出发地"
            (and (eq (current-buffer) (get-file-buffer vjump--t-a))
                 (= (point) 10)))
  (vjump-back)
  (vjump--t "线程: 再 back 到 B"
            (eq (current-buffer) (get-file-buffer vjump--t-b)))
  (vjump-back)
  (vjump--t "线程: 再 back 到最旧 A"
            (eq (current-buffer) (get-file-buffer vjump--t-a)))

  ;; --- 4. 异步跳转（lsp-bridge 形态） ---
  (vjump--t-reset '(vjump--t-async-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-async-jump)                  ; 无位移 → 挂起
  (vjump--t "异步: 挂起未入账" (and vjump--pending (null vjump--log)))
  (find-file vjump--t-b)                 ; 模拟 LSP 回调落位（advice 之外）
  (goto-char 1)
  (run-hooks 'post-command-hook)         ; 模拟下一次命令结束
  (vjump--t "异步: 落位后入账双记录" (= (length vjump--log) 2))
  (vjump--t "异步: 挂起清除" (null vjump--pending))
  (vjump--t "异步: origin 是 A"
            (eq (vjump--rec-live-buf (nth 1 vjump--log))
                (get-file-buffer vjump--t-a)))

  ;; --- 5. 死 buffer 回退 file+point ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)
  (kill-buffer (get-file-buffer vjump--t-a))
  (vjump-back)
  (vjump--t "回退: 死 buffer 用 file+point 重开"
            (and (eq (current-buffer) (get-file-buffer vjump--t-a))
                 (= (point) 10)))

  ;; --- 6. 上限截断 ---
  (vjump--t-reset '(vjump--t-jump))
  (setq vjump-limit 4)
  (find-file vjump--t-a)
  (goto-char 10)
  (dolist (f (list vjump--t-b vjump--t-c vjump--t-a vjump--t-b vjump--t-c))
    (setq vjump--t-target f)
    (vjump--t-jump))
  (vjump--t "截断: 长度等于上限" (= (length vjump--log) 4))
  (vjump--t "截断: cur 仍在最新端" (zerop vjump--cur))

  ;; --- 7. advice 挂在未定义符号上（惰性加载命令） ---
  (vjump--t-reset '(vjump--t-jump vjump--t-lazy-fn))
  (vjump--t "惰性: advice 挂未定义符号不报错" t) ; reset 中已 enable 成功
  (defun vjump--t-lazy-fn ()
    (find-file vjump--t-target)
    (goto-char (point-min)))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-lazy-fn)
  (vjump--t "惰性: 定义后调用即入账" (= (length vjump--log) 2))
  ;; 边界：back 到最旧后不再移动
  (vjump-back)
  (vjump-back)
  (vjump-back)
  (vjump--t "边界: 最旧端 back 停住" (= vjump--cur 1))
  ;; 关 mode 清除挂起的 advice
  (vjump--t-reset '(vjump--t-never-defined))
  (vjump--t "模式: 切换清单重开无报错" (not vjump--pending))
  (vjump-mode -1)
  (vjump--t "模式: 关闭后无 advice 残留"
            (null (advice-mapc (lambda (&rest _) t) #'vjump--t-jump)))

  ;; --- 8. 探索树派生与渲染 ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                         ; [B,A]
  (setq vjump--t-target vjump--t-c)
  (vjump--t-jump)                         ; [C,B,A]
  (vjump-back)
  (vjump-back)                            ; 回 A，cur=2
  (setq vjump--t-target vjump--t-d)
  (vjump--t-jump)                         ; 中段岔出 [D,A',C,B,A]
  (vjump--t "树: origin 推送带 origin-p"
            (vjump--rec-origin-p (nth 1 vjump--log)))
  (vjump--t "树: destination 无 origin-p"
            (not (vjump--rec-origin-p (nth 0 vjump--log))))
  (let* ((root (vjump--tree))
         (kids (cdr root))
         (b (nth 0 kids)))
    (vjump--t "树: 根是 A"
              (eq (vjump--rec-live-buf (car root)) (get-file-buffer vjump--t-a)))
    (vjump--t "树: A 两个岔枝" (= (length kids) 2))
    (vjump--t "树: B→C 链"
              (and (= (length (cdr b)) 1)
                   (eq (vjump--rec-live-buf (car (nth 0 (cdr b))))
                       (get-file-buffer vjump--t-c))))
    (vjump--t "树: D 直接挂 A"
              (eq (vjump--rec-live-buf (car (nth 1 kids)))
                  (get-file-buffer vjump--t-d))))
  (vjump-back)
  (vjump-back)
  (vjump-back)                            ; 回到 B（cur=3）
  (setq vjump--t-target vjump--t-a)
  (vjump--t-jump)                         ; B→A 回祖先：构造环路
  (let ((tmp (get-buffer-create " *vjump-grid-render*")))
    (with-current-buffer tmp
      (setq vjump--sel-rec (car (vjump--tree)))
      (let ((inhibit-read-only t))
        (erase-buffer)
        (vjump--grid-render))
      (vjump--t "渲染: 环路不挂死且非空" (> (buffer-size tmp) 0))
      (vjump--t "渲染: x/o/--/分岔符齐备"
                (and (string-match-p "x" (buffer-string))
                     (string-match-p "o" (buffer-string))
                     (string-match-p "--" (buffer-string))
                     (string-match-p "`" (buffer-string))))
      (kill-buffer tmp)))

  ;; --- 9. 手动记录 vjump-mark ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 20)
  (vjump-mark)
  (vjump--t "标记: 入账且 cur=0"
            (and (= (length vjump--log) 1) (zerop vjump--cur)))
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)
  (vjump-back)
  (vjump--t "标记: back 回到标记点"
            (and (eq (current-buffer) (get-file-buffer vjump--t-a))
                 (= (point) 20)))
  (vjump-forward)
  (vjump-mark)
  (vjump--t "标记: 同位置重复标记不入账"
            (= (length vjump--log) 2))

  ;; --- 10. 列表打开时 mark 自动刷新 ---
  (let ((buf (get-buffer-create "*vjump-list*")))
    (with-current-buffer buf
      (setq vjump--sel-rec nil)
      (vjump-list-refresh))
    (let ((n (with-current-buffer buf
                (count-matches "[ox]" (point-min) (point-max)))))
      (find-file vjump--t-b)
      (goto-char 300)                     ; 距 head(point 1) 超 delta
      (vjump-mark)
      (vjump--t "自动刷新: 列表随 mark 增长"
                (= (with-current-buffer buf
                     (count-matches "[ox]" (point-min) (point-max)))
                   (1+ n))))
    (kill-buffer buf)

  ;; --- 11. 漂移 origin 的 anchor 章 ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                        ; A→B
  (setq vjump--t-target vjump--t-c)
  (vjump--t-jump)                        ; B→C, log=[C,B,A]
  (vjump-back)                           ; 回 B (point 1), cur=1
  (goto-char 400)                        ; 漂移 > delta
  (setq vjump--t-target vjump--t-d)
  (vjump--t-jump)                        ; B'→D 中段双推
  (let* ((b (nth 0 (cdr (vjump--tree))))  ; A 的子 = B
         (b-kids (cdr b))                ; B 的子 = [C, B']
         (c (nth 0 b-kids))
         (b2 (nth 1 b-kids)))
    (vjump--t "anchor: B 两岔（C + 漂移点）" (= (length b-kids) 2))
    (vjump--t "anchor: 漂移点挂在 B 下"
              (eq (vjump--rec-live-buf (car b2)) (get-file-buffer vjump--t-b)))
    (vjump--t "anchor: D 挂漂移点下"
              (and (= (length (cdr b2)) 1)
                   (eq (vjump--rec-live-buf (car (nth 0 (cdr b2))))
                       (get-file-buffer vjump--t-d))))
    (vjump--t "anchor: C 不再被挂子" (null (cdr c)))))

  ;; --- 12. 叶子漂移后跳转：出发位置立新节点 ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                        ; A→B：空日志双推
  (setq vjump--t-target vjump--t-c)
  (vjump--t-jump)                        ; B→C：origin 精确同点，只推 destination
  (vjump--t "叶子链: B→C 单推" (= (length vjump--log) 3))
  (goto-char 50)                         ; 在 C 漂移 49（< delta，非同点）
  (setq vjump--t-target vjump--t-d)
  (vjump--t-jump)                        ; C'→D：出发位置立新节点
  (vjump--t "叶子漂移: 双记录入账" (= (length vjump--log) 5))
  (let* ((b (nth 0 (cdr (vjump--tree))))
         (c (nth 0 (cdr b)))
         (c2 (nth 0 (cdr c)))
         (d (nth 0 (cdr c2))))
    (vjump--t "叶子漂移: C' 挂 C 下"
              (eq (vjump--rec-live-buf (car c2)) (get-file-buffer vjump--t-c)))
    (vjump--t "叶子漂移: D 挂 C' 下"
              (eq (vjump--rec-live-buf (car d)) (get-file-buffer vjump--t-d)))
    (vjump--t "叶子漂移: 链无岔" (= (length (cdr b)) 1)))

  ;; --- 13. 访问规则三联：叶子延链 / 回访分岔 / mark 延链 ---
  ;; 契约：新节点（跳转 origin 与 vjump-mark 同规则）挂最后访问节点（log[cur]）下，
  ;; 叶子即延链，非叶即分岔；mark 移动后标记同 origin 立新节点。
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                         ; A→B
  (setq vjump--t-target vjump--t-c)
  (vjump--t-jump)                         ; B→C
  (goto-char 50)                          ; C 上移动到另一位置（< delta）
  (setq vjump--t-target vjump--t-d)
  (vjump--t-jump)                         ; C'→D：叶子延链
  ;; vjump-list RET 的提交语义：cur 置到选中记录 + goto（log=[D,C',C,B,A]）
  (setq vjump--cur 3)
  (vjump--goto (nth 3 vjump--log))
  (goto-char 400)                         ; B 上移动到 F
  (setq vjump--t-target vjump--t-e)
  (vjump--t-jump)                         ; F→G：B 下分岔
  (goto-char 40)                          ; G 上移动数行（< delta）
  (vjump-mark)                            ; H：mark 延链
  (let* ((root (vjump--tree))
         (b (nth 0 (cdr root)))
         (kids (cdr b))
         (c (nth 0 kids))
         (f (nth 1 kids)))
    (vjump--t "规则: B 两岔（叶子链 + 回访岔）" (= (length kids) 2))
    (vjump--t "规则: 叶子延链 C→C'→D"
              (and (= (length (cdr c)) 1)
                   (= (vjump--rec-point (car (nth 0 (cdr c)))) 50)
                   (= (length (cdr (nth 0 (cdr c)))) 1)
                   (eq (vjump--rec-live-buf
                        (car (nth 0 (cdr (nth 0 (cdr c))))))
                       (get-file-buffer vjump--t-d))))
    (vjump--t "规则: 回访分岔 F 挂 B 下"
              (and (eq (vjump--rec-live-buf (car f))
                       (get-file-buffer vjump--t-b))
                   (= (vjump--rec-point (car f)) 400)))
    (let* ((g (nth 0 (cdr f)))
           (h (nth 0 (cdr g))))
      (vjump--t "规则: 目的地 G 挂 F 下"
                (eq (vjump--rec-live-buf (car g))
                    (get-file-buffer vjump--t-e)))
      (vjump--t "规则: mark 移动立 H 挂 G 下"
                (and (= (length (cdr g)) 1)
                     (eq (vjump--rec-live-buf (car h))
                         (get-file-buffer vjump--t-e))
                     (= (vjump--rec-point (car h)) 40)
                     (vjump--rec-origin-p (car h))))))

  ;; --- 14. 忽略清单 ---
  (vjump--t-reset '(vjump--t-jump))
  (setq vjump-ignored-buffers '("b\\.txt"))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                          ; 到达端命中
  (vjump--t "忽略: 到达端命中不入账" (= (length vjump--log) 0))
  (find-file vjump--t-b)                   ; 站进忽略 buffer
  (goto-char 250)
  (setq vjump--t-target vjump--t-c)
  (vjump--t-jump)                          ; 出发端命中
  (vjump--t "忽略: 出发端命中不入账" (= (length vjump--log) 0))
  (find-file vjump--t-b)
  (vjump-mark)
  (vjump--t "忽略: mark 命中不入账" (= (length vjump--log) 0))
  (setq vjump-ignored-buffers '("*vjump")) ; 还原默认，验证默认清单
  (let ((tmp (get-buffer-create "*vjump-list*")))
    (vjump--t "忽略: 默认清单含 vjump 自有 buffer"
              (vjump--buffer-ignored-p tmp))
    (kill-buffer tmp))

  ;; --- 15. 重访合并后的光标定位（不落末行） ---
  (vjump--t-reset '(vjump--t-jump))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-target vjump--t-b)
  (vjump--t-jump)                          ; A→B
  (setq vjump--t-target vjump--t-a)
  (vjump--t-jump)                          ; B→A 重访，旧 A 并入根节点
  (vjump-back)
  (vjump-back)                             ; cur → 旧 A（已被合并）
  (let ((tmp (get-buffer-create " *vjump-cursor*")))
    (with-current-buffer tmp
      (setq vjump--sel-rec (nth vjump--cur vjump--log))
      (let ((inhibit-read-only t))
        (erase-buffer)
        (vjump--grid-render))
      (vjump-list--goto-sel)
      (vjump--t "光标: 定位在节点上不落末行"
                (and (not (eobp))
                     (get-text-property (point) 'vjump-rec)))
      (vjump--t "光标: 并入节点画 x"
                (string-match-p "x" (buffer-string))))
    (kill-buffer tmp))

  ;; --- 16. 同步小跳入账 + 异步防漂移仍生效 ---
  (vjump--t-reset '(vjump--t-goto))
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-dest 60)                  ; 同文件 50 字符（< delta）
  (vjump--t-goto)
  (vjump--t "同步小跳: 双记录入账" (= (length vjump--log) 2))
  (let* ((root (vjump--tree))
         (n1 (nth 0 (cdr root))))
    (vjump--t "同步小跳: 树上两个独立节点"
              (and (= (length (cdr root)) 1)
                   (= (vjump--rec-point (car root)) 10)
                   (= (vjump--rec-point (car n1)) 60)
                   (null (cdr n1)))))
  ;; 异步采样防漂移：挂起后同文件小位移不算落位
  (setq vjump--log nil
        vjump--cur 0
        vjump--pending (cons (current-buffer) 10))
  (goto-char 40)
  (vjump--pending-commit)
  (vjump--t "异步小位移: 不入账且仍挂起"
            (and (null vjump--log)
                 vjump--pending))
  (vjump--cancel-pending)
  ;; 相近节点唯一选中：sel-rec 容差不得把邻居也标成 x（多 x bug）
  (find-file vjump--t-a)
  (goto-char 10)
  (setq vjump--t-dest 60)
  (vjump--t-goto)                         ; 重建两条相近记录（< delta）
  (setq vjump--sel-rec (nth 0 vjump--log)
        vjump--cur 0)
  (let ((tmp (get-buffer-create " *vjump-multix*")))
    (with-current-buffer tmp
      (setq vjump--sel-rec (nth 0 vjump--log)) ; sel-rec 是 buffer-local，须在本 buffer 置值
      (let ((inhibit-read-only t))
        (erase-buffer)
        (vjump--grid-render))
      (vjump--t "唯一选中: 相近节点只画一个 x"
                (= 1 (count-matches "x" (point-min) (point-max)))))
    (kill-buffer tmp)))

(defun vjump-self-test ()
  "运行内置行为断言。
批量模式（check.sh）以 exit code 裁决；交互模式打印结果并返回非 nil 表示全绿。"
  (interactive)
  (setq vjump--t-pass 0
        vjump--t-fail 0
        vjump--t-dir (make-temp-file "vjump-t-" t)
        vjump--t-a (vjump--t-file "a.txt")
        vjump--t-b (vjump--t-file "b.txt")
        vjump--t-c (vjump--t-file "c.txt")
        vjump--t-d (vjump--t-file "d.txt")
        vjump--t-e (vjump--t-file "e.txt"))
  (unwind-protect
      (condition-case err
          (vjump--t-all)
        (error (cl-incf vjump--t-fail)
               (message "  FAIL 意外错误: %S" err)))
    (when vjump-mode (vjump-mode -1)))
  (let ((okp (zerop vjump--t-fail)))
    (message "RESULT: %d pass / %d fail" vjump--t-pass vjump--t-fail)
    (if noninteractive
        (kill-emacs (if okp 0 1))
      okp)))

(provide 'vjump-test)
;;; vjump-test.el ends here
