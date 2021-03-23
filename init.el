;; 当版本低于27.1的时候手动加载一遍early-init.el
(when (version< emacs-version "27.1")
  (message "emacs's version less than 27.1,manual to load early-init")
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
(put 'dired-find-alternate-file 'disabled nil)
