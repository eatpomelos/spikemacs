;; 设置 emacs 中的补全插件，包含 which-key

(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'which-key)
(straight-use-package 'yasnippet)
(straight-use-package 'deadgrep)

;; yasnippet
(autoload #'yas-minor-mode "yasnippet")
(add-hook 'prog-mode-hook 'yas-minor-mode)

(with-eval-after-load "yasnippet"
  (let ((inhibit-message nil))
    (setq yas-snippets-dirs (concat spk-dir "snippets/"))
    (setq yas--loaddir (concat spk-dir "snippets"))
    (global-set-key (kbd "<f5>") #'company-yasnippet)
    (yas-compile-directory yas-snippets-dirs)
    (yas-reload-all)))

;; ;; company
;; (setq
;;  company-tng-auto-configure nil
;;  company-frontends '(company-tng-frontend
;; 		     company-pseudo-tooltip-frontend
;; 		     company-echo-metadata-frontend)
;;  company-begin-commands '(self-insert-command)
;;  company-idle-delay 0.2
;;  company-tooltip-limit 10
;;  company-tooltip-align-annotations t
;;  company-tooltip-width-grow-only t
;;  company-tooltip-idle-delay 0.1
;;  company-minimum-prefix-length 1
;;  company-dabbrev-downcase nil
;;  company-global-modes '(not dired-mode dired-sidebar-mode)
;;  company-tooltip-margin 0)

(autoload #'company-mode "company")

(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'conf-mode-hook 'company-mode)
(add-hook 'eshll-mode-hook 'company-mode)

(with-eval-after-load 'company
  (setq
   company-idle-delay 0.1
   company-minimum-prefix-length 1
   company-show-numbers t
   )
  (require 'company-box)
  (setq company-box-doc-delay 0.5)
  (add-hook 'company-mode #'company-box-mode)
  )

(provide 'init-company)
