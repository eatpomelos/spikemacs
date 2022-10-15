;; 用来存放和界面相关的配置
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-completion)


;; 在部分emacs29版本上移除了linum-mode
(when EMACS28+
  (straight-use-package 'linum+)
  (require 'linum+))

(global-linum-mode t)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(all-the-icons-completion-mode 1)
(all-the-icons-ivy-rich-mode 1)

(defconst spk-scratch-log
  ";;   _____       _ __                                 
;;  / ___/____  (_) /_____  ____ ___  ____ ___________
;;  \\__ \\/ __ \\/ / //_/ _ \\/ __ `__ \\/ __ `/ ___/ ___/
;; ___/ / /_/ / / ,< /  __/ / / / / / /_/ / /__(__  ) 
;;/____/ .___/_/_/|_|\\___/_/ /_/ /_/\\__,_/\\___/____/  
;;    /_/
\n"
  )

;; 设置title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "===  "))
(setq-default frame-title-format spk-title-format)

;; 设置 mode-line-format 只显示自己要的关键信息
(setq-default mode-line-format
      '("%e"
        mode-line-modified
        " "
        mode-line-position
        mode-line-buffer-identification
        (:eval
         (format " [%s %d] " major-mode (point)))
        (:eval
         (when (+spk-get-file-dir ".git")
           (format "[Pjt:%s]" (+spk-get-file-dir ".git")))
         )
        ))

(provide 'init-ui)
