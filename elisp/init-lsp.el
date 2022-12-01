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

;; 需要注意的是，使用默认的project.el接口暂时只用.git目录作为根目录标识，可能需要手动创建
(with-eval-after-load 'project
  (evil-leader/set-key
    ",f" 'spk/project-find-file-in-root))

(provide 'init-lsp)
