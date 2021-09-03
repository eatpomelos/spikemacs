;; 设置autoload函数
(autoload #'counsel-M-x "ivy")

(autoload #'org-roam-dailies-find-today "org-roam")
(autoload #'color-rg-search-input "color-rg")
(autoload #'ctags-auto-update-mode "ctags-update")
;; 使用这包来快速删除多余的空格
(autoload #'smart-hungry-delete-char "smart-hungry-delete")
(autoload #'smart-hungry-delete-backward-char "smart-hungry-delete")
(autoload #'er/mark-defun "expand-region")
;; 配置better-jumper来满足阅读源代码时候的跳转需求
(autoload #'better-jumper-mode "better-jumper")
(autoload #'imenu-list-smart-toggle "imenu-list")
;; autoloads configure
(autoload #'winum-mode "winum")
(autoload #'popwin-mode "popwin")

(autoload #'vc-msg-show "vc-msg")
(autoload #'magit-status "magit")
(autoload #'magit-log-all "magit")
(autoload #'magit-blame "magit")

(autoload #'symbol-overlay-put "symbol-overlay")
(autoload #'symbol-overlay-save-symbol "symbol-overlay")
(autoload #'toggle-company-english-helper "company-english-helper")
;; 添加autoload函数  
(autoload #'yas-minor-mode "yasnippet")

(autoload #'company-mode "company")
(autoload #'company-box-mode "company-box")
(provide 'init-autoload)
