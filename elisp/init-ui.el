;; 用来存放和界面相关的配置
(straight-use-package 'doom-modeline)
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-ibuffer)
(straight-use-package 'all-the-icons-completion)
(straight-use-package 'org-bullets)

;; 定义一个新的minor-mode用来管理ui相关的配置
;;;###autoload
(define-minor-mode spk-pretty-mode
  "Minor mode for pretty ui."
  :keymap nil
  :global t
  :init-value nil
  (if (not spk-pretty-mode)
      (progn
        (remove-hook 'dired-mode-hook 'all-the-icons-dired-mode)
        ;; (doom-modeline-mode -1)
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
      ;; (doom-modeline-mode 1)
      (all-the-icons-ivy-rich-mode 1)
      (all-the-icons-ibuffer-mode 1)
      (all-the-icons-completion-mode 1)
      (awesome-tab-mode 1)
      (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
      (when (and (equal major-mode 'org-mode) (not org-bullets-mode))
        (org-bullets-mode 1))
      )
    ))

(doom-modeline-mode 1)
;; 设置title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "===  "))
(setq-default frame-title-format spk-title-format)

(provide 'init-ui)
