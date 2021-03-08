(require 'init-elisp)
(require 'init-C)

(straight-use-package 'highlight-indent-guides)

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; keybindings
(global-set-key (kbd "<f12>") 'eshell)

(provide 'init-prog)
