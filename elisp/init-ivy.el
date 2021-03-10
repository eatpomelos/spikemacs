(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'ivy-rich)
(straight-use-package 'wgrep)
;; 增加bind-key 包来扩展快捷键绑定
(straight-use-package 'bind-key)
(require 'bind-key)

(require 'ivy)

;; 使用这种方式来管理配置之后，怎么管理快捷键？
(with-eval-after-load 'ivy
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)

  (global-set-key (kbd "C-s") #'swiper)
  (counsel-mode 1)

  ;; 在windows上用everthing 来替代locate命令
  (when IS-WINDOWS
    (setq locate-command "es"))

  (require 'ivy-rich)
  (ivy-rich-mode t)
  )

(evil-leader/set-key
  "fl" 'counsel-locate)

(provide 'init-ivy)
