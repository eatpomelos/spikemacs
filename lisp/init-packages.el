;; 用来配置安装的插件等一些东西。
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

;; 这里设置一些核心的插件，之后再去把其余的插件进行分类
(use-package lispy
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'lispy-mode))

(provide 'init-packages)
