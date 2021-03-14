(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'ivy-rich)
(straight-use-package 'wgrep)

(autoload #'counsel-M-x "ivy")

;; 使用这种方式来管理配置之后，怎么管理快捷键？
(with-eval-after-load 'ivy
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; 开启一些命令的历史纪录
  ;; (setq counsel-M-x-history t)
  ;; (setq counsel-locate-history t)
  
  (global-set-key (kbd "C-s") #'swiper)
  (counsel-mode 1)
  ;; 开启ivy-mode 对于类似org-roam都会提供补全选项，很方便
  (ivy-mode t)
  ;; 在windows上用everthing 来替代locate命令
  (when IS-WINDOWS
    (setq locate-command "es"))

  ;; 在M-x 运行时显示相应的文档
  (require 'ivy-rich)
  (ivy-rich-mode t)
  )

(evil-leader/set-key
  "fl" 'counsel-locate)

(provide 'init-ivy)
