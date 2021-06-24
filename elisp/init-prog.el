(straight-use-package 'better-jumper)
(straight-use-package 'smart-hungry-delete)
;; TODO：有时间的时候看是否使用这个包替代现在的查询方案
(straight-use-package
 '(color-rg :type git
	    :host github
	    :repo "manateelazycat/color-rg"))
(require 'color-rg)

(require 'init-tags)

;; 使用这包来快速删除多余的空格
(autoload #'smart-hungry-delete-char "smart-hungry-delete")
(autoload #'smart-hungry-delete-backward-char "smart-hungry-delete")


(add-hook 'c-mode-hook (lambda ()
						 (define-key c-mode-map (kbd "DEL") 'smart-hungry-delete-backward-char)
                         (define-key c-mode-map (kbd "C-d") 'smart-hungry-delete-forward-char)))

;; 由于这个包暂时在没有界面的arch linux上运行存在问题，只在windows上启用
(when IS-WINDOWS
  (straight-use-package 'highlight-indent-guides)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; (setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(straight-use-package 'imenu-list)
;; (straight-use-package 'projectile)

;; 配置better-jumper来满足阅读源代码时候的跳转需求
(autoload #'better-jumper-mode "better-jumper")
(add-hook 'prog-mode-hook #'better-jumper-mode)

(autoload #'imenu-list-smart-toggle "imenu-list")
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; (autoload #'projectile-mode "projectile")
;; (add-hook 'prog-mode-hook #'projectile-mode)
;; keybindings
(global-set-key (kbd "<f12>") 'eshell)
(global-set-key (kbd "<f2>") 'imenu-list-smart-toggle)

(with-eval-after-load 'imenu-list
  (setq
   imenu-list-position 'left
   imenu-list-size 0.25
   ))

;; xref config
;; (advice-add 'xref--xref-buffer-mode :after #'evil-insert-state)
;; (define-key xref--xref-buffer-mode-map (kbd "j") 'xref-next-line)
;; (define-key xref--xref-buffer-mode-map (kbd "k") 'xref-prev-line)

;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=29619
(setq xref-prompt-for-identifier
      '(not
	xref-find-references
	xref-find-definitions
	xref-find-definitions-other-window
	xref-find-definitions-other-frame)
      )

;; functions
;; 使用color-rg中的api在项目中搜索字符串
;;;###autoload
(defun spk/project-search-symbol-base-color-rg (&optional sym)
  (let* ((prog-dir (+spk-get-file-dir "TAGS"))
		 )
	(unless prog-dir
	  (setq prog-dir (+spk-get-file-dir ".git")))
	(unless sym
	  (setq sym (read-string "Please input symbol: ")))
	(message (format "sym=%s dir=%s" sym prog-dir))
	(if (and prog-dir (not (string= sym "")))
		(color-rg-search-input sym prog-dir "*.[ch]")
	  (message "Not in a project."))))

;;;###autoload
(defun spk/project-find-file ()
  "Find file in project root directory."
  (interactive)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
	(unless dir
	  (setq dir (locate-dominating-file default-directory ".\svn")))
    (if dir
		(spk-search-file-internal dir)
      (message "Not in a project directory."))
	))

;;;###autoload
(defun spk/project-search-symbol (&optional symbol)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
    (unless dir
      (setq dir (locate-dominating-file default-directory "TAGS")))
    (unless dir
      (setq dir default-directory))
    (spk-search-file-internal dir t symbol (+spk-current-buffer-file-postfix))
    ))

;; 在大型项目中搜索字符串,使用基于color-rg的api来搜索
;;;###autoload
(defun spk/project-search-symbol-at-point ()
  (interactive)
  (spk/project-search-symbol-base-color-rg (thing-at-point 'symbol))
  )

;;;###autoload
(defun spk/project-search-symbol-from-input ()
  (interactive)
  (spk/project-search-symbol-base-color-rg nil)
  )


;; key bindings
(evil-leader/set-key
  "pd" 'xref-find-definitions
  "pt" 'counsel-etags-find-tag-at-point
  "ps" 'spk/project-search-symbol-at-point
  "pi" 'spk/project-search-symbol-from-input
  "pff" 'spk/find-file-entry
  ;; "pff" 'spk/project-find-file
  ;; "pcf" 'spk/project-ctags-find-file
  "pfe" 'counsel-etags-find-tag
  ;; "pgd" 'spk/project-tags-code-navigation
  "eb" 'eval-buffer
  "mf" 'er/mark-defun
  )

;; 充分利用avy的api来进行跳转等操作,可以考虑用bind-key的api来定义快捷键
(define-key evil-normal-state-map (kbd ",w") #'avy-goto-char-2)
(define-key evil-normal-state-map (kbd ",c") #'avy-goto-char-in-line)
(define-key evil-normal-state-map (kbd ",l") #'avy-goto-line-below)

;; 配置better-jumper快捷键来满足跳转需求
(with-eval-after-load 'better-jumper
  (define-key prog-mode-map (kbd "C-<f8>") 'better-jumper-jump-backward)
  (define-key prog-mode-map (kbd "C-<f9>") 'better-jumper-jump-forward)
  )

;; 在通用的编程设置完成之后，读取针对相应编程语言的设置
(require 'init-elisp)
(require 'init-C)

(provide 'init-prog)
