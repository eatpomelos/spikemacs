(require 'init-elisp)
(require 'init-C)

(straight-use-package 'highlight-indent-guides)
(straight-use-package 'imenu-list)

(autoload #'imenu-list-smart-toggle "imenu-list")

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; keybindings
(global-set-key (kbd "<f12>") 'eshell)
(global-set-key (kbd "<f2>") 'imenu-list-smart-toggle)

(provide 'init-prog)
 
