;; 用来存放spikemacs 的按键绑定
;; define key
(define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'end-of-line)
(define-key evil-insert-state-map (kbd "C-c v") 'set-mark-command)
(define-key evil-normal-state-map (kbd "C-z") 'evil-emacs-state)
(define-key evil-emacs-state-map (kbd "C-z") 'evil-normal-state)

;; bind key用于覆盖一些快捷键
(bind-key* "C-<down>" 'text-scale-decrease)
(bind-key* "C-<up>" 'text-scale-increase)
(bind-key* "C-c C-l" 'goto-line)
;; (bind-key* "M-;" 'evilnc-comment-or-uncomment-lines)

;; global set key
(global-set-key (kbd "<f2>") 'counsel-describe-face)
(global-set-key (kbd "<f7>") 'loop-alpha)
(global-set-key (kbd "<f9>") 'spk/highlight_or_unhighlight_line_at_point)
(global-set-key (kbd "<f12>") 'eshell)

;; 定义org-capture的快捷键
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

;; evil leader key set
(evil-leader/set-key
  "t" #'spk-find-local-templet
  "fp" 'spk-find-local-conf
  "fc" 'spk-find-emacs-confs
  "fe" 'spk-find-local-elap-packages
  ;; "ss" 'snails
  "bm" 'bookmark-set
  "bj" 'counsel-bookmark
  "nr" 'narrow-to-region
  "nw" 'widen

  ;; windows
  "wd" 'delete-window
  )

(provide 'spk-keybinding)
