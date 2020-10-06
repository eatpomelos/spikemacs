;; 这个文件用来配置和界面相关的一些东西,主要是主题这些东西，还有配置modeline等一些东西
(setq-default cursor-type 'bar)

;; 配置主题为吸血鬼主题
(require 'dracula-theme)
(load-theme 'dracula)

;; 修改scratch buffer 头部显示的文字。
(setq initial-scratch-message (purecopy "\
;;形而上者谓之道 形而下者谓之器
;;                      -- 《易经·系辞》
"))

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  )

(require 'init-dashboard)

;; winnum-mode
(use-package winum
  :ensure t
  :defer 1
  :init
  (winum-mode 1)
  :config
  (evil-leader/set-key
   "0" 'winum-select-window-0-or-10
   "1" 'winum-select-window-1
   "2" 'winum-select-window-2
   "3" 'winum-select-window-3
   "4" 'winum-select-window-4
   "5" 'winum-select-window-5
   "6" 'winum-select-window-6
   "w/" 'split-window-right
   "w-" 'split-window-below
   )
  )

(provide 'init-ui)
