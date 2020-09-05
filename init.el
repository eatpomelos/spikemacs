;; 现在还没有写出一个很好的配置的能力，请不要多想，首先自己把自己的一些刚需先实现，然后再去考虑多余的东西
(defun spikemacs-open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  )

(global-set-key (kbd "<f2>") 'spikemacs-open-init-file)

;; 可以将自己需要的功能呢配起来， 后面再将自己的配置进行一个结构的更新。
;; 首先设置自己的读取目录，这里使用了两个函数来动态确定自己的emacs的.emacs.d的路径
(defconst spikemacs-dir
  (eval-when-compile (file-truename user-emacs-directory)))

(defconst spikemacs-local-dir
  (concat spikemacs-dir ".local/"))

(add-to-list 'load-path (concat spikemacs-dir "lisp"))

(require 'dired)
(global-set-key (kbd "C-x C-j") 'dired-jump)

(require 'init-default)
(require 'init-core)
(require 'init-binding)
(require 'init-ui)
