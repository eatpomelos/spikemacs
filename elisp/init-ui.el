;; 用来存放和界面相关的配置  -*- lexical-binding: t; -*-
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-completion)
(straight-use-package 'nerd-icons-completion)

;; 将颜色相关的 RGB 值显示为对应颜色，这对主题定制等场景很好用
(straight-use-package 'rainbow-mode)

(straight-use-package
 '(image-slicing :host github :repo "ginqi7/image-slicing"))

(with-eval-after-load 'marginalia
  (if IS-WSL
      (all-the-icons-completion-mode 1)
    (nerd-icons-completion-mode 1)))

(require 'image-slicing)
(add-to-list 'shr-external-rendering-functions
             '(img . image-slicing-tag-img))
(push #'image-slicing-mode eww-after-render-hook)

;; (require 'block)
;; (straight-use-package
;;  '(ekp :host github :repo "Kinneyzhang/emacs-kp"
;;        :files (:defaults "*.el" "dictionaries")
;;        ))

;; (straight-use-package
;;  '(ETML :host github :repo "Kinneyzhang/ETML"))

;; 默认 elisp-mode 打开 rainbow-mode
(add-hook 'emacs-lisp-mode-hook #'rainbow-mode)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; (set-default-font)
;; 设置title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "===  "))
(setq-default frame-title-format spk-title-format)

(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

(setq-default display-time-format " %F %R")

(defun spk/consult-buffer-select ()
  (interactive)
  (let* ((consult-buffer-sources '(consult-source-buffer))
         (consult-buffer-filter
               '(
                 "\\` "
                 "\\`\\*Completions\\*\\'"
                 "\\`\\*Multiple Choice Help\\*\\'"
                 "\\`\\*Flymake log\\*\\'"
                 "\\`\\*Semantic SymRef\\*\\'"
                 "\\`\\*vc\\*\\'"
                 "\\`newsrc-dribble\\'" ;; Gnus
                 "\\`\\*tramp/.*\\*\\'"
                 "\\` \\*.*\\'"
                 "\\`COMMIT_EDITMSG\\'"
                 )))
    (consult-buffer))
  )

(global-set-key (kbd "C-c s") 'spk/consult-buffer-select)

;; 使用awesome-tray来优化显示
(straight-use-package
 '(awesome-tray :type git
		        :host github
		        :repo "eatpomelos/awesome-tray"
		        ))

(straight-use-package 'hide-mode-line)
;; 后续尝试使用awesome-tray，暂时由于这个插件并不是基于evil以及一些窗口管理插件设计，需要修改一些自定义face
(when (is-gui)
  (require 'awesome-tray)
  (setq awesome-tray-file-name-max-length 30)
  (setq awesome-tray-position 'center)
  (setq awesome-tray-active-modules
        '("buffer-read-only" "file-path" "buffer-name" "location" "git" "evil" "mode-name" "belong" "input-method" "date")
        )
  (setq awesome-tray-location-format "%l:%p")
  (global-hide-mode-line-mode t)
  
  ;; 开启原生的视窗分割线（高度定制化边框）
  (setq window-divider-default-bottom-width 1)      ; 边框宽度设为 1 像素
  (setq window-divider-default-places 'bottom-only) ; 只在底部显示边框
  (window-divider-mode 1)                           ; 全局激活

  (with-eval-after-load 'awesome-tray
    ;; 将分割线的颜色设为浅灰色
    (set-face-attribute 'window-divider nil :foreground "#444444")
    (set-face-attribute 'window-divider-last-pixel nil :foreground "#444444"))

  (awesome-tray-enable)
  ;; 加载主题之后打开awesome-tray
  (defadvice load-theme
      (after spk-load-theme-hack activate)
    (awesome-tray-enable)
    )
  )

(provide 'init-ui)
