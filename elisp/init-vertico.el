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

(require 'wgrep)
;; (autoload #'embark-act "wgrep")

(with-eval-after-load 'vertico
  ;; 开启 Vertico 的输入框目录清理功能
  (require 'vertico-directory)
  ;; 在 Minibuffer 中，按 RET 直接进入目录，按 DEL (Backspace) 回退一级目录
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  
  ;; 在 Minibuffer 里用 C-j 和 C-k 上下移动
  (define-key vertico-map (kbd "C-j") #'vertico-next)
  (define-key vertico-map (kbd "C-k") #'vertico-previous)
  )
  
  (evil-leader/set-key
    "fl" 'consult-locate
    "x" 'execute-extended-command
    "lt" 'consult-theme
    )

;; 在wsl下不开启默认预览，避免卡顿
(when IS-WSL
  (setq consult-preview-key nil))

(provide 'init-vertico)
