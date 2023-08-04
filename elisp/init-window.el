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
    "wm" 'maximize-window
    "ww" 'delete-other-windows
    "wd" 'delete-window
    "w-" 'split-window-below
    "w=" 'balance-windows
    "wL" 'evil-window-move-far-right
    "wH" 'evil-window-move-far-left
    "wJ" 'evil-window-move-very-bottom
    "wK" 'evil-window-move-very-top
    )

  ;; 把一些辅助插件的buffer加入到ignore列表中，不进行winum排序
  ;; (add-to-list 'winum-ignored-buffers " *NeoTree*")
  ;; 一般开启Ilist  
  ;; (add-to-list 'winum-ignored-buffers "*Ilist*")
  ;; 暂时只需要4个快捷键，开启五个窗口的情况比较少
  (global-set-key (kbd "C-c 1") 'winum-select-window-1)
  (global-set-key (kbd "C-c 2") 'winum-select-window-2)
  (global-set-key (kbd "C-c 3") 'winum-select-window-3)
  (global-set-key (kbd "C-c 4") 'winum-select-window-4)
  (global-set-key (kbd "C-c 9") 'delete-other-windows)
  (global-set-key (kbd "C-c /") 'split-window-right)
  (global-set-key (kbd "C-c -") 'split-window-below)
  )

;; 默认开启fringe时不设置边缘pixel
(fringe-mode 0)

(provide 'init-window)
