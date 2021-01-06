;; 用来存放和ui相关的配置
;; 这个文件用来配置和界面相关的一些东西,主要是主题这些东西，还有配置modeline等一些东西
(setq-default cursor-type 'bar)

;; 把自己定义的主题添加进来
(add-to-list 'load-path
	     (concat spk-local-packges-dir "spk-mint-theme"))

(require 'spk-mint-theme)

;; 配置主题为吸血鬼主题
;; (require 'dracula-theme)
(load-theme spk-theme)

;; 定义插入在scratch中的message上
(defconst spk-scratch-messages
  '(
    ";;形而上者谓之道 形而下者谓之器
;;                      --  《易经·系辞》"
    ";;滚滚长江东逝水，浪花淘尽英雄。
;;是非成败转头空，青山依旧在，几度夕阳红。
;;白发渔樵江渚上，惯看秋月春风。
;;一杯浊酒喜相逢，古今多少事，都付笑谈中。"
    ";;天空一无所有，为何给我安慰
;;                   -- 海子"
    ";;人生如逆旅，我亦是行人。
;;                 -- 苏轼"
    ";;弃我去者，昨日之日不可留。
;;乱我心者，今日之日多烦忧。
;;                   -- 李白"
    ";;大梦谁先觉，平生我自知。
;;                 -- 诸葛亮"
    ";;明日复明日，明日何其多。
;;我生待明日，万事成蹉跎。
;;                 -- 《明日歌》明·钱福"
    ))

(setq spk-scratch-msg
      (let ((list spk-scratch-messages))
	(nth (random (1- (1+ (length list)))) list)))
;; 修改scratch buffer 头部显示的文字。
(setq initial-scratch-message (purecopy spk-scratch-msg))

;; 使用doom-modeline 来美化自己的编辑器
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  )

(require 'spk-dashboard)

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
    "wm" 'delete-other-windows
    "w-" 'split-window-below
    "w=" 'balance-windows
    "wL" 'evil-window-move-far-right
    "wH" 'evil-window-move-far-left
    "wJ" 'evil-window-move-very-bottom
    "wK" 'evil-window-move-very-top
    )
  )

;; 一个不错的modeline美化包
;; 不使用的原因在于很多插件并没有相应的支持，美化并不完整
;; (use-package mini-modeline
;;   :defer nil
;;   :config
;;   (mini-modeline-mode t) 
;;   ;; 配置modeline下面显示的东西,暂时设置一个固定的值，让下面的信息放在中间
;;   (setq mini-modeline-right-padding 25)
;;   ;; mini-modeline-l-format
;;   ;; mini-modeline-r-format
;;   )

;; 用颜色来标识括号
(use-package rainbow-delimiters
  :defer 1
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'org-mode-hook #'rainbow-delimiters-mode)
  )

;; 使用neotree 来管理文件
(use-package neotree
  :defer t 
  :init
  (evil-leader/set-key
    "ft" 'neotree-toggle)
  )

(require 'spk-dashboard)
(provide 'spk-ui)
