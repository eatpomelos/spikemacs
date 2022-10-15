(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'ivy-rich)
(straight-use-package 'wgrep)
(straight-use-package 'smex)

;; 使用这种方式来管理配置之后，怎么管理快捷键？
(global-set-key (kbd "M-x") #'counsel-M-x)
(global-set-key (kbd "C-s") #'swiper)

(ivy-rich-mode 1)

(with-eval-after-load 'ivy
  (setq ivy-use-virtual-buffers t)
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

(evil-leader/set-key
  "fl" 'counsel-locate
  "x" 'counsel-M-x)

(provide 'init-ivy)
