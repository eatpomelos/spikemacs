;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题  -*- lexical-binding: t; -*-
(straight-use-package 'circadian)

(straight-use-package 'doom-themes)
(straight-use-package 'cyberpunk-theme)

;; 用straight-use-package来管理本地包
(straight-use-package
 '(spk-mint-theme
   :local-repo "~/.emacs.d/themes/spk-mint-theme" 
   ))
(straight-use-package 'dracula-theme)
(straight-use-package 'ef-themes)
(straight-use-package 'zen-and-art-theme)

;; (straight-use-package
;;    '(elegant-theme :type git
;; 		    :host github
;; 		    :repo "oracleyue/elegant-theme"))

;; 由于modus这个主题是在emacs27.1加入到emacs主线来的，低于这个版本的emacs需要自己手动下载
(when EMACS27-
  (straight-use-package 'modus-themes)
  )

;; 根据时间加载主题
(when (and IS-LINUX (is-gui))
  (require 'circadian)
  (with-eval-after-load 'circadian
    (setq circadian-themes
          '(
            ("7:30" . spk-mint)
            ;; ("18:00" . modus-vivendi)
            ;; ("18:00" . doom-city-lights)
            ("18:00" . ef-bio)
            ))
    (circadian-setup)
    )
  )

;; 在终端中使用暗色壁纸，提高性能 
(when (is-tui)
  (load-theme 'modus-vivendi :no-comfirm)
  )


;; (load-theme 'modus-vivendi)
;; (load-theme 'ef-bio :no-comfirm)
;; (load-theme 'spk-mint :no-comfirm)

;; 在加载新的主题之前先取消其他主题的设置
;; 1. 定义一个核心的、彻底的清洁切换函数
(defun my-switch-theme-cleanly (theme)
  "彻底禁用当前所有主题，并只加载指定的主题。"
  (interactive)
  ;; 禁用当前所有激活的主题
  (dolist (act-theme custom-enabled-themes)
    (disable-theme act-theme))
  ;; 强制重置 frame 的背景模式（防止深浅主题切换时背景发灰）
  (setq frame-background-mode nil)
  ;; 加载新主题
  (load-theme theme :no-confirm))

;; 2. 让标准的 load-theme 自动应用这个清洁逻辑
(advice-add 'load-theme :before
            (lambda (theme &rest _)
              (dolist (act-theme custom-enabled-themes)
                (unless (eq act-theme theme) ; 避免自己禁用自己
                  (disable-theme act-theme)))))

;; 3. 核心：专门针对 consult-theme 的预览和选中进行清理
(with-eval-after-load 'consult
  (advice-add 'consult-theme :after
              (lambda (&rest _)
                ;; 当 consult-theme 最终选定并退出后，确保只留这一个主题
                (when custom-enabled-themes
                  (let ((last-theme (car custom-enabled-themes)))
                    (my-switch-theme-cleanly last-theme))))))

;; (defadvice load-theme
;;     (before spk-disable-theme-hack activate)
;;   (mapc 'disable-theme custom-enabled-themes))

;; (load-theme 'spk-mint)

(provide 'init-themes)
