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
(defvar spk-push-code-dir)
(setq spk-push-code-dir "d:/work/CODE/PushCode/UGW_Repo")
(defun spk-quick-open-push-code ()
  (interactive)
  (counsel-find-file spk-push-code-dir))

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

;;;###autoload
(defun spk-find-file-internal (directory)
  "Find file in DIRECTORY."
  (let* ((cmd "find . -path \"*/.git\" -prune -o -print -type f -name \"*.*\"")
         (default-directory directory)
         (tcmd "fd \".*\\.png\" ~/tmp")
         (output (shell-command-to-string cmd))
         (lines (cdr (split-string output "[\n\r]+")))
         selecttd-line)
    (setq selecttd-line (ivy-read (format "Find file in %s:" default-directory)
                                  lines))
    (when (and selecttd-line (file-exists-p selecttd-line))
      (find-file selecttd-line))
    )
  )

;;;###autoload
(defun spk-find-file-in-project ()
  "Find file in project root directory."
  (interactive)
  (spk-find-file-internal (locate-dominating-file default-directory ".\git"))
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
	    (directory-file-name default-directory)
	    (file-name-directory  (directory-file-name parent-directory)))
      (setq i (1+ i)))
    (spk-find-file-internal parent-directory)
    ))

;; 在系统文件管理器中打开当前路径
;;;###autoload
(defun spk-open-file-with-system-application ()
  "Open directory with system application"
  (interactive)
  (let* ((current-dir (shell-command-to-string (format "cygpath -w %s" default-directory)))
	 (exploer-command nil))
    (when IS-WINDOWS
      (setq explore-command "explorer")
      (shell-command-to-string (format "%s %s" explore-command current-dir)))))

;; keybindings
(evil-leader/set-key
  "fc" 'spk-find-emacs-confs
  "fp" 'spk-find-local-conf
  "fo" 'spk-open-file-with-system-application
  "f'" 'spk-find-file-in-project
  "t" 'spk-find-local-templet
  "yo" 'youdao-dictionary-search-at-point+
  "ys" 'youdao-dictionary-play-voice-at-point
  "yi" 'youdao-dictionary-search-from-input
  )

(provide 'init-widgets)