;; 配置自己使用的一些小工具，和之前的misc文件类似，这里主要配置一些比较使用的小插件类似tiny这种
(use-package tiny
  :ensure nil
  ;; :defer 2
  :config
  (bind-key* "M-." 'tiny-expand))

;; 安装lisp demos当需要使用一些内置函数时，用作参考
(use-package elisp-demos
  :defer 2
  :init
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1))

;; 设置延时启动，当调用相关函数的时候就会启动了，没有必要在加载的时候启动
(use-package highlight-symbol
  :defer t
  :init
  ;; 设置高亮symbol的快捷键，这里设置为source insight的f8
  (global-set-key (kbd "<f8>") 'highlight-symbol)
  (global-set-key (kbd "S-<f8>") 'highlight-symbol-prev)
  (global-set-key (kbd "S-<f9>") 'highlight-symbol-next)
  (global-set-key (kbd "<f7>") 'highlight-symbol-query-replace)
  )

;; 设置有道词典进行翻译
(use-package youdao-dictionary
  :defer t
  :init
  (evil-leader/set-key
    "yo" 'youdao-dictionary-search-at-point+ 
    )
  )

;; 用来存放自己的一些临时的测试函数

;; 在自己的配置文件路径中查找文件
(defun spk-find-local-conf ()
  "Find local config in the local path."
  (interactive)
  (counsel-find-file (concat spk-dir "lisp/")))

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

(provide 'init-tools)
