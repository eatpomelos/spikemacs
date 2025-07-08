;; 编程规范：
;; macro 格式为 +spk-xx-xx
;; function 格式为 spk/xx-xx
;; variables 格式为 spk-xx-xx

;; ;; 试用懒猫大神的启动速度优化思路
;; (straight-use-package 'benchmark-init)
;; (let (
;;     ;; 清空避免加载远程文件的时候分析文件。
;;     (file-name-handler-alist nil))
;; (require 'benchmark-init-modes)
;; (require 'benchmark-init)
;; (benchmark-init/activate)
;; ;; 下面才写你的其它配置
;; )

;; 因为使用了一些高于26版本的api，暂时不支持低于此版本的emacs
(when (version< emacs-version "26.0")
  (error "Emacs's version less than 26.0, can not load init files.")
  )

;; 当版本低于27.1的时候手动加载一遍early-init.el
(when (version< emacs-version "27.1")
  (message "Emacs's version less than 27.1,manual loading early-init file ...")
  (add-to-list 'load-path
               user-emacs-directory)
  (require 'spk-early-init)
  )

;; 参考懒猫大神的配置
(setq
 ;; 不要缩放frame.
 frame-inhibit-implied-resize t
 ;; 默认用最简单的模式
 initial-major-mode 'fundamental-mode
 ;; 不要自动启用package
 package-enable-at-startup nil
 package--init-file-ensured t)

(setq default-directory "~")

(require 'init-themes)
(require 'init-default)
(require 'init-autoload)

(let (
      (gc-cons-threshold most-positive-fixnum)
      (gc-cons-percentage 0.6)
      (file-name-handler-alist nil)
      )
  (global-display-line-numbers-mode t)
  (with-temp-message ""
    (require 'init-evil)
    (require 'init-ivy)
    
    (require 'init-window)
     ;; 可以延后加载的插件
    (run-with-idle-timer
     1 nil
     #'(lambda ()
         (require 'init-org)
         (require 'init-editor)
     
         (require 'init-magit)
         (require 'init-dired)

         ;; ;; ;; company 的配置包括 which-key
         (require 'init-company)
         ;; ;; ;; 和编程相关的配置统一由init-prog.el 文件一起加载，在文件中分别加载各语言的配置文件
         (require 'init-prog)
         ;; 部分配置只需要在linux上加载，这里使用宏进行控制，目前nixos上eaf先不加载
         (when (and IS-LINUX
                    (not IS-NIXOS)
                    (> (/ (+spk-get-memavailable) 1024) 8000))
           (require 'init-eaf)
           )

         (require 'init-widgets)

         ;; 这个文件按需求创建，主要是存放不同系统下自己可能使用的一些特定工具函数
         (spk-require 'init-private)
         (require 'init-ui)))

    ;; 在scratch中插入启动时间
    (add-hook 'window-setup-hook
              (lambda ()
                (switch-to-buffer "*scratch*")
                (erase-buffer)
                (insert (format "%s;; Happy hacking!! Emacs startup with %.3fs!!\n"
                                spk-scratch-log
                                (float-time (time-subtract (current-time) before-init-time)))))
              'append))
  )

(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
