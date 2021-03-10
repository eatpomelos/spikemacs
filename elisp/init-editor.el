;; 和编辑相关的一些插件的配置
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)
(straight-use-package 'highlight-symbol)

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

;; keybinding
(global-set-key (kbd "C-c v") 'set-mark-command)
(global-set-key (kbd "C-c l") 'avy-goto-line)
(global-set-key (kbd "C-c C-l") 'goto-line)
(global-set-key (kbd "C-<down>") 'text-scale-decrease)
(global-set-key (kbd "C-<up>") 'text-scale-increase)

(with-eval-after-load 'expand-region
  (evil-leader/set-key
    "mop" 'er/mark-org-parent
    "moe" 'er/mark-org-element
    "rs" 'restart-emacs
    "rn" 'restart-emacs-start-new-emacs
    "nr" 'narrow-to-region
    "nw" 'widen))

(with-eval-after-load 'highlight-symbol
  (global-set-key (kbd "<f8>") 'highlight-symbol)
  (global-set-key (kbd "S-<f8>") 'highlight-symbol-prev)
  (global-set-key (kbd "S-<f9>") 'highlight-symbol-next)
)

;; 设置英语检错，设置有问题，暂时未解决
;; (setq ispell-program-name "aspell")
;; (setq ispell-dictionary
;;       (expand-file-name (concat spk-local-dir "english-words.txt"))
;;       ispell-complete-word-dict
;;       (expand-file-name (concat spk-local-dir "english-word.txt"))
;;       )

(provide 'init-editor)
