;; 用来存放和界面相关的配置  -*- lexical-binding: t; -*-
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-completion)

;; 将颜色相关的 RGB 值显示为对应颜色，这对主题定制等场景很好用
(straight-use-package 'rainbow-mode)

;; 默认 elisp-mode 打开 rainbow-mode
(add-hook 'emacs-lisp-mode-hook #'rainbow-mode)
;; 由于大文件中linum渲染会对性能有影响，这里使用自带display-line-numbers 替代
;; 在部分emacs29版本上移除了linum-mode
;; (when EMACS28+
;;   (straight-use-package 'linum+)
;;   (require 'linum+))

;; (global-linum-mode t)
;; (line-number-mode t)

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
		    :repo "eatpomelos/awesome-tray"
		    ))

;; 后续尝试使用awesome-tray，暂时由于这个插件并不是基于evil以及一些窗口管理插件设计，需要修改一些自定义face
(require 'awesome-tray)
(setq awesome-tray-file-name-max-length 30)
(setq awesome-tray-position 'center)
(setq awesome-tray-active-modules
      '("buffer-read-only" "file-path" "buffer-name" "git" "evil" "mode-name" "belong" "input-method" "date")
      )


(awesome-tray-enable)

;; 加载主题之后打开awesome-tray
(defadvice load-theme
    (after spk-load-theme-hack activate)
  (awesome-tray-enable))


(provide 'init-ui)
