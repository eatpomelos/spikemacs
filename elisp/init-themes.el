;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题
;; (straight-use-package 'circadian)

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
(straight-use-package 'dracula-theme)
(straight-use-package 'zen-and-art-theme)

;; 根据时间加载主题
;; (when IS-LINUX
  ;; (require 'circadian)
  ;; (with-eval-after-load 'circadian
  ;;   (setq circadian-themes
  ;;         '(
  ;;           ("7:30" . spk-mint)
  ;;           ("18:00" . modus-vivendi)
  ;;           ))
  ;;   (circadian-setup)
  ;;   )
  ;; )

;; 由于modus这个主题是在emacs27.1加入到emacs主线来的，低于这个版本的emacs需要自己手动下载
(when EMACS27-
  (straight-use-package 'modus-themes)
  )
(load-theme 'modus-vivendi)

;; 在加载新的主题之前先取消其他主题的设置
(defadvice load-theme
    (before spk-disable-theme-hack activate)
  (mapc 'disable-theme custom-enabled-themes))

;; (when IS-WINDOWS
;;   (load-theme 'spk-mint))

(provide 'init-themes)
