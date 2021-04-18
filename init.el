;; 当版本低于27.1的时候手动加载一遍early-init.el
(when (version< emacs-version "27.1")
  (message "emacs's version less than 27.1,manual loading early-init file ...")
  (add-to-list 'load-path
	       user-emacs-directory)
  (require 'spk-early-init)
  )

(setq default-directory "~")

(require 'init-default)
(require 'init-evil)
(require 'init-ivy)
(require 'init-org)
(require 'init-editor)
;; 和编程相关的配置统一由init-prog.el 文件一起加载，在文件中分别加载各语言的配置文件
(require 'init-prog)
(require 'init-window)
(require 'init-magit)
(require 'init-dired)

;; company 的配置包括 which-key
(require 'init-company)
(require 'init-themes)
(require 'init-widgets)

(put 'narrow-to-region 'disabled nil)

;; 编程规范：
;; macro 格式为 +spk-xx-xx
;; function 格式为 spk/xx-xx
;; variables 格式为 spk-xx-xx
(put 'erase-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
