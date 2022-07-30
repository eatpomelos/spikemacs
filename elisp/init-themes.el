;; 初始化主体配置，这里可以使用dracula 或者使用自己定义的主题
(straight-use-package 'circadian)

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
;; (straight-use-package 'modus-themes)
(straight-use-package 'zen-and-art-theme)

;; 根据时间加载主题
(when IS-LINUX
  (require 'circadian)
  (with-eval-after-load 'circadian
    (setq circadian-themes
          '(
            ("7:30" . spk-mint)
            ;; ("21:00" . spk-dark-mint)
            ("21:00" . modus-vivendi)
            ))
    (circadian-setup)
    ))

(when IS-WINDOWS
  (load-theme 'spk-mint))

(provide 'init-themes)
