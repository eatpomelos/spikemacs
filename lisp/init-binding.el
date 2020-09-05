;; 用来设置自己定义的一些快捷键
(define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'end-of-line)

(provide 'init-binding)
