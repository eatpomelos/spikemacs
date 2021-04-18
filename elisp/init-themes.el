;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题
(defvar spk-theme-dir nil
  "Local themes directory.")
(setq spk-theme-dir (concat user-emacs-directory "themes/"))

(add-to-list 'load-path
	     (concat spk-theme-dir "spk-mint-theme/"))
;; 加载自己定义的亮色主题，需要时加载
(require 'spk-mint-theme)

(straight-use-package 'dracula-theme)
(straight-use-package 'dark-mint-theme)
(load-theme 'dark-mint)

;; 一个不错的modeline美化包
;; 不使用的原因在于很多插件并没有相应的支持，美化并不完整
;; (use-package mini-modeline
;;   :defer nil
;;   :config
;;   (mini-modeline-mode t) 
;;   ;; 配置modeline下面显示的东西,暂时设置一个固定的值，让下面的信息放在中间
;;   (setq mini-modeline-right-padding 25)
;;   ;; mini-modeline-l-format
;;   ;; mini-modeline-r-format
;;   )

(provide 'init-themes)
