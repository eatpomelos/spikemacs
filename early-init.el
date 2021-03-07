;; 在init.el 启动之前运行的文件 

;; 加快启动速度
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216 ; 16mb
          gc-cons-percentage 0.1)))

;; 设置自己配置中的一些关于环境的配置
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
(defconst spk-elisp-dir
  (concat spk-dir "elisp/"))

(add-to-list 'load-path spk-elisp-dir)

(setq org-directory "~/org")

;; 避免在切换不同文件按之后生成很多的buffer
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;; 便于调试配置时候使用
;; (require 'dired)
;; (global-set-key (kbd "C-x C-j") 'dired-jump)

(require 'init-lib)
(require 'init-default)
(require 'init-straight)

;; 运行在不支持 early-init 的 emacs 版本上时在 init.el 文件中手动加载此文件
(provide 'spk-early-init)
