;; 用来存放自己日常使用的一些小函数  -*- lexical-binding: t; -*-
;; 在自己的配置文件路径中查找文件
(straight-use-package 'tiny)
;; (straight-use-package 'epc)

;; (require 'epc)

(require 'init-tools)

;;;###autoload
(defun spk/find-file-entry ()
  (interactive)
  (cond ((+spk-get-complete-file ".spk-project-files") (spk/project-fast-find-file))
        ((+spk-get-complete-file ".spk-project-all-files") (spk/project-fast-find-all-file))
        ((and (+spk-get-complete-file "compile_commands.json") IS-LINUX)
         (projectile-find-file-in-directory (file-name-directory
                                             (+spk-get-complete-file "compile_commands.json"))))
        ((+spk-get-complete-file ".git") (project-find-file))
        ((+spk-get-complete-file ".svn") (spk/project-find-file))
        (t (counsel-find-file))
        )
  )

;;;###autoload
(defun spk-find-local-conf ()
  "Find local config in the local path."
  (interactive)
  (counsel-find-file spk-elisp-dir))

(when IS-LINUX
  (setq spk-i3-conf-dir (concat (format "/home/%s%s" user-login-name "/.config")))
;;;###autoload
  (defun spk-find-i3-conf ()
    "Find local config in the local path."
    (interactive)
    (counsel-find-file spk-i3-conf-dir))
  (evil-leader/set-key
    "fv" 'spk-find-i3-conf)
  )

;; 打开电脑上的其他emacs配置
;;;###autoload
(defun spk-find-emacs-confs ()
  "Find another emacs config file."
  (interactive)
  (let* ((emacs-conf-dir nil))
    (setq emacs-conf-dir
	      (cond (IS-WINDOWS "d:/HOME/spike/configs")
		        (IS-LINUX "~/emacs-config")))
    (counsel-find-file emacs-conf-dir)))

;; 当打开的文件较大时，
;;;###autoload
(defun spk-view-large-file ()
  (when (> (buffer-size) 30000000)
    (fundamental-mode)
    ))

(add-hook 'find-file-hook 'spk-view-large-file)

;; 定义插入的latex模板，可以通过设置模板来实现相应功能，后续删除这个接口
(defun spk-insert-latex-templet ()
  "Insert a latex templet."
  (interactive)
  (let* ((latex-templet nil))
    (setq latex-templet
	  "# -*- coding: utf-8 -*-
#+LATEX_COMPILER:xelatex
#+LATEX: \\newpage
#+LATEX_CLASS:org-article
#+OPTIONS: toc:t
#+OPTIONS: ^:{}\n")
    (save-excursion
      (goto-char (point-min))
      (insert latex-templet))
    ))

(defun spk/find-linux-code-dir ()
  (interactive)
  (counsel-find-file spk-source-code-dir))

;; 设置emacs的透明度
;; (setq alpha-list '((100 100) (75 45)))
(setq alpha-list '((100 100) (75 75) (65 65)))
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

;; 高亮当前行的函数，偶尔会出问题，暂时未解决 
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
	    (t (let* ((ov nil))
             (unless (spk/empty-line-p)
               (setq ov (make-overlay
		                 (line-beginning-position) (line-end-position)))
	           (setq spk-ovs (push ov spk-ovs))
	           (overlay-put ov 'face 'region)))
           )
	    )
  )

;; 解决当在一个buffer中设置了高亮行的overlay时kill-buffer导致spk-ovs内容出错问题
(defadvice kill-buffer
    (before spk-hl-line-hack activate)
  (mapc #'(lambda (e)
            (when (equal (overlay-buffer e) (current-buffer))
              (delete-overlay e)
              (setq spk-ovs (delete e spk-ovs))
              ))
        spk-ovs)
  )

(global-set-key (kbd "<f9>") #'spk/highlight_or_unhighlight_line_at_point)

;;;###autoload
(defun spk/yank-buffer-filename ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (progn
        (kill-new (abbreviate-file-name filename))
        (message filename))
    (error "Couldn't find filename in current buffer."))
  )

;;;###autoload
(defun spk-find-local-templet ()
  "Find elpa packages."
  (interactive)
  (let* ((dir spk-local-code-dir))
    (unless (file-exists-p spk-local-code-dir)
      (mkdir spk-local-code-dir))
    (counsel-find-file spk-local-code-dir)))

;; 在上级多少层目录查找文件
;;;###autoload
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
  (let* ((current-dir
          (if IS-WINDOWS
              (+spk-slash-2-backslash default-directory)
            default-directory))
	     (elf-cmd nil))
    (setq  elf-cmd
           (cond (IS-WINDOWS "explorer")
                 (IS-LINUX "xdg-open")
                 (t nil)
                 ))
    (if (not elf-cmd)
        (message "This command is not supported by your system.")
      (message (format "%s %s" elf-cmd current-dir))
      (shell-command-to-string (format "%s %s" elf-cmd current-dir))
      )
    ))

;;;###autoload
(defun spk/find-repo-code ()
  (interactive)
  (counsel-find-file "~/.emacs.d/straight/build"))

(when IS-WINDOWS
  ;;;###autoload
  (defun spk/revert-buffer ()
    (interactive)
    (revert-buffer-with-coding-system 'chinese-gbk))
  )

(defvar spk-linux-doc-dir nil
  "LINUX kernel documents directory.")

;; 暂时只用来管理linux标准内核的文档，后续可以扩展成一个列表用选择需要查看的文档
;;;###autoload
(defun spk-find-linux-doc ()
  "Open linux default documentation directory."
  (interactive)
  (when spk-linux-doc-dir
    (spk-search-file-internal spk-linux-doc-dir t)))

;; 强制清除缓冲区内容，如果当前缓冲区设置的是只读模式则先取消只读
(defun spk/erase-current-buffer-force ()
  "Force to erase buffer's content"
  (interactive)
  (let* ((read-only-status (if buffer-read-only 1 -1)))
	(when buffer-read-only
	  (read-only-mode -1))
	(erase-buffer)
	(read-only-mode read-only-status)))

;; 用来解释当前光标所在位置的face等信息，在编写主题的时候比较有用 
;; C-u C-x = 编写主题时候解释当前光标的信息，用于自定义face
(defun spk/set-title-format ()
  "Set `frame-title-format'."
  (interactive)
  (let* ((str nil))
    (setq str (read-string "input your format string:"))
    (setq frame-title-format (concat spk-title-format str))))


;; 删除书签中的某个条目 
;;;###autoload
(defun spk/bookmark_delete-no-file-exist (item)
  (unless (file-exists-p (bookmark-location item))
    (bookmark-delete item)
    ))

;; 清除书签中已经不存在的条目
(defun spk/bookmark_clear_no_file_exist ()
  "Clear not exist bookmarks."
  (interactive)
  (mapcar #'spk/bookmark_delete-no-file-exist (bookmark-all-names))
  )

(global-set-key (kbd "M-p") (lambda ()
                              (interactive)
                              (scroll-down-command (/ (window-height) 2))))

(global-set-key (kbd "M-n") (lambda ()
                              (interactive)
                              (scroll-up-command (/ (window-height) 2))))

;; 向左删除本行内容，但是保留缩进
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

;;;###autoload
(defun spk/counsel-rg-current-dir ()
  (interactive)
  (counsel-rg nil default-directory))

(defconst spk-edit-point "spk-edit-point"
  "Variable for storing the last edit point you want to store.")
;; 实现一个函数用于记录任意位置，使用一个默认书签名，当多次记录的时候直接替换之前的同名书签

;;;###autoload
(defun spk/bookmark-last-edit-record ()
  (interactive)
  (bookmark-set-internal "Set bookmark unconditionally" spk-edit-point 'overwrite))

;;;###autoload
(defun spk/bookmark-last-edit-jump ()
  (interactive)
  (bookmark-jump (bookmark-get-bookmark spk-edit-point)))

;; keybindings
(evil-leader/set-key
  "fc" 'spk-find-emacs-confs
  "fp" 'spk-find-local-conf
  "ff" 'spk-find-file
  "fd" 'spk-find-linux-doc
  "fqp" 'spk/find-linux-code-dir
  "fo" 'spk-open-file-with-system-application
  "t" 'spk-find-local-templet
  "ee" 'base64-encode-region
  "ed" 'base64-decode-region
  "sc" 'spk/counsel-rg-current-dir
  "mm" 'spk/bookmark-last-edit-record
  "mj" 'spk/bookmark-last-edit-jump
  )

(setq spk-popweb-dir (concat spk-local-packges-dir "popweb"))
(unless (file-exists-p spk-popweb-dir)
  (shell-command-to-string (format "git clone https://github.com/manateelazycat/popweb %s" spk-popweb-dir))
  )

(when (and (file-exists-p spk-popweb-dir)
           (> (/ (+spk-get-memavailable) 1024) 6000))
  (add-to-list 'load-path spk-popweb-dir)
  ;; (add-to-list 'load-path (concat spk-popweb-dir "/extension/color-picker"))
  (add-to-list 'load-path (concat spk-popweb-dir "/extension/dict"))
  ;; (add-to-list 'load-path (concat spk-popweb-dir "/extension/latex"))
  ;; (add-to-list 'load-path (concat spk-popweb-dir "/extension/org-roam"))
  ;; (add-to-list 'load-path (concat spk-popweb-dir "/extension/url-preview"))
  (require 'popweb)
  (require 'popweb-dict)
  ;; (require 'popweb-org-roam-link)
  (global-set-key (kbd "<f5>") #'popweb-dict-youdao-pointer)
  (global-set-key (kbd "<f6>") #'popweb-dict-youdao-input)
  )

(when IS-LINUX
  (straight-use-package
   '(sdcv :type git
		  :host github
		  :repo "manateelazycat/sdcv"))

  (require 'sdcv)

  (with-eval-after-load 'sdcv
    (setq sdcv-say-word-p nil)          ;say word after translation

    (setq sdcv-only-data-dir nil)
  
    (setq sdcv-dictionary-data-dir nil)
  
    (setq sdcv-dictionary-data-dictionary "/usr/share/stardict/dic") ;setup directory of stardict dictionary

    (setq sdcv-dictionary-simple-list   ;setup dictionary list for simple search
          '(
            "懒虫简明汉英词典"
            "计算机词汇"
            "英汉汉英专业词典"
            ;; "牛津英汉双解美化版"
            ))

    (setq sdcv-dictionary-complete-list ;setup dictionary list for complete search
          '(
            "懒虫简明汉英词典"
            "计算机词汇"
            "英汉汉英专业词典"
            "牛津现代英汉双解词典"
            "牛津英汉双解美化版"
            ))
    (global-set-key (kbd "<f3>") #'sdcv-search-pointer+)
    (global-set-key (kbd "<f4>") #'sdcv-search-input+)
    ))

;; 使用emacs中自带的calculator 日常计算的时候使用
(evil-set-initial-state 'calculator-mode 'emacs)
(provide 'init-widgets)

(ivy--queue-exhibit) 
