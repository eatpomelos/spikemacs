;; 用来存放和界面相关的配置
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-completion)

(straight-use-package
 '(awesome-tray :type git
			:host github
			:repo "manateelazycat/awesome-tray"
			))

(setq awesome-tray-active-modules '("location" "belong" "file-path" "buffer-name" "mode-name" "battery" "date"))
(require 'awesome-tray)
(awesome-tray-mode 1)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(all-the-icons-completion-mode 1)
(all-the-icons-ivy-rich-mode 1)

;; 设置title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "===  "))
(setq-default frame-title-format spk-title-format)

(provide 'init-ui)
