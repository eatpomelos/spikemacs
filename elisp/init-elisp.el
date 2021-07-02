;; 在使用 elisp 写配置的时候，会导致卡顿，是不是由于文件编码的原因？ 

;; 定义emacs C源码的路径
(setq source-directory "d:/HOME/spike/code/emacs-27.1/emacs-27.1/src")

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

(provide 'init-elisp)
