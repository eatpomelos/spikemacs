;; 只在linux下使用lsp，暂时不配置其他的东西
(straight-use-package 'projectile)
(straight-use-package 'posframe)
(straight-use-package 'markdown-mode)

(setq spk-lsp-bridge-dir (concat spk-local-packges-dir "lsp-bridge/"))

(unless (file-exists-p spk-lsp-bridge-dir)
  (shell-command-to-string (format "git clone https://gitee.com/manateelazycat/lsp-bridge %s" spk-lsp-bridge-dir)))


(add-to-list 'load-path spk-lsp-bridge-dir)

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)

(add-hook 'python-mode-hook (lambda ()
                              (evil-define-key* 'normal python-mode-map "gd" #'lsp-bridge-find-def)
                              (evil-define-key* 'normal python-mode-map "gr" #'lsp-bridge-find-references)
                              ))

(advice-add 'lsp-bridge-ref-mode :after 'evil-emacs-state)

(provide 'init-lsp)
