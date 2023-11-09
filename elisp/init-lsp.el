;; 只在linux下使用lsp，暂时不配置其他的东西
(straight-use-package 'projectile)
(straight-use-package 'posframe)
(straight-use-package 'corfu)

(setq spk-lsp-bridge-dir (concat spk-local-packges-dir "lsp-bridge/"))

(unless (file-exists-p spk-lsp-bridge-dir)
  (shell-command-to-string (format "git clone https://gitee.com/manateelazycat/lsp-bridge %s" spk-lsp-bridge-dir)))

(add-to-list 'load-path spk-lsp-bridge-dir)

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)

;; 将隐藏补全框的字符设置成nil，在所有情况下都进行补全，后续实际体验过程中再修改
(setq lsp-bridege-completion-hide-characters nil)

(add-hook 'python-mode-hook (lambda ()
                              (evil-define-key* 'normal python-mode-map "gd" #'lsp-bridge-find-def)
                              (evil-define-key* 'normal python-mode-map "gr" #'lsp-bridge-find-references)
                              ))

(evil-set-initial-state 'lsp-bridge-ref-mode 'emacs)

(provide 'init-lsp)
