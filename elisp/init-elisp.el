;; 设置一些命令的别名 
(defalias 'elisp-mode 'emacs-lisp-mode)

(straight-use-package 'rainbow-delimiters)
(straight-use-package 'lispy)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'org-mode-hook #'rainbow-delimiters-mode)

(add-hook 'emacs-lisp-mode-hook #'lispy-mode)

(provide 'init-elisp)
