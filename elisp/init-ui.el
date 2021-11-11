;; 此文件在ivy加载完成之后才会加载
;; 这两个包分别是用来优化modeline以及开启ivy相关ui的图标显示 
;; (straight-use-package 'doom-modeline)
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-ibuffer)
(straight-use-package 'all-the-icons-completion)

;; (doom-modeline-mode 1)
(all-the-icons-ivy-rich-mode t)
;; 可以考虑把ibuffer功能也用起来
(all-the-icons-ibuffer-mode 1)
(all-the-icons-completion-mode)

;; 打开dired的ui支持
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; 设置title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "== " "Σ(｀д′*ノ)ノ "))
(setq-default frame-title-format spk-title-format)

(provide 'init-ui)
