;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题
(add-to-list 'load-path
	     (concat spk-local-packges-dir "spk-mint-theme"))

(require 'spk-mint-theme)

(straight-use-package 'dracula-theme)
(load-theme 'dracula)

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

(provide 'init-theme)
