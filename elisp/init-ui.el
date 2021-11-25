;; 此文件在ivy加载完成之后才会加载
(straight-use-package 'doom-modeline)
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-ibuffer)
(straight-use-package 'all-the-icons-completion)
(straight-use-package 'org-bullets)

;; 添加一个新的次模式来管理ui
;;;###autoload
(define-minor-mode spk-pretty-mode
  "Minor mode for pretty ui."
  :keymap nil
  :global t
  :init-value nil
  (if (not spk-pretty-mode)
      (progn
        (remove-hook 'dired-mode-hook 'all-the-icons-dired-mode)
        (doom-modeline-mode -1)
        (all-the-icons-ivy-rich-mode -1)
        (all-the-icons-ibuffer-mode -1)
        (all-the-icons-completion-mode -1)
        (awesome-tab-mode -1)
        (remove-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
        (when (and (equal major-mode 'org-mode) org-bullets-mode)
          (org-bullets-mode -1))
        )
    (progn
      (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
      (doom-modeline-mode 1)
      (all-the-icons-ivy-rich-mode 1)
      (all-the-icons-ibuffer-mode 1)
      ;; 打开dired的ui支持
      (all-the-icons-completion-mode 1)
      (awesome-tab-mode 1)
      (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
      (when (and (equal major-mode 'org-mode) (not org-bullets-mode))
        (org-bullets-mode 1))
      )
    ))

;; 设置title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "== " "Σ(｀д′*ノ)ノ "))
(setq-default frame-title-format spk-title-format)

(provide 'init-ui)
