;; 用来存放和界面相关的配置
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-completion)


;; 在部分emacs29版本上移除了linum-mode
(when EMACS28+
  (straight-use-package 'linum+)
  (require 'linum+))

(global-linum-mode t)

;; (straight-use-package 'doom-modeline)

;; (doom-modeline-mode 1)
;; (straight-use-package 'awesome-tab)
;; (straight-use-package
;;  '(awesome-tray :type git
;; 			    :host github
;; 			    :repo "manateelazycat/awesome-tray"
;; 			    ))

;; 配置awesome-tab，便于在几个常用的window之间切换
;; (with-eval-after-load 'awesome-tab
;;   (setq awesome-tab-display-icon t)
;;   (setq awesome-tab-height 120)
;;   (setq awesome-tab-show-tab-index t)
;;   (evil-leader/set-key
;;     "jt" 'awesome-tab-ace-jump
;;     "jg" 'awesome-tab-switch-group))

;; (awesome-tab-mode 1)

;; (setq awesome-tray-active-modules '("location" "evil" "file-path" "buffer-name" "git" "mode-name"))
;; (awesome-tray-mode 1)

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
