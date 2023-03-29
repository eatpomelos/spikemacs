(straight-use-package 'company)
(straight-use-package 'company-box)

(add-hook 'c-mode-hook 'yas-minor-mode)

(when IS-WINDOWS
  ;; 测试 lsp-bridge 暂时不在 prog-mode 下开启company-mode
  (add-hook 'prog-mode-hook 'company-mode))
(add-hook 'conf-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'company-mode)
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

(provide 'init-company)
