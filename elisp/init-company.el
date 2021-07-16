;; 设置 emacs 中的补全插件，包含 which-key

(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'which-key)
(straight-use-package 'yasnippet)

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
(autoload #'company-box-mode "company-box")

(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'conf-mode-hook 'company-mode)
(add-hook 'eshll-mode-hook 'company-mode)
(add-hook 'org-roam-mode-hook 'company-mode)
(add-hook 'org-mode-hook 'company-mode)

(with-eval-after-load 'company
  (setq
   company-idle-delay 0.1
   company-minimum-prefix-length 1
   company-show-numbers t)

  ;; Don't downcase the returned candidates.
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case t)

  ;; 没有设置的情况先。使用默认配置，为了防止TAGS文件补全引起的卡顿，去掉tag后端，编程模式再定制
  (setq company-backends '(company-bbdb company-semantic company-cmake company-clang company-files
                                        (company-dabbrev-code company-keywords)
                                        company-oddmuse company-dabbrev))


  ;; Remove duplicate candidate.
  (add-to-list 'company-transformers #'delete-dups)

  ;; 通过建立局部变量的方式来控制补全后端的启用，配置其他模式的时候可以参照这种方式，测试打开大型C项目的时候同时写elisp代码是否会卡顿
  ;; 建立一个通用的company-backends来进行补全，另外，注释里面是否需要补全？
  (defun spk/elisp-setup ()
	(when (boundp 'company-backends)
	  (make-local-variable 'company-backends)
	  (setq company-backends
			'((company-elisp company-files company-yasnippet company-keywords)))
	  ))


  ;; Add `company-elisp' backend for elisp.
  (add-hook 'emacs-lisp-mode-hook #'spk/elisp-setup)
  )

(add-hook 'emacs-lisp-mode-hook #'company-box-mode)

(with-eval-after-load 'company-box
  (setq company-box-doc-delay 0.25))

;; 当打开evil-leader-mode 之后打开 which-key-mode
(add-hook 'evil-leader-mode-hook #'which-key-mode)
(with-eval-after-load 'which-key
  (setq which-key-idle-delay 0.1))

(provide 'init-company)
