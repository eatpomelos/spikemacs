;; 只在linux下使用lsp，暂时不配置其他的东西
;; (straight-use-package 'projectile)

(straight-use-package 'posframe)
(straight-use-package 'orderless)
(straight-use-package 'markdown-mode)

(setq spk-lsp-bridge-dir (concat spk-local-packges-dir "lsp-bridge/"))
(setq spk-corfu-dir (concat spk-local-packges-dir "corfu/"))

(unless (file-exists-p spk-lsp-bridge-dir)
  (shell-command-to-string (format "git clone https://gitee.com/manateelazycat/lsp-bridge %s" spk-lsp-bridge-dir)))

(unless (file-exists-p spk-corfu-dir)
  (shell-command-to-string (format "git clone https://github.com/minad/corfu %s" spk-corfu-dir)))
 
(add-to-list 'load-path spk-lsp-bridge-dir)
(add-to-list 'load-path spk-corfu-dir)
(add-to-list 'load-path (concat spk-corfu-dir "extensions/"))

(require 'yasnippet)
(require 'lsp-bridge)
(require 'lsp-bridge-jdtls)       ;; provide Java third-party library jump and -data directory support, optional
(yas-global-mode 1)

;; For corfu users:
;; (setq lsp-bridge-completion-provider 'corfu)
;; (require 'corfu)
;; (require 'corfu-info)
;; (require 'corfu-history)
;; (require 'lsp-bridge-icon)        ;; show icons for completion items, optional
;; (require 'lsp-bridge-orderless)   ;; make lsp-bridge support fuzzy match, optional
;; (global-corfu-mode)
;; (corfu-history-mode t)
;; (global-lsp-bridge-mode)
;; (when (> (frame-pixel-width) 3000) (custom-set-faces '(corfu-default ((t (:height 1.3))))))  ;; adjust default font height when running in HiDPI screen.

;; For company-mode users:
(setq lsp-bridge-completion-provider 'company)
(require 'company)
(require 'company-box)
;; (require 'lsp-bridge-icon)        ;; show icons for completion items, optional

(company-box-mode 1)
(global-lsp-bridge-mode)

;; For Xref support
(add-hook 'lsp-bridge-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'lsp-bridge-xref-backend nil t)))

;; 需要注意的是，使用默认的project.el接口暂时只用.git目录作为根目录标识，可能需要手动创建
(with-eval-after-load 'project
  (evil-leader/set-key
    ",f" 'spk/project-find-file-in-root))

(provide 'init-lsp)
