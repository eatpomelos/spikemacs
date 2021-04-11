(require 'init-elisp)
(require 'init-C)

;; 配置ctags来生成标签和补全，在emacs上配置C语言相关的编程环境
(straight-use-package 'ctags)
(straight-use-package 'ctags-update)
(straight-use-package 'company-ctags)
(straight-use-package 'counsel-etags)

(autoload #'ctags-auto-update-mode "ctags-update")

;; 由于这个包暂时在没有界面的arch linux上运行存在问题，只在windows上启用
(when IS-WINDOWS
  (straight-use-package 'highlight-indent-guides)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(straight-use-package 'imenu-list)
;; (straight-use-package 'projectile)

(autoload #'imenu-list-smart-toggle "imenu-list")
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; (autoload #'projectile-mode "projectile")
;; (add-hook 'prog-mode-hook #'projectile-mode)
;; keybindings
(global-set-key (kbd "<f12>") 'eshell)
(global-set-key (kbd "<f2>") 'imenu-list-smart-toggle)

(with-eval-after-load 'imenu-list
  (setq
   imenu-list-position 'left
   imenu-list-size 0.25
   ))

(defvar spk-prog-jump-list nil
  "When called xref find definition to record position")

;; xref config
;; (advice-add 'xref--xref-buffer-mode :after #'evil-insert-state)
;; (define-key xref--xref-buffer-mode-map (kbd "j") 'xref-next-line)
;; (define-key xref--xref-buffer-mode-map (kbd "k") 'xref-prev-line)

;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=29619
(setq xref-prompt-for-identifier
      '(not
	xref-find-references
	xref-find-definitions
	xref-find-definitions-other-window
	xref-find-definitions-other-frame)
      )

(evil-leader/set-key
  "\'d" 'xref-find-definitions
  "\'f" 'counsel-etags-find-tag-at-point
)
(provide 'init-prog)
