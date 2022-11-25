;; 窗口操作相关配置
(straight-use-package 'winum)
(straight-use-package 'popwin)

(add-hook 'after-init-hook 'winum-mode)
(add-hook 'winum-mode-hook 'popwin-mode)

(with-eval-after-load 'winum
  (setq winum-format " [%s] ")
  (evil-leader/set-key
    "0" 'winum-select-window-0-or-10
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5
    "6" 'winum-select-window-6
    "7" 'winum-select-window-7
    "8" 'winum-select-window-8
    "9" 'winum-select-window-9
    "w/" 'split-window-right
    ;; "wm" 'delete-other-windows
    "wm" 'maximize-window
    "wd" 'delete-window
    "w-" 'split-window-below
    "w=" 'balance-windows
    "wL" 'evil-window-move-far-right
    "wH" 'evil-window-move-far-left
    "wJ" 'evil-window-move-very-bottom
    "wK" 'evil-window-move-very-top
    )
  (add-to-list 'winum-ignored-buffers " *Neotree*")
  ;; 设置在不开启evil-normal-state时窗口切换的快捷键
  (global-set-key (kbd "C-x 9") 'delete-other-windows)
  (global-set-key (kbd "C-x 1") 'winum-select-window-1)
  (global-set-key (kbd "C-x 2") 'winum-select-window-2)
  (global-set-key (kbd "C-x 3") 'winum-select-window-3)
  (global-set-key (kbd "C-x 4") 'winum-select-window-4)
  (global-set-key (kbd "C-x 5") 'winum-select-window-5)
  )

(provide 'init-window)
