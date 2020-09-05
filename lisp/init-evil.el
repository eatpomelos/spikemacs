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
      "bs" 'switch-to-scrtch-buffer
      "TAB" 'evil-switch-to-windows-last-buffer
      )
    )

  (use-package evil-surround
    :defer 3
    :init
    (global-evil-surround-mode 1)
    )
)

(provide 'init-evil)
