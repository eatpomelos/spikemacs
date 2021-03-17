;; 用来存放一些常用的函数以及宏,以及一些常用的接口
;; doom中定义的一些使用的值
(defconst EMACS27+ (> emacs-major-version 26))
(defconst EMACS28+ (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

;; 把斜线转换成反斜线
(defmacro slash-2-backslash (str)
  (list 'replace-regexp-in-string "/" "\\\\" str nil nil 0))

;; 根据find命令的方式查找文件，当不输入关键字的时候，直接用 . 代替 
;;;###autoload
(defun spk-find-file-internal (directory)
  "Find file in DIRECTORY."
  (let* ((keyword (read-string "Please input keyword: ")))
    (when (string= keyword "")
      (setq keyword "."))
    (let* ((cmd (format "find . -path \"*/.git\" -prune -o -type f -regex \"^.*%s\" -print" keyword))
           (default-directory directory)
           (tcmd "fd \".*\\.png\" ~/tmp")
           (output (shell-command-to-string cmd))
           (lines (cdr (split-string output "[\n\r]+")))
           selecttd-line)
      (setq selecttd-line (ivy-read (format "Find file in %s:" default-directory)
                                    lines))
      (when (and selecttd-line (file-exists-p selecttd-line))
	(find-file selecttd-line))
      )))

;; 切换到scratch 缓冲区
;;;###autoload
(defun spk-switch-to-scratch ()
  (interactive)
  (save-excursion
    (switch-to-buffer "*scratch*")))

;; 把列表中的某一项删除，主要完成把前面和后面进行一个拼接
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

;;;###autoload
(defun spk/highlight-clear (ovs)
  "Cleatr highlight line."
  (mapcar #'delete-overlay ovs)
  nil)

(provide 'init-lib)
