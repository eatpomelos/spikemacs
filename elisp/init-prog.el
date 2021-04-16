(straight-use-package 'ctags)
(straight-use-package 'ctags-update)
(straight-use-package 'company-ctags)
(straight-use-package 'counsel-etags)
(straight-use-package 'better-jumper)

(autoload #'ctags-auto-update-mode "ctags-update")

;; 由于这个包暂时在没有界面的arch linux上运行存在问题，只在windows上启用
(when IS-WINDOWS
  (straight-use-package 'highlight-indent-guides)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

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

(defvar spk-prog-jump-list nil
  "To record position when called xref-goto-xref")

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

;;;###autoload
(defun spk/project-find-file ()
  "Find file in project root directory."
  (interactive)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
    (if dir
	(spk-search-file-internal dir)
      (message "Not in a project directory.")))
  )

;; 在下项目中找某个符号
;;;###autoload
(defun spk/project-search-symbol (&optional symbol)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
    (unless dir
      (setq dir (locate-dominating-file default-directory "TAGS")))
    (unless dir
      (setq dir default-directory))
    (spk-search-file-internal dir t symbol (+spk-current-buffer-file-postfix))
    ))

;;;###autoload
(defun spk/project-search-symbol-at-point ()
  (interactive)
  (spk/project-search-symbol (symbol-at-point))
  )

;;;###autoload
(defun spk/project-search-symbol-input ()
  (interactive)
  (spk/project-search-symbol nil)
  )

;; 快捷键的设置不合理
(evil-leader/set-key
  "pd" 'xref-find-definitions
  "pt" 'counsel-etags-find-tag-at-point
  "ps" 'spk/project-search-symbol-at-point
  "pi" 'spk/project-search-symbol-input
  "pff" 'spk/project-find-file
  "pfe" 'counsel-etags-find-tag
  )

;; 配置better-jumper快捷键来满足跳转需求
(with-eval-after-load 'better-jumper
  (define-key prog-mode-map (kbd "C-<f8>") 'better-jumper-jump-backward)
  (define-key prog-mode-map (kbd "C-<f9>") 'better-jumper-jump-forward)
  )

;; 在通用的编程设置完成之后，读取针对相应编程语言的设置
(require 'init-elisp)
(require 'init-C)

(provide 'init-prog)
