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
;; 设置显示不好的一些face,company-mode 的一些显示在C-mode下没有对齐,原因可能是因为中文
(custom-set-faces
 '(whitespace-indentation ((t (:inherit whitespace-space))))
 '(company-tooltip ((t (:foreground "#F0FCFF" :background "#28223e"))))
 '(company-scrollbar-bg ((t (:background "#28223e"))))
 '(company-scrollbar-fg ((t (:foreground "#F0FCFF"))))
 '(company-tooltip-selection ((t (:background "#333469"))))
 )

;; (load-theme 'dracula)

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
