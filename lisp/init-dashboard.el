;; 配置自己的emacs主页。
;; 以下是备选的几种方案，暂时使用第一种
;;    _____       _ __                                 
;;   / ___/____  (_) /_____  ____ ___  ____ ___________
;;   \__ \/ __ \/ / //_/ _ \/ __ `__ \/ __ `/ ___/ ___/
;;  ___/ / /_/ / / ,< /  __/ / / / / / /_/ / /__(__  ) 
;; /____/ .___/_/_/|_|\___/_/ /_/ /_/\__,_/\___/____/  
;;     /_/                                           

;; 2.备选2
;;   ____        _ _                                 
;;  / ___| _ __ (_) | _____ _ __ ___   __ _  ___ ___ 
;;  \___ \| '_ \| | |/ / _ \ '_ ` _ \ / _` |/ __/ __|
;;   ___) | |_) | |   <  __/ | | | | | (_| | (__\__ \
;;  |____/| .__/|_|_|\_\___|_| |_| |_|\__,_|\___|___/
;;        |_|                                        

;; 3.备选3
;;  ________  ________  ___  ___  __    _______   _____ ______   ________  ________  ________      
;; |\   ____\|\   __  \|\  \|\  \|\  \ |\  ___ \ |\   _ \  _   \|\   __  \|\   ____\|\   ____\     
;; \ \  \___|\ \  \|\  \ \  \ \  \/  /|\ \   __/|\ \  \\\__\ \  \ \  \|\  \ \  \___|\ \  \___|_    
;;  \ \_____  \ \   ____\ \  \ \   ___  \ \  \_|/_\ \  \\|__| \  \ \   __  \ \  \    \ \_____  \   
;;   \|____|\  \ \  \___|\ \  \ \  \\ \  \ \  \_|\ \ \  \    \ \  \ \  \ \  \ \  \____\|____|\  \  
;;     ____\_\  \ \__\    \ \__\ \__\\ \__\ \_______\ \__\    \ \__\ \__\ \__\ \_______\____\_\  \ 
;;    |\_________\|__|     \|__|\|__| \|__|\|_______|\|__|     \|__|\|__|\|__|\|_______|\_________\
;;    \|_________|                                                                     \|_________|


;; 4.备选4
;;  ______  ______  ________  ___   ___  ______  ___ __ __  ________  ______  ______      
;; /_____/\/_____/\/_______/\/___/\/__/\/_____/\/__//_//_/\/_______/\/_____/\/_____/\     
;; \::::_\/\:::_ \ \__.::._\/\::.\ \\ \ \::::_\/\::\| \| \ \::: _  \ \:::__\/\::::_\/_    
;;  \:\/___/\:(_) \ \ \::\ \  \:: \/_) \ \:\/___/\:.      \ \::(_)  \ \:\ \  _\:\/___/\   
;;   \_::._\:\: ___\/ _\::\ \__\:. __  ( (\::___\/\:.\-/\  \ \:: __  \ \:\ \/_/\_::._\:\  
;;     /____\:\ \ \  /__\::\__/\\: \ )  \ \\:\____/\. \  \  \ \:.\ \  \ \:\_\ \ \/____\:\ 
;;     \_____\/\_\/  \________\/ \__\/\__\/ \_____\/\__\/ \__\/\__\/\__\/\_____\/\_____\/ 

;; 设置方法：将以上图标保存为n.txt 放到dashboard目录下的banners目录下

;; 实际上这里设置的变量是无效的，因为dashboard插件中是定义的一个静态变量，因此无法改变

(defvar +spike-dashboard-name "*spikemacs*")

(defvar +spike-dashboard-info "Spikemacs")

;; 自定义要插入的文本，看一下插入在哪个位置
(defun dashboard-insert-custom (list-size)
  (insert "Custom text"))

;; 这里应该是自定义要插入的文本，暂时不清楚插入的位置，这里先注释掉 
;;(add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom)) 
;;(add-to-list 'dashboard-items '(custom) t)

(use-package dashboard
  :ensure t

  :init

  ;; 实际上这个变量定义的是一个固定的值，所以这个改动是没用的
  ;;(setq dashboard-buffer-name +spike-dashboard-name)
  (setq dashboard-set-init-info t)
  ;; (setq dashboard-init-info +spike-dashboard-info)
  (setq dashboard-banner-logo-title "Welcome to spikemacs")
  
  ;; Content is not centered by default. To center, set
  (setq dashboard-center-content t)
  ;; To disable shortcut "jump" indicators for each section, set
  (setq dashboard-show-shortcuts t)

  ;; 设置banner为自己的spikemacs图标
  (setq dashboard-startup-banner 4)
  ;; 开启图标,但是图标的大小实在诡异，这里先注释掉
  ;; (setq dashboard-set-heading-icons t)
  ;; (setq dashboard-set-file-icons t)

  ;;  (setq dashboard-set-navigator t)
  ;; Format: "(icon title help action face prefix suffix)"
  ;; (setq dashboard-navigator-buttons
  ;;       `(;; line1
  ;;         ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
  ;;          "Homepage"
  ;;          "Browse homepage"
  ;;          (lambda (&rest _) (browse-url "homepage")))
  ;;         ("★" "Star" "Show stars" (lambda (&rest _) (show-stars)) warning)
  ;;         ("?" "" "?/h" #'show-help nil "<" ">"))
  ;;          ;; line 2
  ;;         ((,(all-the-icons-faicon "linkedin" :height 1.1 :v-adjust 0.0)
  ;;           "Linkedin"
  ;;           ""
  ;;           (lambda (&rest _) (browse-url "homepage")))
  ;;          ("⚑" nil "Show flags" (lambda (&rest _) (message "flag")) error))))

  ;; 默认的注脚美观程度更好
  ;; (setq dashboard-set-footer nil)
  (setq dashboard-set-footer t)
  ;; (setq dashboard-footer-messages '("Dashboard is pretty cool!"))
  ;; (setq dashboard-footer-icon (all-the-icons-octicon "dashboard"
  ;;                                                    :height 1.1
  ;;                                                    :v-adjust -0.05
  ;;                                                    :face 'font-lock-keyword-face))

  ;; 与org agenda相关的设置
  (setq show-week-agenda-p t)
  (setq dashboard-org-agenda-categories '("Tasks" "Appointments"))

  :config
  (add-to-list 'dashboard-items '(agenda) t)
  (dashboard-setup-startup-hook)
  )

(provide 'init-dashboard)
