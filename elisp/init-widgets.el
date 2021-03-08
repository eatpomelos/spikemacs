;; 用来存放自己日常使用的一些小函数
;; 在自己的配置文件路径中查找文件

(straight-use-package 'youdao-dictionary)

;;;###autoload
(defun spk-find-local-conf ()
  "Find local config in the local path."
  (interactive)
  (counsel-find-file spk-elisp-dir))

;;;###autoload
;; 打开电脑上的其他emacs配置
(defun spk-find-emacs-confs ()
  "Find another emacs config file."
  (interactive)
  (let* ((emacs-conf-dir nil))
    (setq emacs-conf-dir
	  (cond (IS-WINDOWS "d:/HOME/spike/configs")
		(IS-LINUX "~/emacs-config")))
    (counsel-find-file emacs-conf-dir)))

;;;###autoload
;; 当打开的文件较大时，
(defun spk-view-large-file ()
  (when (> (buffer-size) 10000000)
    (fundamental-mode)
    ))

(add-hook 'find-file-hook 'spk-view-large-file)

;; 定义插入的latex模板
(defun spk-insert-latex-templet ()
  "Insert a latex templet."
  (interactive)
  (let* ((latex-templet nil))
    (setq latex-templet
	  "# -*- coding: utf-8 -*-
#+LATEX_COMPILER:xelatex
#+LATEX_CLASS:org-article
#+OPTIONS: toc:t
#+OPTIONS: ^:{}\n")
    (save-excursion
      (goto-char (point-min))
      (insert latex-templet))
    ))

;; 切换黑白主题
;;;###autoload
;; (defun spk-theme-toggle ()
;;   "Toggle theme in spk-mint-theme and dracula."
;;   (interactive)
;;   (let* ((next-theme nil))
;;     (setq next-theme (cond ((eq spk-theme 'spk-mint) 'dracula)
;; 			   ((eq spk-theme 'dracula) 'dark-mint)
;; 			   ((eq spk-theme 'dark-mint) 'spk-mint)
;; 			   (t 'dark-mint)))
;;     (load-theme next-theme)
;;     (setq spk-theme next-theme)
;;     ))

;; (global-set-key (kbd "<f3>") 'spk-theme-toggle)

;; 设置emacs的透明度
(setq alpha-list '((100 100) (75 45)))
;;;###autoload
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list))) ;; head value will set to
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))))

(global-set-key (kbd "<f7>") #'loop-alpha)

;; 有一个问题是：这种工具函数是否需要将快捷键放在快捷键的文件中？
(setq spk-ovs nil)

;; 编写用来获取行内容的接口，将获取到的内容放到变量里
;; (setq spk-highlight-contents nil)

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
(global-set-key (kbd "<f9>") #'spk/highlight_or_unhighlight_line_at_point)
(global-set-key (kbd "<f8>") #'highlight-symbol-at-point)

;;;###autoload
(defun spk/yank-buffer-filename ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name filename)))
    (error "Couldn't find filename in current buffer.")))

;; 不再使用package.el 相关的函数都可以去掉了
;;;###autoload
(defun spk-find-local-elap-packages ()
  "Find elpa packages."
  (interactive)
  (counsel-find-file (concat spk-local-dir "elpa/")))

;;;###autoload
(defun spk-find-local-templet ()
  "Find elpa packages."
  (interactive)
  (counsel-find-file (concat spk-local-dir "Templet/elisp/")))

;; keybindings
(evil-leader/set-key
  "fc" 'spk-find-emacs-confs
  "fp" 'spk-find-local-conf
  "t" 'spk-find-local-templet
  "yo" 'youdao-dictionary-search-at-point+
  "ys" 'youdao-dictionary-play-voice-at-point
  "yi" 'youdao-dictionary-search-from-input
  )

(provide 'init-widgets)
