;; 窗口操作相关配置
(straight-use-package 'winum)
(straight-use-package 'popwin)

(autoload #'winum-mode "winum")
(autoload #'popwin-mode "popwin")

(add-hook 'after-init-hook 'winum-mode)
(add-hook 'winum-mode-hook 'popwin-mode)

(with-eval-after-load 'winum
  (evil-leader/set-key
    "0" 'winum-select-window-0-or-10
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5
    "6" 'winum-select-window-6
    "w/" 'split-window-right
    "wm" 'delete-other-windows
    "wd" 'delete-window
    "w-" 'split-window-below
    "w=" 'balance-windows
    "wL" 'evil-window-move-far-right
    "wH" 'evil-window-move-far-left
    "wJ" 'evil-window-move-very-bottom
    "wK" 'evil-window-move-very-top
    ))

(provide 'init-window)
