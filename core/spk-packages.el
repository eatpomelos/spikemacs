;; 用来配置安装的插件等一些东西。
(require 'package)
(package-initialize)

(setq package-archives
	    '(("gnu" . "http://elpa.emacs-china.org/gnu/")
	      ("melpa" . "http://elpa.emacs-china.org/melpa/")
	      ("org" . "http://elpa.emacs-china.org/org/")))

;; 使用straight.el 来作为包管理工具
;; github路径：https://github.com/raxod502/straight.el
;; 按照文档来安装
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; 使用use-package来更好地配置自己的配置，后面就可以用它来管理自己的配置了
(require 'use-package)

(provide 'spk-packages)
