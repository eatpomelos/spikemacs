;; 用来存放一些常用的函数以及宏,以及一些常用的接口
;; doom中定义的一些使用的值
(defconst EMACS27+ (> emacs-major-version 26))
(defconst EMACS28+ (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

(defconst GOOGLE-SEARCH "https://www.google.com.hk/search?q=")

(defvar spk-debug-line nil
  "Line number for debug.")
(defmacro +spk-debug ()
  `(setq spk-debug-line (line-number-at-pos)))

;; 把斜线转换成反斜线
(defmacro +slash-2-backslash (str)
  `(replace-regexp-in-string "/" "\\\\" ,str nil nil 0))

;; 建立alist 来智能检索文件已经在检索到的文件中查找特定字符串

;; 设置不同语言的特定文件类型，由于需求比较简单，暂时不考虑使用auto-mode-alist 
(setq spk-lang-file-type-postfix-alist
      '( (c-mode . "\\.[ch]")
	 (cc-mode . "\\.[ch]")
	 (emacs-lisp-mode . "\\.el")
	 ))

(defmacro +spk-current-buffer-file-postfix ()
  `(cdr (assoc major-mode spk-lang-file-type-postfix-alist)))

;; 在google浏览其中搜索当前光标位置的符号，后续改进
;;;###autoload
(defun spk/search-symbol-at-point-with-browser ()
  "Search symbol in browser."
  (interactive)
  (browse-url (format "%s%s" GOOGLE-SEARCH (symbol-at-point))))

;;;###autoload
(defun spk/time-cost (start-time)
  "Just like `counsel-etags--time-cost'."
  (let* ((time-passed (float-time (time-since start-time))))
	(format "%.01f second%s"
			time-passed
			(if (<= time-passed 2) "" "s"))
	))

;;;###autoload
(defun spk-search-file-internal (directory &optional grep-p symbol pfix)
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
			 (grep-cmd (format "grep -rsn \"%s\"" keyword))
			 ;; (grep-cmd (format "rg \"%s\"" keyword))
			 ;; 用来记录执行命令使用的时间
			 (time (current-time))
			 (exec-cmd (if grep-p
						   (concat find-cmd (format " | xargs %s" grep-cmd))
						 find-cmd))
			 (output (shell-command-to-string exec-cmd))
			 (lines (split-string output "[\n\r]+"))
			 (hint (if grep-p "Grep file in %s (%s)" "Find file in %s (%s)"))
			 selected-line
			 selected-file
			 linenum)
		(setq selected-line (ivy-read (format hint directory (spk/time-cost time))
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
		  (find-file selected-file)
		  (when linenum
			(goto-line (string-to-number linenum))))
		))))

;; 切换到scratch 缓冲区
;;;###autoload
(defun spk-switch-to-scratch ()
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

;;;###autoload
(defun spk--point-in-overlay-p (overlay)
  "Retuen t is point in overlay."
  (let* ((pos 0))
    (catch 'tag 
      (while (nth pos overlay)
	(when (and (<= (point) (overlay-end (nth pos overlay)))
		   (>= (point) (overlay-start (nth pos overlay))))
	  (throw 'tag pos))
	(setq pos (1+ pos))
	))))

;; 测试用函数，暂时用来清除自定义的overlay
(defun spk-clear-spk-ovs ()
  (interactive)
  (spk/highlight-clear spk-ovs))

;;;###autoload
(defun spk/highlight-clear (ovs)
  "Cleatr highlight line."
  (mapcar #'delete-overlay ovs)
  nil)

(provide 'init-lib)
