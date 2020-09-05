(require 'package)
(package-initialize)
;; 之前的那些初始化的设置可以在后面再次加进来
;; ivy 作为框架中最重要的一个包来进行使用

(setq package-archives
	    '(("gnu" . "http://elpa.emacs-china.org/gnu/")
	      ("melpa" . "http://elpa.emacs-china.org/melpa/")
	      ("org" . "http://elpa.emacs-china.org/org/")))

;; 使用use-package来更好地配置自己的配置，后面就可以用它来管理自己的配置了
(require 'use-package)

(require 'init-evil)
;; 配置ivy相关的一些快捷键等，这里考虑要不要继续使用use-package来进行管理。
(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;;(setq search-default-mode #'char-fold-to-regexp)
  (global-set-key (kbd "C-s") 'swiper)
  (counsel-mode 1)
  )
;; 安装完成ｉｖｙ去阅读文档，讲其中的一些东西进行配置，了解自己使用的插件

(use-package which-key
  :ensure t
  :init
  (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0)
  (setq which-key-side-window-location 'bottom)
  )

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  )

(provide 'init-core)
