;; 设置 emacs 中的补全插件，包含 which-key

(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'which-key)
(straight-use-package 'yasnippet)

;; yasnippet
(add-hook 'prog-mode-hook 'yas-minor-mode)

(with-eval-after-load "yasnippet"
  (let ((inhibit-message nil))
    (setq yas-snippets-dirs (concat spk-dir "snippets/"))
    (setq yas--loaddir (concat spk-dir "snippets"))
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
  ;; 在补全的时候忽略TAGS等大文件，避免造成卡顿
  (setq company-dabbrev-ignore-buffers "\\`[ *]\\|TAGS\\|tags")

  ;; 设置忽略的buffer
  ;; (setq company-dabbrev-ignore-buffers ".*TAGS.*")
  ;; 没有设置的情况先。使用默认配置，为了防止TAGS文件补全引起的卡顿，去掉tag后端，编程模式再定制
  (setq company-backends '(company-bbdb company-semantic company-cmake company-clang company-files
                                        (company-dabbrev-code company-keywords)
                                        company-oddmuse company-dabbrev))


  ;; Remove duplicate candidate.
  (add-to-list 'company-transformers #'delete-dups)
  )

(add-hook 'emacs-lisp-mode-hook #'company-box-mode)

(with-eval-after-load 'company-box
  (setq company-box-doc-delay 0.25))

;; 当打开evil-leader-mode 之后打开 which-key-mode
(add-hook 'evil-leader-mode-hook #'which-key-mode)
(with-eval-after-load 'which-key
  (setq which-key-idle-delay 0.1))

(provide 'init-company)
