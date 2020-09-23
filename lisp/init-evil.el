;; evil的配置，取消在插入模式的evil快捷键，只保留一个esc的快捷键
(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  )

(with-eval-after-load 'evil
  (use-package evil-leader
    :ensure t
    :init
    (global-evil-leader-mode)
    (evil-leader/set-leader "<SPC>")
    :config
    (evil-leader/set-key
      "fj" 'dired-jump
      "fr" 'counsel-recentf
      "bd" 'kill-this-buffer
      "bb" 'counsel-switch-buffer
      "TAB" 'evil-switch-to-windows-last-buffer
      "hk" 'describe-key
      "hv" 'describe-variable
      "hf" 'describe-function
      "hb" 'describe-bindings
      )
    )

  (use-package evil-surround
    :defer 3
    :init
    (global-evil-surround-mode 1)
    )

  ;; 设置更方便的注释方式，这里可以将自己以前的配置添加进来
  (use-package evil-nerd-commenter
    :defer 2
    :config
    (evil-leader/set-key
      ;; 下面的是官方文档中的快捷键设置，先注释掉，需要的时候开启想要的功能
      ;; "ci" 'evilnc-comment-or-uncomment-lines
      "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
      "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
      "cc" 'evilnc-copy-and-comment-lines
      "cp" 'evilnc-comment-or-uncomment-paragraphs
      ;; "cr" 'comment-or-uncomment-region
      ;; "cv" 'evilnc-toggle-invert-comment-line-by-line
      ;; "."  'evilnc-copy-and-comment-operator
      ;; "\\" 'evilnc-comment-operator	; if you prefer backslash key
      )
    (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
    )
  )

(provide 'init-evil)
