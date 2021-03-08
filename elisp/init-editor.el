;; 和编辑相关的一些插件的配置
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

;; keybinding
(global-set-key (kbd "C-c v") 'set-mark-command)

(with-eval-after-load 'expand-region
  (evil-leader/set-key
    "mop" 'er/mark-org-parent
    "moe" 'er/mark-org-element
    "rs" 'restart-emacs
    "rn" 'restart-emacs-start-new-emacs
    "nr" 'narrow-to-region
    "nw" 'widen))

(provide 'init-editor)
