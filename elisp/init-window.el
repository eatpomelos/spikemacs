;; 窗口操作相关配置
(straight-use-package 'winum)
(straight-use-package 'popwin)

(add-hook 'after-init-hook 'winum-mode)
(add-hook 'winum-mode-hook 'popwin-mode)

;; 设置modeline显示的内容
(setq mode-line-format
      (list
       '(:eval
        (format winum-format
                (winum-get-number-string)))
       mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
       (vc-mode vc-mode)
       "  " mode-line-modes mode-line-misc-info mode-line-end-spaces))

;; 设置modeline显示的内容
(setq mode-line-format
      (list
       '(:eval
         (format winum-format (winum-get-number-string)))
       mode-line-modified mode-line-frame-identification
       ))

(with-eval-after-load 'winum
  ;; (advice-add 'winum--switch-to-window :after 'maximize-window)
  ;; 移除设置了的advice
  ;; (advice-remove 'winum--switch-to-window 'maximize-window)
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
    ))

(provide 'init-window)
