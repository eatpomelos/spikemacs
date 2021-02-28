;; 这个文件是狗哥的视频教程中用来演示一个
(require 'cl-lib)

;; face 的格式是：上面是一个条件，下面是具体的列表
(defface position-hint-face
  '((t (:inherit region)))
  "Position hint")
(defvar position-hint-move-function nil)

(defun move-to-position-hint (n)
  (interactive)
  (dotimes (_i n)
    (call-interactively position-hint-move-function))
  (highlight-position-hint position-hint-move-function))

(defun move-to-position-hint-1 ()
  (interactive)
  (move-to-position-hint 1))

(defun move-to-position-hint-2 ()
  (interactive)
  (move-to-position-hint 2))

;; make-keymap 返回的keymap会给所有的按键设置一个值为nil的keymap如果没有就返回nil
;; 而make-sparse-keymap如果没有的话会返回其他层的keymap
(defvar position-hint-map
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap (kbd "M-1") #'move-to-position-hint-1)
    (define-key keymap (kbd "M-2") #'move-to-position-hint-2)
    keymap))

(defun highlight-position-hint (cmd)
  (let ((ovs)
	(n nil))
    (save-mark-and-excursion
      (cl-loop for i from 1 to 9 do
	       (call-interactively cmd)
	       (let ((ov (make-overlay (point) (1+ (point)))))
		 (overlay-put ov 'display
			      (cond
			       ((looking-at-p "\n")
				(format "%d\n" i))
			       (t (format "%d" i))))
		 (overlay-put ov 'face 'position-hint-face)
		 (push ov ovs))))
    
    ;; 下面这个函数会起到一个类似阻塞emacs的作用，当有新的输入或者到一定时间之后就会取消
    (setq n (sit-for 1))
    (mapcar #'delete-overlay ovs)
    (setq position-hint-move-function cmd)
    ;; 下面的函数是使一个临时的keymap生效,t表示当这个map中的map被击中就触发后面的是没有触发的处理
    (set-transient-map position-hint-map t (lambda () (setq position-hint-move-function nil)))))

(defun spk-forward-word ()
  (interactive)
  ;; call-interactively 调用原来的向前移动一个词的函数
  (call-interactively #'forward-word)
  (highlight-position-hint #'forward-word))

(defun spk-backward-word ()
  (interactive)
  ;; call-interactively 调用原来的向前移动一个词的函数
  (call-interactively #'backward-word)
  (highlight-position-hint #'backward-word))

;; 下面的函数是将原来的指令的绑定进行替换
(define-key global-map [remap forward-word] #'spk-forward-word)
(define-key global-map [remap backward-word] #'spk-backward-word)
