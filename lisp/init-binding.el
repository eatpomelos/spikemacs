;; 用来设置自己定义的一些快捷键
;; define key
(define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'end-of-line)
(define-key evil-insert-state-map (kbd "C-c v") 'set-mark-command)

;; bind key用于覆盖一些快捷键
(bind-key* "C-\-" 'text-scale-decrease)
(bind-key* "C-=" 'text-scale-increase)
(bind-key* "C-c C-l" 'goto-line)
(define-key evil-normal-state-map (kbd "C-z") 'evil-emacs-state)
(define-key evil-emacs-state-map (kbd "C-z") 'evil-normal-state)

;; global set key
(global-set-key (kbd "<f2>") 'counsel-describe-face)

;; 定义org-capture的快捷键
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

;; evil leader key set
(evil-leader/set-key
  "fp" 'spk-find-local-conf
  "fc" 'spk-find-emacs-confs
  ;; "ss" 'snails
  )

(provide 'init-binding)
