;; 关于目录操作相关的配置主要是dired 以及其余对于目录等操作相关的

(straight-use-package 'neotree)
;; (straight-use-package 'dired-git-info)

(evil-leader/set-key
  "ft" 'neotree-toggle)

(with-eval-after-load "neotree"
  (define-key neotree-mode-map "h" #'left-char)
  (define-key neotree-mode-map "j" #'neotree-next-line)
  (define-key neotree-mode-map "k" #'neotree-previous-line)
  (define-key neotree-mode-map "l" #'right-char)
  ;; 由于neotree实现的这个接口是使用的linux下的文件管理程序，在windows下使用自己实现的接口
  (when IS-WINDOWS
    (define-key neotree-mode-map "o" #'spk-open-file-with-system-application))
  )

(with-eval-after-load "dired"
  (define-key dired-mode-map "w" #'wdired-change-to-wdired-mode)
  ;; 在dired中需要拷贝或者移动文件是，此时打开另一个dired页面，默认路径为另一个页面的路径
  (setq dired-dwim-target t)
  )

;; 在进入neotree显示的时候进入evil的insert-state
(advice-add 'neotree-show :after #'evil-insert-state)

(provide 'init-dired)
