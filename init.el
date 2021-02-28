;; 加快启动速度
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216 ; 16mb
          gc-cons-percentage 0.1)))

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

;; 把配置分为两部分，一部分是核心配置，一部分是模块配置，模块配置主要来配置某一个功能，这里可以参照doom
(defconst spk-core-dir
  (concat spk-dir "core/"))

(defconst spk-modules-dir
  (concat spk-dir "modules/"))

;; 把存放elisp文件的路径存放到加载路径中
(progn
  (add-to-list 'load-path spk-core-dir)
  (add-to-list 'load-path spk-modules-dir))

(setq org-directory "~/org")

(require 'dired)
(global-set-key (kbd "C-x C-j") 'dired-jump)

;; 精简配置，将配置中能够在不同系统之间通用的 
(when IS-WINDOWS
  ;; 考虑优化一下下面的加载顺序和依赖关系
  (require 'spk-lib)
  (require 'spk-default)
  (require 'spk-packages)
  (require 'spk-core)
  (require 'spk))

(when IS-LINUX
  (require 'spk-lib)
  (require 'spk-simple-init))

;; 加载顺序：
;; lib
;; default
;; package
;; core
;; spk
;; editor
;; org
;; prog
;; ui
;; binding

;; 下面的是自动生成的，在执行某些命令的时候需要默认某一种模式
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
