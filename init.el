;; 加快启动速度
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216 ; 16mb
          gc-cons-percentage 0.1)))

(defun spk-switch-to-scratch ()
  (interactive)
  (save-excursion
    (switch-to-buffer "*scratch*")))

;; 可以将自己需要的功能先配起来， 后面再将自己的配置进行一个结构的更新。
;; 首先设置自己的读取目录，这里使用了两个函数来动态确定自己的emacs的.emacs.d的路径
(defconst spk-dir
  (eval-when-compile (file-truename user-emacs-directory)))

(defconst spk-local-dir
  (concat spk-dir ".local/"))

(defconst spk-local-tmp-dir
  (concat spk-local-dir "tmp/")
  "Directory of temp files.")
  
;; 私有包放置的位置，可能是没有加入elpa的包或者是自己为了学elisp而抄的或者写的demo
(defconst spk-local-packges-dir
  (concat spk-local-dir "packages/"))

;; 放置一些模板的地址，主要是一些函数以及机制的使用实例，后续设计具体的一些实现和模板
(defconst spk-local-templet-dir
  (concat spk-local-dir "templet/"))

(add-to-list 'load-path (concat spk-dir "lisp"))

(setq org-directory "~/org")

(require 'dired)
(global-set-key (kbd "C-x C-j") 'dired-jump)

;; 考虑优化一下下面的加载顺序和依赖关系
(require 'spk-lib)
(require 'init-default)
(require 'init-packages)
(require 'init-core)
(require 'init-binding)
(require 'init-ui)

(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
