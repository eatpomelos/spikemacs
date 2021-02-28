;; 实现的功能是交换剪切板和kill-ring 中的内容
(defun mlet* (steps &rest body)
  (let ((step (car steps))
	(steps (cdr steps)))
    (if step
	;; 这里下面的"`"表示函数backquote 在这里面的表达式，使用,可以取值，使用,@可以去掉列表的括号
	`(when-let (,step)
	   ;; @这里的作用是把后面的括号去掉?
	   (mlet ,steps ,@body))
      `(progn ,@body))))

(defmacro mlet (steps &rest body)
  ;; 说明缩进的规则，使用defun的缩进方式
  (declare (indent defun))
  (apply #'mlet* steps body))

;; 把宏进行展开,并进行打印
(progn
  (forward-line)
  (insert (pp (macroexpand-all
	       '(mlet ((x 1)
		       (y 2)
		       (z 3))
		  (+ x y z))))))

;; (let*
;;     ((x
;;       (and t 1)))
;;   (if x
;;       (let*
;; 	  ((y
;; 	    (and t 2)))
;; 	(if y
;; 	    (let*
;; 		((z
;; 		  (and t 3)))
;; 	      (if z
;; 		  (progn
;; 		    (+ x y z))
;; 		nil))
;; 	  nil))
;;     nil))

(mlet* '((x 1)
	 (y 4)
	 (z 3))
       '(+ x y z))

(defun exchange-region-kill-ring-car ()
  (interactive)
  (mlet ((m (mark))
	 (_ (region-active-p))
	 (rbeg (region-beginning))
	 (rend (region-end))
	 (rep (pop kill-ring))
	 (txt (buffer-substring rbeg rend)))
    (delete-region rbeg rend)
    (push txt kill-ring)
    (let ((p (point)))
      (insert rep)
      (push-mark p t t)
      (setq deactivate-mark nil))))

;; (defun exchange-region-kill-ring-car ()
;;   (interactive)
;;   (when (mark)
;;     (when-let (rbeg (region-beginning))
;;       (let ((rend (region-end)))
;; 	(when-let ((reg (pop kill-ring)))
;; 	  (let ((txt (buffer-substring rbeg rend)))
;; 	    (delete-region rbeg rend)
;; 	    (push txt kill-ring))
;; 	  (let ((p (point)))
;; 	    (insert reg)
;; 	    (push-mark p t t)
;; 	    ;; 设置这个值为nil不会替换mark
;; 	    (setq deactivate-mark nil))
;; 	  )))))

(global-set-key (kbd "<f10>") #'exchange-region-kill-ring-car)
