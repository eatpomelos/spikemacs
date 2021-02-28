;; 用来存放一些常用的函数以及宏,以及一些常用的接口
;; doom中定义的一些使用的值
(defconst EMACS27+ (> emacs-major-version 26))
(defconst EMACS28+ (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

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

(provide 'spk-lib)
