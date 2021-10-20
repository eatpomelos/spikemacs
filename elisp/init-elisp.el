;; elisp相关配置
(defvar spk-emacs-source-directory "d:/HOME/spike/code/emacs-27.1/emacs-27.1/src"
  "Emacs source directory.")

;; 定义emacs C源码的路径，在查找一些由C实现的底层库时，通过这个路径去查找
(setq source-directory spk-emacs-source-directory)
(setq find-function-C-source-directory spk-emacs-source-directory)

;; 设置一些命令的别名 
(defalias 'elisp-mode 'emacs-lisp-mode)

(straight-use-package 'rainbow-delimiters)
(straight-use-package 'lispy)
(straight-use-package 'elisp-demos)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'org-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'lispy-mode)

;; 配置elisp-demos 用来帮助写elisp
(advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
(advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update)

;; 通过建立局部变量的方式来控制补全后端的启用，配置其他模式的时候可以参照这种方式，测试打开大型C项目的时候同时写elisp代码是否会卡顿
;; 建立一个通用的company-backends来进行补全，另外，注释里面是否需要补全？
(defun spk/elisp-setup ()
  (when (boundp 'company-backends)
	(make-local-variable 'company-backends)
	(setq company-backends
		  '((company-elisp company-files company-yasnippet company-keywords company-dabbrev company-dabbrev-code)))
	))

;; Add `company-elisp' backend for elisp.
(add-hook 'emacs-lisp-mode-hook #'spk/elisp-setup)

(provide 'init-elisp)
