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
        mode-line-misc-info
        ))

(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

(setq-default display-time-format " %F %R")

;; 使用awesome-tray来优化显示
(straight-use-package
   '(awesome-tray :type git
		    :host github
		    :repo "manateelazycat/awesome-tray"
		    ))

;; 后续尝试使用awesome-tray，暂时由于这个插件并不是基于evil以及一些窗口管理插件设计，需要修改一些自定义face
(require 'awesome-tray)
(setq awesome-tray-active-modules
      '("file-path" "buffer-name" "evil" "location" "mode-name" "belong" "date"))

(awesome-tray-enable)

;; 加载主题之后打开awesome-tray
(defadvice load-theme
    (after spk-load-theme-hack activate)
  (awesome-tray-enable))


(provide 'init-ui)
