(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'which-key)

;; yasnippet
(add-hook 'prog-mode-hook 'yas-minor-mode)

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


(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'conf-mode-hook 'company-mode)
(add-hook 'eshll-mode-hook 'company-mode)
(add-hook 'org-mode-hook 'company-mode)

(with-eval-after-load 'company
  (setq
   company-idle-delay 0.1
   company-minimum-prefix-length 1
   company-show-numbers t)

  ;; Don't downcase the returned candidates.
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-ignore-buffers "\\`[ *]\\|TAGS\\|tags")

  ;; (setq company-dabbrev-ignore-buffers ".*TAGS.*")
  (setq company-backends '(company-bbdb company-semantic company-cmake company-clang company-files
                                        (company-dabbrev-code company-keywords)
                                        company-oddmuse company-dabbrev))

  ;; Remove duplicate candidate.
  (add-to-list 'company-transformers #'delete-dups)
  )

;; (add-hook 'emacs-lisp-mode-hook #'company-box-mode)
(add-hook 'company-mode-hook #'company-box-mode)

(with-eval-after-load 'company-box
  (setq company-box-doc-delay 0.25))

(add-hook 'evil-leader-mode-hook #'which-key-mode)
(with-eval-after-load 'which-key
  (setq which-key-idle-delay 0.1))

(provide 'init-company)
