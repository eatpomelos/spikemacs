;; 关于目录操作相关的配置主要是 dired 以及其余对于目录等操作相关的  -*- lexical-binding: t; -*-

(straight-use-package 'neotree)
;; (straight-use-package 'dirvish)

(evil-leader/set-key
  "ft" 'neotree-toggle
  )

(with-eval-after-load "neotree"
  (define-key neotree-mode-map "h" #'left-char)
  (define-key neotree-mode-map "j" #'neotree-next-line)
  (define-key neotree-mode-map "k" #'neotree-previous-line)
  (define-key neotree-mode-map "l" #'right-char)
  (define-key neotree-mode-map "H" #'neotree-select-up-node)
  (define-key neotree-mode-map "J" #'neotree-select-next-sibling-node)
  (define-key neotree-mode-map "K" #'neotree-select-previous-sibling-node)
  (define-key neotree-mode-map "L" #'neotree-select-down-node)
  ;; 由于 neotree 实现的这个接口是使用的 linux 下的文件管理程序，在 windows 下使用自己实现的接口
  (define-key neotree-mode-map "o" #'spk-open-file-with-system-application)
  (setq neo-theme (if (is-gui) 'icons 'arrow))
  
  (setq neo-reset-size-on-open t)
  ;; 设置是否不固定 neotree 的大小，便于调整
  (setq neo-window-fixed-size nil)
  )

(with-eval-after-load "dired"
  (define-key dired-mode-map "w" #'wdired-change-to-wdired-mode)
  ;; 在 dired 中需要拷贝或者移动文件是，此时打开另一个 dired 页面，默认路径为另一个页面的路径
  (setq dired-dwim-target t)
  )

;; 在进入 neotree 显示的时候进入 evil 的 emacs-state
(evil-set-initial-state 'neotree-mode 'emacs)

(provide 'init-dired)
