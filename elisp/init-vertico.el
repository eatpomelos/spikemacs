(straight-use-package 'vertico)
(straight-use-package 'orderless) ;; 支持无序搜索
(straight-use-package 'marginalia) ;; marginalia，替换ivy-rich
(straight-use-package 'embark)
(straight-use-package 'consult) ;; 替换掉counsel
(straight-use-package 'embark-consult)
(straight-use-package 'wgrep)
(straight-use-package 'which-key)

(vertico-mode t)
(marginalia-mode t)

(setq completion-styles '(orderless))
(setq prefix-help-command 'embark-prefix-help-command)

(global-set-key (kbd "C-?") 'embark-act)
(global-set-key (kbd "C-s") 'consult-line)


(add-hook 'evil-leader-mode-hook #'which-key-mode)
(with-eval-after-load 'which-key
  (setq which-key-idle-delay 1))


(with-eval-after-load 'vertico
  ;; 开启 Vertico 的输入框目录清理功能
  (require 'vertico-directory))
  
  (evil-leader/set-key
    "fl" 'consult-locate
    "x" 'execute-extended-command
    "lt" 'consult-theme
    )

(provide 'init-vertico)
