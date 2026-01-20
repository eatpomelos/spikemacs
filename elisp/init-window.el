;; 窗口操作相关配置  -*- lexical-binding: t; -*-
(straight-use-package 'winum)
(straight-use-package 'popwin)
;; (straight-use-package 'perspective)

(add-hook 'after-init-hook 'winum-mode)
(add-hook 'winum-mode-hook 'popwin-mode)

;; 开启winner-mode 控制window布局
(winner-mode 1)

(defconst spk-last-edit-register ?p
  "Variable for storing the last edit point you want to store.")

(setq register-preview-delay 0.5) ; 顺便加速预览
;; 强制重新加载已关闭的文件缓冲区而无需询问
(setq confirm-nonexistent-file-or-buffer nil)

;;;###autoload
(defun spk/last-point-record ()
  (interactive)
  (point-to-register spk-last-edit-register))

;;;###autoload
(defun spk/window-layout-record ()
  (interactive)
  (window-configuration-to-register spk-last-edit-register))

;;;###autoload
(defun spk/last-edit-jump ()
  (interactive)
  (jump-to-register spk-last-edit-register))

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
  	"mm" 'spk/last-point-record
	"mw" 'spk/window-layout-record
	"mj" 'spk/last-edit-jump
	"mp" 'winner-undo
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
  (global-set-key (kbd "C-c w w") 'delete-other-windows)
  (global-set-key (kbd "C-c w m") 'maximize-window)
  (global-set-key (kbd "C-c w d") 'delete-window)
  (global-set-key (kbd "C-c w =") 'balance-windows)
  (global-set-key (kbd "C-c m m") 'spk/last-point-record)
  (global-set-key (kbd "C-c m w") 'spk/window-layout-record)
  (global-set-key (kbd "C-c m j") 'spk/last-edit-jump)
  (global-set-key (kbd "C-c m p") 'winner-undo)
  )

;; 默认开启fringe时不设置边缘pixel
(fringe-mode 0)

;; (require 'perspective)
;; (persp-mode 1)

;; 设置工作区切换快捷键，后续继续优化
;; (evil-leader/set-key
;;     "ws" 'persp-switch
;;     )

(provide 'init-window)
