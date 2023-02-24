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

;; 使用awesome-tray来优化显示
;; (straight-use-package
;;    '(awesome-tray :type git
;; 		    :host github
;; 		    :repo "manateelazycat/awesome-tray"
;; 		    ))

;; ;; 后续尝试使用awesome-tray，暂时由于这个插件并不是基于evil以及一些窗口管理插件设计，需要修改一些自定义face
;; (require 'awesome-tray)
;; (awesome-tray-enable)

;; ;; 在某些模式下不开启awesome-tray
;; (defadvice ediff-buffers (after ediff-tray-disable-hack activate)
;;   (awesome-tray-disable))

;; (defadvice ediff-quit (after ediff-quit-tray-disable-hack activate)
;;   (awesome-tray-enable))

(provide 'init-ui)
