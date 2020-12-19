;; 用来存放本配置的一些全局设置
(defgroup spikemacs nil
  "Spikemacs configuration."
  :prefix "spk-"
  :group 'convenience)

(defcustom spk-theme 'dracula
  "The default color theme, change this in your /personal/preload config."
  :type 'symbol
  :group 'spikemacs)

;; require
(require 'spk-default)
(require 'spk-editor)
(require 'spk-org)
(require 'spk-prog)
(require 'spk-ui)
(require 'spk-widgets)
;; 可以考虑是否需要binding这个文件夹
(require 'spk-keybinding)

(provide 'spk)
