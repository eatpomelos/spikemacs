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

;; 使用 posframe 实现一个简单的弹窗来显示 info 模式下的快捷键，参考 posframe 提供的 demo
(defvar spk-info-mode-pos-buf " *spk-info-posframe-buffer*")
(defvar spk-bulletin-help-alist nil "alist for mode update function.")
(defvar spk-bulletin-tmp-ctx nil "temp context.")

;; 增加一个函数用于显示临时内容
(defun spk/set-pos-buf-ctx (&optional input)
  "set current marked text to posfram buffer."
  (interactive)
  (let* ((buf-ctx (cond
                  (input (format "%s" input)) ; 强制转换为字符串
                  ((use-region-p) (buffer-substring (region-beginning) (region-end)))
                  (t ""))))
    (unless input
      (setq spk-bulletin-tmp-ctx buf-ctx))
    (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
      (erase-buffer)
      (insert buf-ctx)
      ))
  )

(defun spk/reset-pos-buf-ctx ()
  (interactive)
  (setq spk-bulletin-tmp-ctx nil))

;; 在 Info 模式下提供一个快速查看快捷键的函数   
(defun spk/bulletin-peek ()
  "Info help peek."
  (interactive)
  (when (posframe-workable-p) 
    (posframe-show spk-info-mode-pos-buf
                   :background-color (face-background 'default nil t)
                   :foreground-color (face-foreground 'font-lock-string-face nil t)
                   :internal-border-width 2
                   :left-fringe 7
                   :right-fringe 7
                   :y-pixel-offset 25
                   :lines-truncate t
                   :internal-border-color (face-background 'highlight) ; 极弱对比度
                   :override-parameters	'((alpha . 95))
                   :position (point))
    (unwind-protect
        (sit-for 10)
      (posframe-hide spk-info-mode-pos-buf))
    )
  )

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
  (spk/bulletin-peek))

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
		(if (functionp 'counsel-find-file) 
			(counsel-find-file directory)
		  (find-file directory))
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
		(setq selected-line (ivy-read (format hint keyword directory (spk/time-cost time))
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
