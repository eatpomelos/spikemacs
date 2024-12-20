;; 设置autoload函数  -*- lexical-binding: t; -*-

;; init-evil
(autoload #'evil-mode "evil")
(autoload #'global-evil-leader-mode "evil-leader")
(autoload #'global-evil-surround-mode "evil-surround")
(autoload #'evil-smartparens-mode "evil-smartparens")
(autoload #'evilnc-comment-or-uncomment-lines "evil-nerd-commenter")

;; init-ivy
(autoload #'counsel-M-x "ivy")
(autoload #'swiper "ivy")
(autoload #'counsel-mode "counsel")
(autoload #'ivy-rich-mode "ivy-rich")
;; 这一行配置可选，应该是自己自动加载的
(autoload #'ivy-occur "wgrep")
;; 使用这个包主要的原因是想要在执行M-x时，命令按照历史来排列 
(autoload #'counsel-M-x "smex")

;; init-org
;; 在设置延迟加载的时候，指定其余函数来进行加载和require的形式是否有区别？
(autoload #'org-roam-dailies-find-today "org-roam")
(autoload #'company-mode "company-org-roam")
(autoload #'org-bars-mode "org-bars")
;; (autoload #'org-mode "org-roam-bibtex")
(autoload #'org-bullets-mode "org-bullets")
;; (autoload #'valign-mode "valign")

;; init-editor
(autoload #'er/mark-defun "expand-region")
(autoload #'restart-emacs "restart-emacs")
(autoload #'restart-emacs-start-new-emacs "restart-emacs")
(autoload #'json-mode "json-mode")
(autoload #'symbol-overlay-put "symbol-overlay")
(autoload #'symbol-overlay-save-symbol "symbol-overlay")
(autoload #'color-rg-search-input "color-rg")
(autoload #'toggle-company-english-helper "company-english-helper")
(autoload #'awesome-tab-mode "awesome-tab")

(autoload #'delete-block-backward "delete-block")
(autoload #'delete-block-forward "delete-block")

;; init-prog
;; 使用这包来快速删除多余的空格
(autoload #'smart-hungry-delete-char "smart-hungry-delete")
(autoload #'smart-hungry-delete-backward-char "smart-hungry-delete")
;; (autoload #'aggressive-indent-mode "aggressive-indent-mode")
(autoload #'imenu-list-smart-toggle "imenu-list")
(autoload #'deadgrep-visit-result-other-window "deadgrep")
(autoload #'deadgrep "deadgrep")

(autoload #'ctags-auto-update-mode "ctags-update")
(autoload #'company-mode "company-ctags")

(autoload #'rainbow-delimiters-mode "rainbow-delimiters")
(autoload #'lispy-mode "lispy")
(autoload #'elisp-demos-advice-describe-function-1 "elisp-demos")
(autoload #'elisp-demos-advice-helpful-update "elisp-demos")
(autoload #'minimap-mode "minimap")
;; (autoload #'focus-mode "focus")

;; init-window
(autoload #'winum-mode "winum")
(autoload #'popwin-mode "popwin")

;; init-magit
(autoload #'vc-msg-show "vc-msg")
(autoload #'magit-status "magit")
(autoload #'magit-log-all "magit")
(autoload #'magit-blame "magit")

;; init-dired
(autoload #'neotree-toggle "neotree")
(autoload #'dirvish-side "dirvish")

;; init-company
(autoload #'company-mode "company")
(autoload #'company-box-mode "company-box")
(autoload #'yas-minor-mode "yasnippet")
(autoload #'which-key-mode "which-key")
;; init-themes

;; init-widgets
(autoload #'tiny-expand "tiny")

(provide 'init-autoload)
