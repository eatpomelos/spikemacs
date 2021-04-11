;; 用来存放自己日常使用的一些小函数
;; 在自己的配置文件路径中查找文件

(straight-use-package 'youdao-dictionary)
(straight-use-package 'tiny)

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

;; 工具函数，快速打开公司的代码
(when IS-WINDOWS
  (defvar spk-push-code-dir)
  (setq spk-push-code-dir "d:/work/CODE/PushCode/UGW_Repo")
  (defun spk-quick-open-push-code ()
    (interactive)
    (counsel-find-file spk-push-code-dir)))

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

;; 编写用来获取行内容的接口，将获取到的内容放到变量里
(setq spk-ovs nil)

;;;###autoload
(defun spk/highlight_or_unhighlight_line_at_point ()
  "Highlight current line."
  (interactive)
  ;; (require 'smartparens)
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

;;;###autoload
(defun spk/yank-buffer-filename ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name filename)))
    (error "Couldn't find filename in current buffer.")))

;;;###autoload
(defun spk-find-local-templet ()
  "Find elpa packages."
  (interactive)
  (counsel-find-file (concat spk-local-dir "Templet/elisp/")))

;;;###autoload
(defun spk-find-file-in-project ()
  "Find file in project root directory."
  (interactive)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
    (if dir
	(spk-search-file-internal dir)
      (message "Not in a project directory.")))
  )

;;;###autoload
;; 在上级多少层目录查找文件
(defun spk-find-file (&optional level)
  "Find file in current directory or LEVEL parent directory."
  (interactive "p")
  (unless level (setq level 0))
  (let* ((parent-directory default-directory)
	 (i 0))
    (when (< i level)
      (setq parent-directory
	    ;; find-name-directory 获取当前文件的路径, 如果是路径则返回本身
	    ;; directory-file-name 获取路径名，去掉/
	    (directory-file-name default-directory))
      (file-name-directory  (directory-file-name parent-directory))
      (setq i (1+ i)))
    (spk-search-file-internal parent-directory)))

;; 在系统文件管理器中打开当前路径，以下函数方法可以考虑是否能写成通用函数 
;; (replace-regexp-in-string) 替换字符串中的某个字符，但是有问题
;;;###autoload
(defun spk-open-file-with-system-application ()
  "Open directory with system application"
  (interactive)
  (let* ((current-dir (slash-2-backslash default-directory))
	 (exploer-command nil))
    (if IS-WINDOWS
	(progn (setq explore-command "explorer")
	       (shell-command-to-string (format "%s %s" explore-command current-dir)))
      (message "Is not in windows system. This command is not set."))
    ))

;; keybindings
(evil-leader/set-key
  "fc" 'spk-find-emacs-confs
  "fp" 'spk-find-local-conf
  "ff" 'spk-find-file
  "fd" 'spk-find-linux-doc
  "fqp" 'spk-quick-open-push-code
  "fo" 'spk-open-file-with-system-application
  "f'" 'spk-find-file-in-project
  "t" 'spk-find-local-templet
  "yo" 'youdao-dictionary-search-at-point+
  "ys" 'youdao-dictionary-play-voice-at-point
  "yi" 'youdao-dictionary-search-from-input
  )

;; 在windows上找不到 manual 节点，手动将emacs doc的位置添加到info-directory-list里面去
(when IS-WINDOWS
  (add-to-list 'Info-directory-list
	       "d:/HOME/spike/code/emacs-27.1/emacs-27.1/info")
  )

(defvar spk-linux-doc-dir nil
  "LINUX kernel documents directory.")

(when IS-WINDOWS
  (setq spk-linux-doc-dir "d:/work/linux-5.9-rc3/linux-5.9-rc3/Documentation"))

;; 暂时只用来管理linux标准内核的文档，后续可以扩展成一个列表用选择需要查看的文档
;;;###autoload
(defun spk-find-linux-doc ()
  "Open linux default documentation directory."
  (interactive)
  (when spk-linux-doc-dir
    (counsel-find-file spk-linux-doc-dir)))

;; 用来解释当前光标所在位置的face等信息，在编写主题的时候比较有用 
;; C-u C-x = 编写主题时候解释当前光标的信息，用于自定义face
(provide 'init-widgets)
