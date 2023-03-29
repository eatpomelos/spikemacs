(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'ivy-rich)
(straight-use-package 'wgrep)
(straight-use-package 'smex)
(straight-use-package 'which-key)

;; 使用helpful插件替换原来的help
;; (straight-use-package 'helpful)

;; 使用这种方式来管理配置之后，怎么管理快捷键？
;; (global-set-key (kbd "M-x") #'counsel-M-x)
(global-set-key (kbd "C-s") #'swiper-isearch)

(ivy-rich-mode 1)

(with-eval-after-load 'ivy
  (setq ivy-use-virtual-buffers t)
  ;; (setq ivy-use-ignore nil)
  ;; (setq ivy-use-ignore-default nil)
  (setq enable-recursive-minibuffers t)

  (counsel-mode 1)
  ;; 开启ivy-mode 对于类似org-roam都会提供补全选项，很方便
  (ivy-mode t)
  ;; 在windows上用everthing 来替代locate命令
  (when IS-WINDOWS
    (setq locate-command "es"))

  (advice-add 'ivy-occur :after #'evil-window-move-far-right)
  (add-hook 'ivy-occur-grep-mode-hook
            #'(lambda ()
                (evil-emacs-state)))
  )

(add-hook 'evil-leader-mode-hook #'which-key-mode)
(with-eval-after-load 'which-key
  (setq which-key-idle-delay 0.1))

(evil-leader/set-key
  "fl" 'counsel-locate
  "x" 'counsel-M-x
  )

(provide 'init-ivy)
