(when (version< emacs-version "27.1")
  (message "emacs's version less than 27.1,manual to load early-init")
  (require 'spk-early-init)
  )

(setq default-directory "~")

(require 'init-spk)
(require 'init-ivy)
(require 'init-evil)

;; company 的配置包括 which-key
(require 'init-company)
(require 'init-theme)
(require 'init-widgets)

(put 'dired-find-alternate-file 'disabled nil)
