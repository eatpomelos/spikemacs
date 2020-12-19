;; 用来配置安装的插件等一些东西。
(require 'package)
(package-initialize)

(setq package-archives
	    '(("gnu" . "http://elpa.emacs-china.org/gnu/")
	      ("melpa" . "http://elpa.emacs-china.org/melpa/")
	      ("org" . "http://elpa.emacs-china.org/org/")))

;; 使用use-package来更好地配置自己的配置，后面就可以用它来管理自己的配置了
(require 'use-package)

(provide 'spk-packages)
