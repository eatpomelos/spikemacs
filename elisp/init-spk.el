;; 后续需要组织自己的配置的时候定义的一些自己的配置
(defgroup spikemacs nil
  "Spikemacs configuration."
  :prefix "spk-"
  :group 'convenience)

(defcustom spk-theme 'dracula
  "The default color theme, change this in your /personal/preload config."
  :type 'symbol
  :group 'spikemacs)

(provide 'init-spk)
