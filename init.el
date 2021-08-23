;; 编程规范：
;; macro 格式为 +spk-xx-xx
;; function 格式为 spk/xx-xx
;; variables 格式为 spk-xx-xx

;; 因为使用了一些高于26版本的api，暂时不支持低于此版本的emacs
(when (version< emacs-version "26.0")
  (error "emacs's version less than 26.0, can not load init files.")
  )

;; 当版本低于27.1的时候手动加载一遍early-init.el
(when (version< emacs-version "27.1")
  (message "emacs's version less than 27.1,manual loading early-init file ...")
  (add-to-list 'load-path
			   user-emacs-directory)
  (require 'spk-early-init)
  )

(setq default-directory "~")

(require 'init-default)                 ;;0.47s
(require 'init-evil)                    ;;0.875
(require 'init-ivy)                     ;; 0.875
(require 'init-org)                     ;; 1.794
(require 'init-editor)                  ;; 1.84
;; ;; 和编程相关的配置统一由init-prog.el 文件一起加载，在文件中分别加载各语言的配置文件
(require 'init-prog)                    ;;2.75s
(require 'init-window)                  ;;3.18s
(require 'init-magit)                   ;; 3.79s
(require 'init-dired)                   ;; 3.14s

;; ;; company 的配置包括 which-key
(require 'init-company)                 ;;5.159s
(require 'init-themes)                  ;;5.159
(require 'init-widgets)                 ;;5.159

(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; 在scratch中插入启动时间
(add-hook 'window-setup-hook
          (lambda ()
            (switch-to-buffer "*scratch*")
            (erase-buffer)
            (insert (format ";; Happy hacking!! emacs startup with %.3fs!!\n" (float-time (time-subtract (current-time) before-init-time)))))
          'append)

