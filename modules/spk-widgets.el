;; 用来存放一些自定义的比较有用的函数，但是没必要作为库函数使用的函数
;; 在自己的配置文件路径中查找文件
(defun spk-find-local-conf ()
  "Find local config in the local path."
  (interactive)
  (counsel-find-file spk-modules-dir))

;; 打开电脑上的其他emacs配置
(defun spk-find-emacs-confs ()
  "Find another emacs config file."
  (interactive)
  (let* ((emacs-conf-dir nil))
    (setq emacs-conf-dir
	  (cond (IS-WINDOWS "d:/HOME/configs")
		(IS-LINUX "~/emacs-config")))
    (counsel-find-file emacs-conf-dir)))

;; 打开自己的readme，时刻提醒自己关注自己需要关注的东西
(defun spk-open-readme ()
  "Open my plan file."
  (interactive)
  (let* ((readme-path nil))
    (setq readme-path (concat spk-org-directory "spk-readme.org"))
    (counsel-find-file readme-path)
    ))

;; 定义插入的latex模板
(defun spk-insert-latex-templet ()
  "Insert a latex templet."
  (interactive)
  (let* ((latex-templet nil))
    (setq latex-templet
	  "# -*- coding: utf-8 -*-
#+LATEX_COMPILER:xelatex
#+LATEX_CLASS:org-article
#+OPTIONS: toc:t\n")
    (insert latex-templet)
    ))

;; 切换黑白主题
;;;###autoload
(defun spk-theme-toggle ()
  "Toggle theme in spk-mint-theme and dracula."
  (interactive)
  (let* ((next-theme nil))
    (setq next-theme (cond ((eq spk-theme 'spk-mint) 'dracula)
			   ((eq spk-theme 'dracula) 'dark-mint)
			   ((eq spk-theme 'dark-mint) 'spk-mint)
			   (t 'dark-mint)))
    (load-theme next-theme)
    (setq spk-theme next-theme)
    ))

(global-set-key (kbd "<f3>") 'spk-theme-toggle)

;; 快速打开自己的配置文件，当打开了buffer之后，点击打开出现问题，不知道什么原因
(defun spk-create-quick-config-link (label link)
  (insert label ": ")
  (insert-button link
		 'action (lambda (_) (find-file link))
		 'follow-link t)
  (insert "\n"))

(defun spk-quick-config-links ()
  "Quick open config files."
  (interactive)
  (let ((buf (get-buffer-create "*Config Links*"))
	(configs '(("Emacs" . "d:/HOME/.emacs.d")
		   ("Doom" . "d:/HOME/configs/doom.d"))))
    (with-current-buffer buf
      (erase-buffer)
      (mapcar (lambda (item)
		(spk-create-quick-config-link (car item) (cdr item)))
	      configs))
    (pop-to-buffer buf t)))

;; #' 是一个语法糖，表示取对应符号的function，因为emacs lisp的函数和变量是分在两个命名空间的。
(define-key global-map (kbd "<f9>") #'spk-quick-config-links)

;; 设置一些命令的别名 
(defalias 'elisp-mode 'emacs-lisp-mode)

;; 切换黑白主题
;;;###autoload
(defun spk-theme-toggle ()
  "Toggle theme in spk-mint-theme and dracula."
  (interactive)
  (let* ((next-theme nil))
    (setq next-theme (cond ((eq spk-theme 'spk-mint) 'dracula)
			   ((eq spk-theme 'dracula) 'spk-mint)
			   (t 'spk-mint)))
    (setq spk-theme next-theme)
    (load-theme spk-theme)
    ))
(global-set-key (kbd "<f3>") 'spk-theme-toggle)

;; 设置emacs的透明度
(setq alpha-list '((100 100) (75 45)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list))) ;; head value will set to
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))))
(global-set-key (kbd "<f7>") 'loop-alpha)

;; 有一个问题是：这种工具函数是否需要将快捷键放在快捷键的文件中？
(setq spk-ovs nil)

;;;###autoload
(defun spk/highlight_or_unhighlight_line_at_point ()
  "Highlight current line."
  (interactive)
  (require 'smartparens)
  (cond ((spk--point-in-overlay-p spk-ovs)
	 (let* ((pos (spk--point-in-overlay-p spk-ovs)))
	   (delete-overlay (nth pos spk-ovs))
	   (setq spk-ovs (spk/delete-list-element pos spk-ovs))))
	(t (let* ((ov (make-overlay
		       (line-beginning-position) (line-end-position))))
	     (setq spk-ovs (push ov spk-ovs))
	     (overlay-put ov 'face 'region)))
	)
  )

(global-set-key (kbd "<f9>") 'spk/highlight_or_unhighlight_line_at_point)

;;;###autoload
(defun spk/yank-buffer-filename ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name filename)))
    (error "Couldn't find filename in current buffer.")))

(provide 'spk-widgets)
