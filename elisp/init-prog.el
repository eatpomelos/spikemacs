(require 'init-elisp)
(require 'init-C)

;; 由于这个包暂时在没有界面的arch linux上运行存在问题，只在windows上启用
(when IS-WINDOWS
  (straight-use-package 'highlight-indent-guides)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(straight-use-package 'imenu-list)
;; (straight-use-package 'projectile)

(autoload #'imenu-list-smart-toggle "imenu-list")
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; (autoload #'projectile-mode "projectile")
;; (add-hook 'prog-mode-hook #'projectile-mode)
;; keybindings
(global-set-key (kbd "<f12>") 'eshell)
(global-set-key (kbd "<f2>") 'imenu-list-smart-toggle)

(with-eval-after-load 'imenu-list
  (setq
   imenu-list-position 'left
   imenu-list-size 0.25
   ))

(provide 'init-prog)
 
