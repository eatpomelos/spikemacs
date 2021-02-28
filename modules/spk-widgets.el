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
	  (cond (IS-WINDOWS "d:/HOME/spike/configs")
		(IS-LINUX "~/emacs-config")))
    (counsel-find-file emacs-conf-dir)))

;; 当打开的文件较大时，
(defun spk-view-large-file ()
  (when (> (buffer-size) 10000000)
    (fundamental-mode)
    ))

(add-hook 'find-file-hook 'spk-view-large-file)

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

;; 设置一些命令的别名 
(defalias 'elisp-mode 'emacs-lisp-mode)

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

;;;###autoload
(defun spk/yank-buffer-filename ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name filename)))
    (error "Couldn't find filename in current buffer.")))

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

;; highlight c
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start (match-beginning 0) 'font-lock-comment-face)
              (setq start nil))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)

(defun my-c-mode-common-hook-if0 ()
  (font-lock-add-keywords
   nil
   '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook-if0)

;; 定义一个小函数，

;; 当遇到不认识的单词的时候，虽然可以通过有道翻译插件来进行翻译，但是下一次遇到还是需要再次查询
(provide 'spk-widgets)
