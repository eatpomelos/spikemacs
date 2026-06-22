;; 用来存放一些常用的函数以及宏,以及一些常用的接口  -*- lexical-binding: t; -*-
;; doom中定义的一些使用的值
(defconst EMACS27+ (> emacs-major-version 26))
(defconst EMACS27- (< emacs-major-version 27))
(defconst EMACS28+ (> emacs-major-version 27))
(defconst EMACS28- (< emacs-major-version 28))
(defconst EMACS29+ (> emacs-major-version 28))
(defconst EMACS29- (< emacs-major-version 29))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))
(defconst IS-WSL    (and IS-LINUX (string-match "Microsoft" (shell-command-to-string "uname -r"))))
(defconst IS-NIXOS (string= (system-name) "nixos"))

;; 使用 posframe 暂时实现一些简单的需求
(straight-use-package 'posframe)
(require 'posframe)

(if (display-graphic-p)
   (straight-use-package
    '(popon :host nil :repo "https://codeberg.org/akib/emacs-popon.git"))
  (straight-use-package 'popon)
  )
(require 'popon)

;; 用来存放当前活跃的 TUI popon 实例引用
(defvar spk-bulletin-active-popon nil "Current active popon instance for TUI.")
(defvar spk-bulletin-hide-timer nil "Timer to hide the bulletin window.")

;; 使用 posframe 实现一个简单的弹窗来显示 info 模式下的快捷键，参考 posframe 提供的 demo
(defvar spk-info-mode-pos-buf " *spk-info-posframe-buffer*")
(defvar spk-bulletin-help-alist nil "alist for mode update function.")
(defvar spk-bulletin-tmp-ctx nil "temp context.")

(defun spk--blind-find-file-in-dir (dir-or-symbol)
  "通用核心：支持传入全局变量符号或直接传入路径字符串，唤醒 Vertico 补全。
DIR-OR-SYMBOL 可以是变量符号（如 'spk-elisp-dir），也可以是路径字符串。"
  (let ((dir-path (cond
                   ((and (symbolp dir-or-symbol) (boundp dir-or-symbol))
                    (symbol-value dir-or-symbol))
                   ((stringp dir-or-symbol)
                    dir-or-symbol)
                   (t nil))))
    
    ;; 统一展开波浪号并进行防御性检查
    (if dir-path
        (setq dir-path (expand-file-name dir-path)))
    
    (if (and dir-path (file-directory-p dir-path))
        ;; 核心魔法：临时切换目录上下文，完美唤醒 Vertico 并拦截 Dired
        (let ((default-directory dir-path))
          (call-interactively #'find-file))
      (message "错误：[%s] 路径未定义或目录不存在！" dir-path))))

(defun spk/completing-read (prompt candidates &optional default)
  "通用的带注解补全函数。
PROMPT 是提示字符串。
CANDIDATES 是 ((\"key\" . \"desc\")) 格式的 alist 或字符串列表。
DEFAULT 是默认值。"
  (completing-read 
   prompt
   (lambda (string pred action)
     (if (eq action 'metadata)
         `(metadata (annotation-function 
                     . ,(lambda (s)
                          (let ((desc (cdr (assoc s candidates))))
                            (if (stringp desc) (format " -- %s" desc) "")))))
       (complete-with-action action candidates string pred)))
   nil t nil nil default))

;; 增加一个函数用于显示临时内容
(defun spk/set-pos-buf-ctx (&optional input start-line line-limit)
  "set current marked text to posfram buffer."
  (interactive)
  (let* ((raw-ctx (cond
                   (input (format "%s" input)) ; 强制转换为字符串
                   ((use-region-p) (buffer-substring (region-beginning) (region-end)))
                   (t "")))
         (full-path (when (and raw-ctx (not (string-empty-p raw-ctx)))
                      (expand-file-name raw-ctx))))
    (unless input
      (setq spk-bulletin-tmp-ctx raw-ctx))
    (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
      (let* ((inhibit-read-only t))
        (erase-buffer)
        (cond
         ((and full-path (file-exists-p full-path) (file-regular-p full-path))
          (progn
            (insert-file-contents full-path nil 0 5000)
            (when start-line 
              (goto-char (point-min))
              (forward-line start-line)
              (delete-region (point-min) (point)))
            (when line-limit
              (goto-char (point-min))
              (forward-line line-limit)
              (delete-region (point) (point-max)))
            ))
         (t (insert raw-ctx))
         ))))
  )

(defun spk/reset-pos-buf-ctx ()
  (interactive)
  (setq spk-bulletin-tmp-ctx nil))

(defun spk/bulletin--peek-gui (sticky)
  "内部函数：处理 GUI 模式下的 posframe 渲染。"
  (when (and (fboundp 'posframe-workable-p) (posframe-workable-p))
    ;; 清理可能残留的 TUI 组件
    (when spk-bulletin-active-popon
      (popon-kill spk-bulletin-active-popon)
      (setq spk-bulletin-active-popon nil))

    ;; 喧染 GUI 弹窗
    (posframe-show spk-info-mode-pos-buf
                   :background-color (face-background 'lazy-highlight nil t)
                   :foreground-color (face-foreground 'default nil t)
                   :internal-border-width 2
                   :left-fringe 7
                   :right-fringe 7
                   :y-pixel-offset 25
                   :max-width 100
                   :lines-truncate t
                   :internal-border-color (face-foreground 'warning nil t)
                   :override-parameters '((alpha . 95))
                   :position (point))

    ;; 注册消隐
    (setq spk-bulletin-hide-timer
          (run-with-timer (if sticky 15 6) nil
                          (lambda ()
                            (posframe-hide spk-info-mode-pos-buf)
                            (setq spk-bulletin-hide-timer nil))))))

(defun spk/bulletin--peek-tui (sticky)
  "内部函数：处理 TUI 模式下的 popon 文本矩阵渲染。"
  (when (featurep 'popon)
    ;; 物理清理上一次的浮窗 Overlay
    (when spk-bulletin-active-popon
      (popon-kill spk-bulletin-active-popon)
      (setq spk-bulletin-active-popon nil))

    (let ((ctx-string (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
                        (buffer-string))))
      (unless (string-empty-p ctx-string)
        (let ((pos (popon-x-y-at-pos (point))))
          (when pos
            (setcdr pos (1+ (cdr pos))) ; Y坐标加 1 下移一行，防遮挡光标
            (setq spk-bulletin-active-popon (popon-create ctx-string pos))

            ;; 注册 TUI 异步销毁
            (setq spk-bulletin-hide-timer
                  (run-with-timer (if sticky 15 6) nil
                                  (lambda ()
                                    (when spk-bulletin-active-popon
                                      (popon-kill spk-bulletin-active-popon)
                                      (setq spk-bulletin-active-popon nil))
                                    (setq spk-bulletin-hide-timer nil))))))))))

(defun spk/bulletin--peek-tui (sticky)
  "内部函数：处理 TUI 模式下的 popon 文本矩阵渲染，并注册按键后自动销毁钩子。"
  (when (featurep 'popon)
    ;; 物理清理上一次的浮窗 Overlay
    (when spk-bulletin-active-popon
      (popon-kill spk-bulletin-active-popon)
      (setq spk-bulletin-active-popon nil))

    (let ((ctx-string (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
                        (buffer-string))))
      (unless (string-empty-p ctx-string)
        (let ((pos (popon-x-y-at-pos (point))))
          (when pos
            (setcdr pos (1+ (cdr pos))) ; Y坐标加 1 下移一行，防遮挡光标
            (setq spk-bulletin-active-popon (popon-create ctx-string pos))

            (add-hook 'post-command-hook #'spk/bulletin--tui-auto-close-hook)

            ;; 注册 TUI 异步超时销毁
            (setq spk-bulletin-hide-timer
                  (run-with-timer (if sticky 15 6) nil
                                  (lambda ()
                                    (spk/bulletin--cleanup-tui-popon))))))))))

;; tui自动移除的hook
(defun spk/bulletin--cleanup-tui-popon ()
  "内部工具：物理销毁 TUI 弹窗并卸载相关钩子。"
  (when spk-bulletin-active-popon
    (popon-kill spk-bulletin-active-popon)
    (setq spk-bulletin-active-popon nil))
  ;; 务必移除钩子，防止常驻后台消耗性能
  (remove-hook 'post-command-hook #'spk/bulletin--tui-auto-close-hook))

(defun spk/bulletin--tui-auto-close-hook ()
  "内部钩子：当用户执行了任何按键命令后，自动关闭 TUI 浮窗。"
  ;; 将 smart 版本和 M-x 扩展命令加入白名单，防止误杀
  (unless (memq this-command '( spk/bulletin-peek 
                                spk/smart-bulletin-peek 
                                execute-extended-command))
    (spk/bulletin--cleanup-tui-popon)))

(defun spk/bulletin-peek (&optional sticky)
  "Info help peek (non-blocking version)."
  (interactive)
  (if (is-gui)
      (spk/bulletin--peek-gui sticky)
    (spk/bulletin--peek-tui sticky))
  )

(defun spk/bulletin-close ()
  "Manually close the bulletin posframe and cancel any active timers."
  (interactive)
  ;; 1. 取消隐藏计时器
  (when (timerp spk-bulletin-hide-timer)
    (cancel-timer spk-bulletin-hide-timer)
    (setq spk-bulletin-hide-timer nil))
  ;; 2. 隐藏窗口
  (posframe-hide spk-info-mode-pos-buf)
  (message "Bulletin closed."))

(defun spk/tiny-vc-msg ()
  (interactive)
  (let* ((file (buffer-file-name))
         (line (line-number-at-pos))
         ;; 使用 magit 提供的底层函数，绕过 shell 解析，速度更快且支持远程 TRAMP 文件
         (rev (magit-git-string "blame" "-L" (format "%d,%d" line line) "-p" file)))
    (when rev
      (let* ((hash (car (split-string rev " ")))
             (msg-str (magit-rev-format "%h %an %ad %s" hash)))
        (spk/set-pos-buf-ctx (or msg-str "current line not commit."))))))

;; 设置一个函数更新bulletin内容
(defun spk/update-bulletin-content ()
  "update bulltin content."
  (let* ((update-func (cdr (assoc major-mode spk-bulletin-help-alist))))
    (cond
     (update-func (call-interactively update-func))
     ((vc-root-dir) (spk/tiny-vc-msg))
     (t (spk/set-pos-buf-ctx "bulletin is null"))
     ))
  )

(defun spk/smart-bulletin-peek ()
  "Smart bulletin peek."
  (interactive)
  ;; 没有设置tmp内容才更新
  (unless spk-bulletin-tmp-ctx
    (spk/update-bulletin-content))
  (call-interactively 'spk/bulletin-peek))

(defun is-gui ()
  (display-graphic-p))

(defun is-tui ()
 (not (display-graphic-p)))

(defmacro +spk-get-memavailable ()
  `(string-to-number (shell-command-to-string "grep MemAvailable /proc/meminfo | awk '{print $2}'")))

;; 基于当前文件比较简单的情况，features名和文件名一致才可以
(defmacro spk-require (feature)
  `(when (file-exists-p (concat ,spk-elisp-dir (format "%s.el" ,feature)))
     (require ,feature)))

;; MACROS
;; 把斜线转换成反斜线
(defmacro +spk-slash-2-backslash (str)
  `(replace-regexp-in-string "/" "\\\\" ,str nil nil 0))

;; 此函数在windows下不区分大小写，这会导致在一些时候拿取路径会出错 
(defmacro +spk-get-file-dir (file)
  `(locate-dominating-file default-directory ,file))

;; 输入一个文件名，并在当前的路径搜索这个文件，返回这个文件的完整路径
(defmacro +spk-get-complete-file (file-name)
  `(let* ((files-dir (+spk-get-file-dir ,file-name)))
	 (when files-dir
	   (concat files-dir ,file-name))))

;; 设置不同语言的特定文件类型，由于需求比较简单，暂时不考虑使用auto-mode-alist 
(setq spk-lang-file-type-postfix-alist
      '( (c-mode . "\\.[ch]")
		 (cc-mode . "\\.[ch]")
		 (emacs-lisp-mode . "\\.el")
		 ))

(defmacro +spk-current-buffer-file-postfix ()
  `(cdr (assoc major-mode spk-lang-file-type-postfix-alist)))

;;;###autoload
(defun spk/basic-adv-cmd (basic-cmd adv-cmd)
  "Enhance basic functionality."
  (call-interactively basic-cmd)
  ;; 激活一个临时键图，有效期内按下同一个键执行另一个函数
  (set-transient-map
   (let ((map (make-sparse-keymap)))
     (define-key map (this-command-keys) adv-cmd)
     map)
   t)
  )

;;;###autoload
(defun spk/time-cost (start-time)
  "Just like `counsel-etags--time-cost'."
  (let* ((time-passed (float-time (time-since start-time))))
	(format "%.02f seconds"
			time-passed)))

;; 能不能改成异步执行，避免阻塞emacs？执行这个命令的时候，会导致emacs卡死，可能由于后台执行的命令引起的，实际上在后台运行此命令也会导致卡死，在大型项目中谨慎使用 
;;;###autoload
(defun spk-search-file-internal (directory open-p &optional grep-p symbol pfix)
  "Find/Search file in DIRECTORY.
If GREP-P is t, grep files .
If GREP-P is nil, find files.
If symbols is nil, input a string to replace symbol.
pfix is the postfix of file"
  (let* ((keyword (if symbol symbol
					(read-string "Please input keyword: "))))
    (if (string= keyword "")
        (spk--blind-find-file-in-dir directory)
      ;; 当没有给后缀的时候默认为任意字符
      (let* ((postfix (if pfix pfix ""))
			 (find-cmd (format "find %s -path \"*/.git\" -prune -o -type f -regex \"^.*%s.*%s\" -print"
							   (expand-file-name directory) (if grep-p ".*" keyword) postfix))
			 (grep-cmd (format "grep -rsn -e \"%s\"" keyword))
			 ;; (grep-cmd (format "rg \"%s\"" keyword))
			 ;; 用来记录执行命令使用的时间
			 (time (current-time))
			 (exec-cmd (if grep-p
						   (concat find-cmd (format " | xargs %s" grep-cmd))
						 find-cmd))
			 (output (shell-command-to-string exec-cmd))
			 (lines (split-string output "[\n\r]+"))
			 (hint (if grep-p "Grep (%s) in %s (%s)" "Find (%s) in %s (%s)"))
			 selected-line
			 selected-file
			 linenum)
		(setq selected-line (spk/completing-read (format hint keyword directory (spk/time-cost time))
									  lines))
		(cond
		 (grep-p
		  (when (string-match "^\\([^:]*:?[^:]*\\):\\([0-9]*\\):"
							  selected-line)
			(setq selected-file (match-string 1 selected-line))
			(setq linenum (match-string 2 selected-line))
			))
		 (t
		  (setq selected-file selected-line))
		 )
		(when (and selected-line (file-exists-p selected-file))
          (if open-p
              (progn
		        (find-file selected-file)
		        (when linenum
			      (goto-line (string-to-number linenum))))
            selected-file))
		))))

;; 切换到scratch 缓冲区
;;;###autoload
(defun spk/switch-to-scratch ()
  "Switch to scratch buffer."
  (interactive)
  (save-excursion
    (switch-to-buffer "*scratch*")))

;; 把列表中的某一项删除，catch-throw 类似return的用法
;;;###autoload
(defun spk/delete-list-element (n list)
  "Delete a element"
  (let* (;; 获取后面的部分
	 (nlist (nthcdr n list))
	 (head_len n))
    (catch 'ret
      (when (or (> n (length list)) (not (listp list)))
	(print (format "error length %d" n))
	(throw 'ret list))
      (pop nlist)
      (while (>= (1- head_len) 0)
	(push (nth (1- head_len) list) nlist)
	(setq head_len (1- head_len))))
    nlist)
  )

;; 基于overlay显示一个字符串
;;;###autoload
(defun spk/display-string-base-overlay (string)
  (when (stringp string)
    (save-mark-and-excursion
      (let ((ov (make-overlay (point) (1+ (point)))))
        (overlay-put ov 'display
                     (format "%s" string))
        (overlay-put ov 'face 'region)
        (sit-for 3)
        (delete-overlay ov)))))

;;;###autoload
(defun spk--point-in-overlay-p (overlay)
  "Retuen t is point in overlay."
  (let* ((pos 0))
    (catch 'tag 
      (while (nth pos overlay)
	    (when (and
               (eq (current-buffer) (overlay-buffer (nth pos overlay)))
               (<= (point) (overlay-end (nth pos overlay)))
		       (>= (point) (overlay-start (nth pos overlay))))
	      (throw 'tag pos))
	    (setq pos (1+ pos))
	    ))))

(provide 'init-lib)
