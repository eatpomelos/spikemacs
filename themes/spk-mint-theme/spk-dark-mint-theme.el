;; 此代码原始来自dark-mint-theme,新增了一些face设置
;;; Code:
(deftheme spk-dark-mint
  "spk-dark-mint-theme")

(custom-theme-set-faces
 'spk-dark-mint
 
 '(default ((t (:background "black" :foreground "green"))))
 '(mouse ((t (:foregound "#000000"))))
 '(fringe ((t (:background "black" :foreground "green"))))
 '(cursor ((t (:foregound "#000000"))))
 '(border ((t (:foregound "black"))))


 '(mode-line ((t (:background "black" :foreground "green"))))
 '(mode-line-inactive ((t (:background "black" :foreground "cyan"))))
 '(Man-overstrike-face ((t (:weight bold))))
 '(Man-underline-face ((t (:underline t))))
 '(apropos-keybinding-face ((t (:underline t))))
 '(apropos-label-face ((t (:italic t))))

 '(font-lock-type-face ((t (:foreground "light slate blue"))))
 ;; '(font-lock-comment-face ((t (:foreground "MintCream"))))
 '(font-lock-comment-face ((t (:foreground "#A6B4B9"))))
 '(font-lock-function-name-face ((t (:foreground "VioletRed2"))))
 '(font-lock-keyword-face ((t (:weight bold :foreground "cyan"))))
 '(font-lock-string-face ((t (:foreground "deep pink"))))
 '(font-lock-variable-name-face ((t (:foreground "MediumPurple1"))))

 '(region ((t (:background "MediumOrchid4"))))
 '(secondary-selection ((t (:background "dodger blue"))))

 ;; whitespace
 '(whitespace-indentation ((t (:inherit whitespace-space))))

 ;; ;; linum
 '(linum ((t (:background "black" :foregound "blue"))))
 ;; '(line-number ((t (:inherit linum))))
 ;; '(header-line ((t (:background "#B4CDCD"))))

 ;; company
 '(company-tooltip ((t (:foreground "#F0FCFF" :background "#28223e"))))
 '(company-scrollbar-bg ((t (:background "#28223e"))))
 '(company-scrollbar-fg ((t (:foreground "#F0FCFF"))))
 ;; '(company-tooltip-selection ((t (:background "#333469"))))
 
 '(mouse ((t (:foregound "wheat"))))
 '(highlight ((t (:background "blue" :foreground "orange"))))
 '(show-paren-match-face ((t (:background "turquoise" :foreground "coral"))))
 '(show-paren-mismatch-face ((t (:background "purple" :foreground "white"))))
 '(cursor ((t (:background "Deep Pink")))))

 '(linum ((t (:background "black" :foreground "green"))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'spk-dark-mint)
;;; dark-mint-theme.el ends here
