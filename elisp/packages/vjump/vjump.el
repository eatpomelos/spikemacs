;;; vjump.el --- Linear append-only jump history -*- lexical-binding: t; -*-

;; Copyright (C) 2026  spikely
;; Author: spikely <spikeluoyu@outlook.com>
;; Keywords: navigation
;; Package-Requires: ((emacs "28.1"))

;; vjump：跳转历史。记录 xref/lsp 等命令产生的跳转，back/forward 导航，
;; vjump-list 把日志渲染成探索树；行为断言在 vjump-test.el。
;; 设计要点：日志即真相（append-only，newest-first）；树从日志渲染期派生，

;;; Code:

(require 'cl-lib)

(defgroup vjump nil
  "Linear jump history."
  :group 'applications)

(defcustom vjump-functions
  '(xref-find-definitions xref-find-references lsp-bridge-find-def)
  "跳转命令清单，执行前后位置被记录。
改此清单后需关闭再开启 vjump-mode 重新挂载 advice。
advice 可以加在尚未定义的符号上，惰性加载的命令（如 lsp-bridge）
定义后自动纳入采集。"
  :type '(repeat function))

(defcustom vjump-limit 200
  "日志上限，超出时从最旧端截断。"
  :type 'natnum)

(defcustom vjump-position-delta 100
  "异步采样防漂移阈值：挂起跳转在同 buffer 内位移小于该值，视为仍在等待落位。
另作 anchor 查找与列表选中兜底的容差。同步跳转不受此限（零位移才不算跳）。"
  :type 'natnum)

(defcustom vjump-ignored-buffers '("*vjump")
  "忽略清单：buffer 名匹配任一正则，该 buffer 的位置即不入账。
默认值 *vjump 覆盖 vjump 自有 buffer（如 *vjump-list*）。
跳转的出发端或到达端任一命中即整次跳转不入账；
vjump-mark 在命中的 buffer 中调用同样不入账。改清单立即生效，无需重开 mode。"
  :type '(repeat regexp))

;; --- 数据层：线性 append-only 日志，newest-first ---
;; spk: 真相 = 线性日志；树（如果有）是渲染期派生态，存储层禁止树结构。

(cl-defstruct (vjump--rec (:constructor vjump--rec-new))
  (marker nil)                          ; 活 buffer 的精确位置
  (file nil)                            ; buffer 死后的回退定位
  (point 1)                             ; 采集时 point，file 回退用（编辑后会漂移）
  (bufname "")                          ; 显示用
  (origin-p nil)                       ; t = origin 推送（树派生的原始事实）
  (anchor nil))                        ; 中段出发时盖的导航记录章（树派生挂靠用）

(defvar vjump--log nil
  "跳转日志，newest-first。log[0] 即最新端。")
(defvar vjump--cur 0
  "当前位置下标。back 使其增大（更旧），forward 使其减小（更新）。")
(defvar vjump--pending nil
  "异步跳转的挂起采集：(origin-buffer . origin-point)。")

(defun vjump--rec-live-buf (rec)
  "REC 的活 buffer，REC 为 nil 或无活 buffer 时返回 nil。"
  (and rec
       (vjump--rec-marker rec)
       (marker-buffer (vjump--rec-marker rec))))

(defun vjump--rec-exact-p (r1 r2)
  "两记录是否同一精确位置（同 buffer 或同文件，且位置相等）。
移动过的 origin 靠它区别于既有节点：跳转前的位置永远立新节点。"
  (and r1 r2
       (let ((b1 (vjump--rec-live-buf r1))
             (b2 (vjump--rec-live-buf r2)))
         (and (cond ((and (buffer-live-p b1) (buffer-live-p b2)) (eq b1 b2))
                    ((and (vjump--rec-file r1) (vjump--rec-file r2))
                     (string= (vjump--rec-file r1) (vjump--rec-file r2)))
                    (t nil))
              (let ((p1 (or (and b1 (marker-position (vjump--rec-marker r1)))
                            (vjump--rec-point r1)))
                    (p2 (or (and b2 (marker-position (vjump--rec-marker r2)))
                            (vjump--rec-point r2))))
                (and p1 p2 (= p1 p2)))))))

(defun vjump--buffer-ignored-p (buf)
  "BUF 名字是否命中忽略清单 vjump-ignored-buffers。"
  (and (buffer-live-p buf)
       (cl-some (lambda (re) (string-match-p re (buffer-name buf)))
                vjump-ignored-buffers)))

(defun vjump--anchor-rec ()
  "出发时的当前记录（log[cur]），作 origin 的 anchor 章。"
  (nth vjump--cur vjump--log))

(defun vjump--make-rec (buf pt origin-p &optional anchor)
  "在 BUF 的 PT 处造一条记录，ORIGIN-P 标记推送角色，ANCHOR 为导航记录。"
  (with-current-buffer buf
    (vjump--rec-new
     :marker (copy-marker pt)
     :file (buffer-file-name)
     :point pt
     :bufname (buffer-name)
     :origin-p origin-p
     :anchor anchor)))

(defun vjump--push (rec)
  "REC 入账（push 到最新端），并执行上限截断与列表自动刷新。"
  (push rec vjump--log)
  (setq vjump--cur 0)
  (when (and (> vjump-limit 0)
             (> (length vjump--log) vjump-limit))
    (setcdr (nthcdr (1- vjump-limit) vjump--log) nil))
  (vjump--refresh-list))

(defun vjump--commit (o-buf o-pt &optional async-p)
  "确认一次位移是否构成跳转，构成则入账。返回非 nil 表示已入账。
ASYNC-P 为异步采样（lsp-bridge 落位采样）：同 buffer 位移在 delta 内
视为仍在等落位（防漂移噪声）；同步命令零位移才不算跳——跳了即事实，
去重职责在树派生的精确合并。"
  (let ((d-buf (current-buffer))
        (d-pt (point)))
    (when (and (buffer-live-p o-buf)
               (not (vjump--buffer-ignored-p o-buf))
               (not (vjump--buffer-ignored-p d-buf))
               (not (and (eq o-buf d-buf)
                         (if async-p
                             (< (abs (- o-pt d-pt)) vjump-position-delta)
                           (= o-pt d-pt)))))
      (let* ((anchor (vjump--anchor-rec))
             (o-rec (vjump--make-rec o-buf o-pt t anchor))
             (d-rec (vjump--make-rec d-buf d-pt nil)))
        ;; 出发位置与当前记录精确同点（未移动）才跳过 origin；
        ;; 移动过（哪怕几行）即双记录 [origin, destination]——
        ;; back 先回出发位置，树在当前节点下开新枝。
        (unless (and (zerop vjump--cur)
                     (vjump--rec-exact-p o-rec (car vjump--log)))
          (vjump--push o-rec))
        (vjump--push d-rec)
        t))))

(defun vjump--cancel-pending ()
  "作废挂起的异步采集。"
  (setq vjump--pending nil)
  (remove-hook 'post-command-hook #'vjump--pending-commit))

(defun vjump--pending-commit ()
  "采样一次：挂起的异步跳转若已位移则入账。可多次触发直至入账或取消。"
  (when vjump--pending
    (when (vjump--commit (car vjump--pending) (cdr vjump--pending) t)
      (vjump--cancel-pending))))

(defun vjump--capture (fn &rest args)
  "vjump-functions 的 :around advice：采集一次跳转。
同步命令（xref/consult）在 FN 返回时位移已完成；
异步命令（lsp-bridge）位移发生在未来，挂起等下一次命令采样。"
  (vjump--pending-commit)               ; 先结清上次异步跳转（若已落位）
  (let ((o-buf (current-buffer))
        (o-pt (point)))
    (prog1 (apply fn args)
      (unless (and (buffer-live-p o-buf)
                   (vjump--commit o-buf o-pt))
        ;; 无位移：可能为异步跳转，挂起等采样（出发端命中清单的不挂）
        (when (and (buffer-live-p o-buf)
                   (not (vjump--buffer-ignored-p o-buf)))
          (setq vjump--pending (cons o-buf o-pt))
          (add-hook 'post-command-hook #'vjump--pending-commit))))))

(defun vjump--goto (rec)
  "跳到 REC 的位置：marker 优先，file+point 回退。"
  (let ((buf (vjump--rec-live-buf rec)))
    (cond ((buffer-live-p buf)
           (switch-to-buffer buf)
           (goto-char (marker-position (vjump--rec-marker rec))))
          ((vjump--rec-file rec)
           (find-file (vjump--rec-file rec))
           ;; ponytail: file 回退是采集时快照，编辑后漂移不修正；
           ;; 精确恢复需 context-snippet 模糊匹配（二期，见 AGENTS.md 唯一职责）。
           (goto-char (min (vjump--rec-point rec) (point-max))))
          (t
           (message "vjump: 该记录已失效（buffer 已关闭且无文件）")))))

(defun vjump-back ()
  "向更旧方向跳一条。"
  (interactive)
  (vjump--cancel-pending)
  (if (>= (1+ vjump--cur) (length vjump--log))
      (message "vjump: 已到最旧记录")
    (cl-incf vjump--cur)
    (vjump--goto (nth vjump--cur vjump--log))))

(defun vjump-forward ()
  "向更新方向跳一条。"
  (interactive)
  (vjump--cancel-pending)
  (if (zerop vjump--cur)
      (message "vjump: 已到最新记录")
    (cl-decf vjump--cur)
    (vjump--goto (nth vjump--cur vjump--log))))

(defun vjump-mark ()
  "手动记录当前位置（manual record），back 可回到此点。
与自动采集共用同一日志与去重规则；忽略清单命中的 buffer 不记录。"
  (interactive)
  (vjump--cancel-pending)
  (if (vjump--buffer-ignored-p (current-buffer))
      (message "vjump: 此 buffer 在忽略清单中，不记录")
    (let ((rec (vjump--make-rec (current-buffer) (point) t
                                (vjump--anchor-rec))))
      (if (and (zerop vjump--cur)
               (vjump--rec-exact-p rec (car vjump--log)))
          (message "vjump: 当前位置已是记录头")
        (vjump--push rec)
        (message "vjump: 已记录 %s:%d" (buffer-name) (line-number-at-pos))))))

(defun vjump--rec-name (rec)
  "记录的可读名：活 buffer 名，否则文件名，否则采集时 buffer 名。"
  (let ((buf (vjump--rec-live-buf rec)))
    (cond ((buffer-live-p buf) (buffer-name buf))
          ((vjump--rec-file rec)
           (file-name-nondirectory (vjump--rec-file rec)))
          ((not (string= "" (vjump--rec-bufname rec)))
           (vjump--rec-bufname rec))
          (t "?"))))

(defun vjump--rec-line (rec)
  "记录所在行号；buffer 已死返回 -1（无法确定）。"
  (let ((buf (vjump--rec-live-buf rec)))
    (if (buffer-live-p buf)
        (with-current-buffer buf
          (line-number-at-pos (marker-position (vjump--rec-marker rec))))
      -1)))

;; --- 探索树：渲染期派生态，不落存储 ---

(defun vjump--rec-eq-p (r1 r2)
  "两条记录是否同一位置（活 buffer 相同或文件相同，位移在阈值内）。"
  (let ((b1 (vjump--rec-live-buf r1))
        (b2 (vjump--rec-live-buf r2)))
    (and
     (cond ((and (buffer-live-p b1) (buffer-live-p b2)) (eq b1 b2))
           ((and (vjump--rec-file r1) (vjump--rec-file r2))
            (string= (vjump--rec-file r1) (vjump--rec-file r2)))
           (t nil))
     ;; ponytail: 死 buffer 用采集时 point 快照比对，编辑后漂移不修正
     (let ((p1 (or (and b1 (marker-position (vjump--rec-marker r1)))
                  (vjump--rec-point r1)))
           (p2 (or (and b2 (marker-position (vjump--rec-marker r2)))
                  (vjump--rec-point r2))))
       (< (abs (- p1 p2)) vjump-position-delta)))))

(defun vjump--tree-add-child (parent child)
  "加边 PARENT→CHILD，自环与重复边不加。环路由渲染期 visited 防护。"
  (when (and parent (not (eq parent child)))
    (unless (memq child (cdr parent))
      (setcdr parent (append (cdr parent) (list child))))))

(defun vjump--tree ()
  "从日志派生探索树。返回根节点 (rec . children)，子节点同构。
规则：destination 的父节点 = 其时间前驱记录（origin 或 head）；
重访精确同位才合并（origin 与 destination 同规则）；回到祖先的边折叠不渲染。
ponytail: 位置匹配 O(n²)（n ≤ vjump-limit），更大规模换 hash。"
  (let ((nodes nil) (root nil) (prev nil))
    (dolist (rec (reverse vjump--log))
      ;; origin 与 destination 都精确匹配：位置即身份，小步跳转也是独立节点；
      ;; delta 容差只留给异步采样防漂移（vjump--commit）与 anchor/选中兜底
      (let ((node (cl-find rec nodes :key #'car
                           :test #'vjump--rec-exact-p)))
        (cond ((and node (vjump--rec-origin-p rec))
               (setcar node rec))       ; 重访 origin：并入并刷新记录
              (node                     ; 重访 destination：加边并刷新
               (vjump--tree-add-child prev node)
               (setcar node rec))
              (t
               (setq node (cons rec nil))
               ;; origin 为全新位置时挂 anchor 章（导航记录）的节点，
               ;; 而非时间前驱——回去后漂移再跳，岔在回到的节点上。
               ;; anchor 用精确匹配：目标节点与 anchor 恒精确同位（重访
               ;; 合并只在精确同位时发生），容差会被更晚创建的近距子孙
               ;; 节点劫持（mark/分岔挂错父，表现为"不分叉"）
               (let ((p (if (vjump--rec-origin-p rec)
                            (let ((an (vjump--rec-anchor rec)))
                              (or (and an
                                       (cl-find an nodes :key #'car
                                                 :test #'vjump--rec-exact-p))
                                  prev))
                          prev)))
                 (push node nodes)
                 (when p (vjump--tree-add-child p node)))
               (unless root (setq root node))))
        (setq prev node)))
    root))

;; --- 展示层：横向网格 + 预览导航 ---
;; 布局：o--o 主链同行；分岔另起一行，`-- 从父节点列伸出（tree 式）。
;; ponytail: DAG 重访节点会重复绘制（继承旧渲染的天花板）；
;; 窗口宽度变化后按 g 重排。

(defvar-local vjump--sel-rec nil
  "list buffer 内当前光标节点。")
(defvar vjump--preview-win nil
  "打开列表时的原窗口（预览目标）。")
(defvar vjump--restore nil
  "打开列表时的原窗口位置 (buffer . point)，C-g 恢复。")

(defun vjump--sel-p (rec)
  "REC 是否选中节点：sel-rec 本尊，或重访合并后的精确同位节点。
容差匹配会把相近的独立节点全标成 x（多 x bug），合并只发生在精确同位。"
  (or (eq rec vjump--sel-rec)
      (and vjump--sel-rec rec
           (vjump--rec-exact-p vjump--sel-rec rec))))

(defun vjump--place (node row col visited)
  "放置 NODE 子树于 (ROW,COL)，返回 (LAST-ROW . INSTRS)。
INSTRS 元素为 (ROW COL STR REC)；REC 为 nil 表示连接符。
首子同行续列 3（-- 连接）；余子另起一行：父列画分岔符 `，
接 -- 到 col+3（tree 式 `-- 分岔）。VISITED 为祖先路径，环路子跳过。"
  (let ((instrs (list (list row col
                            (if (vjump--sel-p (car node)) "x" "o")
                            (car node))))
        (last row)
        (first t))
    (dolist (c (cdr node))
      (unless (memq c visited)
        (let ((res (if first
                       ;; 首子：同行续列 3，画 -- 连接符
                       (progn
                         (push (list row (+ col 1) "--" nil) instrs)
                         (vjump--place c row (+ col 3) (cons node visited)))
                     ;; 余子：另起一行，`-- 从父节点列伸出
                     (let ((r (+ last 1)))
                       (push (list r col "`" nil) instrs)
                       (push (list r (+ col 1) "--" nil) instrs)
                       (vjump--place c r (+ col 3) (cons node visited))))))
          (setq instrs (append (cdr res) instrs)
                last (car res)
                first nil))))
    (cons last instrs)))

(defun vjump--grid-render ()
  "把探索树按 vjump--place 的布局渲染进当前 buffer。"
  (if (null vjump--log)
      (insert "（空）\n")
    (let* ((root (vjump--tree))
           (instrs (cdr (vjump--place root 0 0 (list root))))
           (maxrow (apply #'max (mapcar #'car instrs)))
           (maxcol (apply #'max
                         (mapcar (lambda (it) (+ (nth 1 it) (length (nth 2 it))))
                                 instrs)))
           (rows (make-vector (1+ maxrow) nil)))
      (dolist (it instrs)
        (push it (aref rows (nth 0 it))))
      (dotimes (r (1+ maxrow))
        ;; 同列先连接符后节点：节点覆盖 |
        (let* ((its (sort (aref rows r)
                          (lambda (a b)
                            (< (+ (nth 1 a) (if (nth 3 a) 1 0))
                               (+ (nth 1 b) (if (nth 3 b) 1 0))))))
               (line (make-vector (1+ maxcol) ?\s))
               (bol (point)))
          (dolist (it its)
            (dotimes (i (length (nth 2 it)))
              (aset line (+ (nth 1 it) i) (aref (nth 2 it) i))))
          (insert (concat line) "\n")
          (dolist (it its)
            (when (nth 3 it)
              (put-text-property (+ bol (nth 1 it)) (+ 1 bol (nth 1 it))
                                 'vjump-rec (nth 3 it)))))))))

(defun vjump-list--goto-sel ()
  "point 移到选中节点字符；sel-rec 被重访合并时按同位匹配兜底。"
  (goto-char (point-min))
  (while (and (not (eobp))
              (not (vjump--sel-p (get-text-property (point) 'vjump-rec))))
    (forward-char)))

(defun vjump-list--preview (rec)
  "在原窗口预览 REC，echo 显示位置。"
  (when (window-live-p vjump--preview-win)
    (with-selected-window vjump--preview-win
      (vjump--goto rec)))
  (message "vjump: %s:%s"
           (vjump--rec-name rec)
           (let ((l (vjump--rec-line rec)))
             (if (< l 0) "?" l))))

(defun vjump-list--select (rec)
  "选中 REC：x 移动、定位、预览。"
  (setq vjump--sel-rec rec)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (vjump--grid-render))
  (vjump-list--goto-sel)
  (vjump-list--preview rec))

(defun vjump-list--step (dl dc)
  "几何步进找节点：DC≠0 同行移动；DL≠0 跨行同列（跳过连接符行）。"
  (let ((col (current-column))
        (found nil))
    (if (zerop dl)
        (progn
          (move-to-column (+ col dc))
          (setq found (get-text-property (point) 'vjump-rec)))
      (while (and (not found) (zerop (forward-line dl)))
        (move-to-column col)
        (setq found (get-text-property (point) 'vjump-rec))))
    (if found
        (vjump-list--select found)
      (vjump-list--goto-sel)
      (message "vjump: 该方向无节点"))))

(defun vjump-list-refresh ()
  "重渲染当前 list buffer（g / 自动刷新共用）。"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (vjump--grid-render))
  (vjump-list--goto-sel))

(defun vjump--refresh-list ()
  "日志变化时刷新打开的 *vjump-list*（选中节点仍有效则保留）。"
  (let ((buf (get-buffer "*vjump-list*")))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (unless (and vjump--sel-rec (memq vjump--sel-rec vjump--log))
          (setq vjump--sel-rec (nth vjump--cur vjump--log)))
        (vjump-list-refresh))
      (let ((win (get-buffer-window buf)))
        (when win
          ;; ponytail: 20 行封顶，树再高靠滚动
          (fit-window-to-buffer win 20 1))))))

(defun vjump-list-left ()
  (interactive)
  (vjump-list--step 0 -3))

(defun vjump-list-right ()
  (interactive)
  (vjump-list--step 0 3))

(defun vjump-list-up ()
  (interactive)
  (vjump-list--step -1 0))

(defun vjump-list-down ()
  (interactive)
  (vjump-list--step 1 0))

(defvar vjump-list-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'vjump-list-jump)
    (define-key map (kbd "C-g") #'vjump-list-cancel)
    (define-key map "q" #'vjump-list-cancel)
    (define-key map "g" #'vjump-list-refresh)
    (define-key map [left] #'vjump-list-left)
    (define-key map [right] #'vjump-list-right)
    (define-key map [up] #'vjump-list-up)
    (define-key map [down] #'vjump-list-down)
    map))

(define-derived-mode vjump-list-mode special-mode "vjump-list"
  "浏览跳转探索树。")

(defun vjump-list--cleanup ()
  (setq vjump--preview-win nil
        vjump--restore nil))

(defun vjump-list-jump ()
  "确认：跳到选中节点（提交 cur）并关闭。"
  (interactive)
  (let* ((rec vjump--sel-rec)
         (idx (and rec (cl-position rec vjump--log))))
    (if idx
        (progn
          (vjump--cancel-pending)
          (setq vjump--cur idx)
          (if (window-live-p vjump--preview-win)
              (with-selected-window vjump--preview-win
                (vjump--goto rec))
            (vjump--goto rec))
          (vjump-list--cleanup)
          (quit-window))
      (message "vjump: 未选中节点"))))

(defun vjump-list-cancel ()
  "取消：恢复打开列表前的位置并关闭。"
  (interactive)
  (when (and (window-live-p vjump--preview-win)
             (buffer-live-p (car vjump--restore)))
    (set-window-buffer vjump--preview-win (car vjump--restore))
    (set-window-point vjump--preview-win (cdr vjump--restore)))
  (vjump-list--cleanup)
  (quit-window))

(defun vjump-list ()
  "弹出探索树（横向 o--o 主链 + `-- 分岔），底部侧窗。
上下左右切换节点并实时预览到原窗口；RET 确认跳转；C-g/q 取消恢复。"
  (interactive)
  (if (eq major-mode 'vjump-list-mode)
      (vjump-list-refresh)
    ;; 结清挂起的异步跳转：此刻原窗口位置即落位点。
    ;; 若不结清，RET 里的 cancel-pending 会把真实跳转丢弃（树冻结在两个节点）
    (vjump--pending-commit)
    (setq vjump--preview-win (selected-window)
          vjump--restore (cons (window-buffer) (window-point)))
    (let ((buf (get-buffer-create "*vjump-list*")))
      (with-current-buffer buf
        (vjump-list-mode)
        (setq vjump--sel-rec (nth vjump--cur vjump--log))
        (vjump-list-refresh))
      (let ((win (display-buffer-in-side-window buf '((side . bottom)))))
        (fit-window-to-buffer win 20 1)
        (select-window win)))))

(define-minor-mode vjump-mode
  "全局跳转历史采集。
对 `vjump-functions' 清单中每个命令挂 :around advice。
advice 可挂于未定义符号，惰性加载的命令定义后自动生效；
改清单后需关闭再开启本 mode。"
  :global t
  (dolist (fn vjump-functions)
    (if vjump-mode
        (advice-add fn :around #'vjump--capture)
      (advice-remove fn #'vjump--capture)))
  (unless vjump-mode
    (vjump--cancel-pending)))

(provide 'vjump)
;;; vjump.el ends here
