;; 这里应该是后面要调用一些接口，这里使用cl-lib
(require 'cl-lib)

;; 定义自己的theme,之后定义好了可以添加在group里面，通过设置dufcustom来实现
(deftheme spk-mint)

;; ,@应该指的是后面的需要求值，通过这里的使用来看是这样的，这里主要是定义一个简单的主题来实现自己的一些需求
;; 

;;;; Configuration options:

(defgroup spk-mint nil
  "Spk-mint theme options.
The theme is emulate spk-mint to learn elisp."
  :group 'faces)

;;;; Theme definition:
;; theme主要的难点是需要设置大量的face，需要对这些face有一定的了解，可定制的地方太多了，现在的思路是：将经常使用的一些颜色定义一下，当后面添加了新的模块的时候再去增加
;; 使用的一些颜色都是一些比较浅的颜色 
(let (;; Upstream theme color
      (spk-mint-bg "#E0FFFF")     ;;一个薄荷色的背景
      (spk-mint-snow "#F0FCFF")   ;;雪白色
      ;; (spk-mint-bg "#E3F9FD") ;;莹白色
      (spk-mint-fg "#424C50")         ;;鸭青
      (spk-mint-purple "#B0A4E3")     ;; 淡蓝紫色
      (spk-mint-darkpurple "#801DAE") ;; 深紫色
      (spk-mint-red "#BE002F")        ;;殷红
      (spk-mint-white "#F9F1F6")      ;;霜色
      (spk-mint-blue "#5F9EA0")       ;;灰蓝色
      (spk-mint-skyblue "#70F3FF")    ;; 蔚蓝
      (spk-mint-oriange "#FA8C35")
      (spk-mint-yellow "#FFA631")     ;; 杏黄
      (spk-mint-pink "#ff79c6")
      (spk-mint-green "#48C0A3")      ;; 青碧
      (spk-mint-darkgreen "#009688")      ;; 青碧
      (spk-mint-violetred "#EE3A8C")  ;;紫罗兰红
      (spk-mint-bamboo "#789262") ;; 竹青
      (spk-mint-cyan "#4C8DAE")   ;; 藏青
      (spk-mint-lightblue "#B0C4DE")
      (spk-mint-moon "#D6ECF0")     ;; 月白
      (spk-mint-darkblue "#003371") ;;藏蓝
      (spk-mint-comment "#a6b4b9") ;;用于注释的颜色
      )

  ;; 设置face，使用之前相关的设置，这里使用的方式是没有封装的最原始的方式，使用反引号的时候，使用下面的方式来进行变量的取值
  (custom-theme-set-faces
   'spk-mint
   ;; default 设置的颜色中，没有设置face的部分使用default的前景和后景
   `(default ((t (:background ,spk-mint-bg :foreground ,spk-mint-fg))))
   `(cursor ((t (:background ,spk-mint-cyan))))
   ;; `(region ((t (:background ,spk-mint-purple))))
   `(region ((t (:background ,spk-mint-darkgreen))))

   ;; 左边的边缘条设置
   `(fringe  ((t (:background ,spk-mint-bg :foreground ,spk-mint-fg))))
   ;; `(show-paren-match (:background ,background :foreground ,spk-mint-green :bold t))
   ;; `(show-paren-mismatch (:background ,background :foreground ,spk-mint-oriange :bold t))
   ;; `(minibuffer-prompt (:weight bold :foreground ,foreground))
   ;; `(isearch (:background ,spk-mint-oriange :foreground ,foreground :bold t))
   ;; `(lazy-highlight (:background ,spk-mint-oriange :foreground ,foreground))
   `(link ((t (:underline t))))

   ;; font
   `(font-lock-builtin-face ((t (:foreground ,spk-mint-yellow))))
   `(font-lock-doc-face ((t (:foreground ,spk-mint-blue))))
   ;; constant没找到具体表现
   
   `(font-lock-constant-face ((t (:foreground ,spk-mint-darkblue))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,spk-mint-comment))))
   `(font-lock-comment-face ((t (:foreground ,spk-mint-comment))))
   `(font-lock-keyword-face ((t (:foreground ,spk-mint-pink))))
   `(font-lock-string-face ((t (:foreground ,spk-mint-violetred))))
   `(font-lock-function-name-face ((t (:foreground ,spk-mint-red))))

   `(font-lock-preprocessor-face ((t (:foreground ,spk-mint-darkblue :widget bold))))
   `(font-lock-negation-char-face ((t (:foreground ,spk-mint-bamboo))))
   `(font-lock-reference-face ((t (:foreground ,spk-mint-bamboo))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,spk-mint-bamboo))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,spk-mint-purple))))

   `(font-lock-type-face ((t (:foreground ,spk-mint-darkpurple :widget bold))))
   `(font-lock-variable-name-face ((t (:foreground ,spk-mint-fg :weight bold))))
   `(font-lock-warning-face ((t (:foreground ,spk-mint-oriange :background ,spk-mint-bg))))
   
   ;; linum 
   `(linum ((t (:background ,spk-mint-moon :foreground ,spk-mint-darkblue))))
   `(line-number ((t (:background ,spk-mint-moon :foreground ,spk-mint-darkblue))))
   `(line-number-current-line ((t (:inherit hl-line))))
   `(header-line ((t (:background ,spk-mint-lightblue))))

   ;; mode line 设置活动的modeline和不活动的modeline
   `(mode-line-inactive ((t
                          (:background "#F3F9F1"
                                       :box ,spk-mint-bamboo :inverse-video nil
                                       :foreground ,spk-mint-fg))))
   `(mode-line ((t
                 (:background ,spk-mint-bg
                              :box ,spk-mint-darkpurple :inverse-video nil
                              :foreground ,spk-mint-fg))))

   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,spk-mint-red))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,spk-mint-darkblue))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,spk-mint-green))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,spk-mint-yellow))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,spk-mint-purple))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,spk-mint-violetred))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,spk-mint-cyan))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,spk-mint-lightblue))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,spk-mint-bamboo))))
   `(rainbow-delimiters-depth-10-face ((t (:foreground ,spk-mint-blue))))
   `(rainbow-delimiters-depth-11-face ((t (:foreground ,spk-mint-pink))))
   `(rainbow-delimiters-depth-12-face ((t (:foreground ,spk-mint-oriange))))

   ;; org
   `(org-tag ((t
               (:foreground ,spk-mint-darkpurple :weight bold :background ,spk-mint-lightblue))))
   `(org-date ((t (:foreground ,spk-mint-bamboo :underline t))))
   `(org-link ((t (:foreground ,spk-mint-bamboo :underline t))))
   `(org-special-keyword ((t (:foreground ,spk-mint-pink))))
   ;; `(org-todo ((t (:foreground ,spk-mint-lightblue :background ,spk-mint-cyan))))
   `(org-todo ((t (:foreground ,spk-mint-lightblue :background "grey"))))
   `(org-done ((t (:foreground ,spk-mint-green))))
   `(org-hide ((t (:foreground ,spk-mint-bg :background ,spk-mint-bg))))

   ;; 设置不同等级标题的大小，有点问题
   `(org-level-1 ((t (:weight normal :foreground ,spk-mint-darkblue))))
   `(org-level-2 ((t (:weight normal :foreground ,spk-mint-darkgreen))))
   `(org-level-3 ((t (:weight normal :foreground ,spk-mint-red))))
   `(org-level-4 ((t (:weight normal :foreground ,spk-mint-violetred))))
   `(org-level-5 ((t (:weight normal :foreground ,spk-mint-yellow))))
   `(org-level-6 ((t (:weight normal :foreground ,spk-mint-blue))))
   `(org-level-7 ((t (:weight normal :foreground ,spk-mint-bamboo))))
   `(org-level-8 ((t (:weight normal :foreground ,spk-mint-darkgreen))))

   ;; magit设置，现在有些默认设置看不清字

   ;; company 设置
   `(company-echo-common ((t (:foreground ,spk-mint-bg :background ,spk-mint-fg))))
   ;; `(company-preview ((t (:foreground ,spk-mint-red :background ,spk-mint-moon))))
   `(company-tooltip ((t (:foreground ,spk-mint-red :background ,spk-mint-moon))))
   ;; `(company-tooltip-common ((t (:foreground ,spk-mint-red :background ,spk-mint-moon))))
   ;; 补全提示栏设置
   `(company-scrollbar-bg ((t (:background ,spk-mint-snow))))
   `(company-scrollbar-fg ((t (:foreground ,spk-mint-snow))))
   ;; `(company-tooltip-annotation ((t (:foreground ,spk-mint-red))))
   ;; `(company-tooltip-annotation-selection ((t (:foreground ,spk-mint-red))))

   `(company-tooltip-selection ((t (:background ,spk-mint-green))))
   ;; `(company-tooltip-search-selection ((t (:background ,spk-mint-red))))
   ;; `(company-tooltip-common-selection ((t (:background ,spk-mint-red))))
   ;; `(company-preview ((t (:background ,spk-mint-red))))
   ;; `(company-preview-common ((t (:background ,spk-mint-red))))
   ;; `(company-preview-search ((t (:background ,spk-mint-red))))
   ;; `(company-tooltip-search ((t (:background ,spk-mint-red))))
   `(company-tooltip-mouse ((t (:background ,spk-mint-skyblue))))
   ;; `(company-tooltip-common ((t (:background ,spk-mint-red))))
   
   ;; diff设置

   ;; dired设置
   `(dired-header ((t (:background ,spk-mint-green :foreground ,spk-mint-darkpurple))))
   `(dired-directory ((t (:foreground ,spk-mint-green))))
   `(dired-perm-write ((t (:foreground ,spk-mint-oriange))))
   `(dired-ignored ((t (:foreground ,spk-mint-lightblue))))
   ;; flyspell设置
   
   ;; cc-mode 设置
   ))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'spk-mint)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; spk-mint-theme.el ends here


