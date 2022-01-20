;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题
(defvar spk-theme-dir nil
  "Local themes directory.")
(setq spk-theme-dir (concat user-emacs-directory "themes/"))

(add-to-list 'load-path
	         (concat spk-theme-dir "spk-mint-theme/"))

(straight-use-package 'doom-themes)
(straight-use-package 'cyberpunk-theme)

;; 用straight-use-package来管理本地包
(straight-use-package
 '(spk-mint-theme
   :local-repo "~/.emacs.d/themes/spk-mint-theme" 
   ))
;; (straight-use-package 'dracula-theme)
;; (straight-use-package 'modus-themes)

;; (straight-use-package
;;  '(xcode-theme :type git
;;                :host github
;;                :repo "juniorxxue/xcode-theme"))

;; (load-theme 'cyberpunk)
;; 自己的亮色主题，比较喜欢背景色，但是其余颜色调的不好 
(load-theme 'spk-mint)

;; (load-theme 'spk-dark-mint)
;; (load-theme 'doom-city-lights)
;; (load-theme 'modus-vivendi)
;; (load-theme 'modus-operandi)

(provide 'init-themes)
