;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题
(defvar spk-theme-dir nil
  "Local themes directory.")
(setq spk-theme-dir (concat user-emacs-directory "themes/"))

(add-to-list 'load-path
	         (concat spk-theme-dir "spk-mint-theme/"))
;; 加载自己定义的亮色主题，需要时加载
;; (require 'spk-mint-theme)
;; (require 'spk-dark-mint-theme)

(straight-use-package 'doom-themes)
(straight-use-package 'cyberpunk-theme)

;; 用straight-use-package来管理本地包
(straight-use-package
 '(spk-mint-theme
   :local-repo "~/.emacs.d/themes/spk-mint-theme" 
   ))
;; (straight-use-package 'dracula-theme)
;; 这个包自己hack一下，用spk-dark-ming-theme来替代
;; (straight-use-package 'dark-mint-theme)

;; (straight-use-package
;;  '(xcode-theme :type git
;;                :host github
;;                :repo "juniorxxue/xcode-theme"))

;; (load-theme 'cyberpunk)
;; 自己的亮色主题，比较喜欢背景色，但是其余颜色调的不好 
(load-theme 'spk-mint)

;; 一个不错的modeline美化包，基本思想是将modeline调整为一条线，然后使用minibuffer来显示modeline需要显示的东西
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
