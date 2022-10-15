;; 和编辑相关的一些插件的配置
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)
(straight-use-package 'json-mode)
;; (straight-use-package 'sis)

;; 将此库文件更新为fork版本
(straight-use-package
 '(symbol-overlay
   :type git
   :host github
   :repo "eatpomelos/symbol-overlay"
   )
 )
;; TODO 需要注意的是下面的相关配置会导致org-mode使用latex导出pdf时失败，暂时屏蔽以下配置，后续优化
;; 下面的是为了解决之前输入中文卡顿的原因，同时也解决了一些字显示的问题。
;; (set-language-environment 'utf-8)
;; (set-locale-environment "utf-8")

;; 设置编码终端解决乱码问题，待测试
;; (set-terminal-coding-system 'utf-8)
;; (modify-coding-system-alist 'process "*" 'utf-8)
;; (setq default-process-coding-system '(utf-8 . utf-8))

;; 考虑要不要加这个配置
(straight-use-package 'undo-tree)
(add-hook 'emacs-startup-hook #'global-undo-tree-mode)

;; 在org-mode中打开自动折行功能，避免一行过长
(add-hook 'org-mode-hook #'auto-fill-mode)
(setq-default fill-column 90)

;; 怎么在不添加新的package的情况下覆盖绑定?
(with-eval-after-load  'undo-tree
  (global-set-key (kbd "C-r") #'undo-tree-redo)
  (define-key evil-normal-state-map (kbd "C-r") #'undo-tree-redo)
  (global-set-key (kbd "C-/") #'undo-tree-undo)
  (setq undo-tree-auto-save-history nil)
  )

;; 指定github上的包，并下载，由于当前的环境配置中 linux下的环境没有界面因此使用此package会导致emacs卡死
(straight-use-package
 '(company-english-helper :type git
			              :host github
			              :repo "manateelazycat/company-english-helper"))
;; 指定一个函数从文件中自动加载，暂时理解成指定一个函数为autoload，当使用这个函数时自动加载那个文件
(global-set-key (kbd "<f1>") 'toggle-company-english-helper)

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

(global-set-key (kbd "C-c v") 'set-mark-command)
(global-set-key (kbd "C-c l") 'avy-goto-line)
;; 在minibuff中输入的时候由于焦点的变化导致光标无法回到minibuffer的输入框，且无法用C-g来解决
(global-set-key (kbd "C-c C-g") 'exit-minibuffer)
(global-set-key (kbd "C-<down>") 'text-scale-decrease)
(global-set-key (kbd "C-<up>") 'text-scale-increase)

(with-eval-after-load 'expand-region
  ;; 标记整个函数的时候，打印这个函数的行数
  ;; (save-restriction) 函数是在执行之后恢复原来的buffer状态，包括变窄的状态等
  (advice-add
   'er/mark-defun
   :before #'(lambda ()
			   (save-excursion
				 (let* ((ed-line 0)
						(st-line 0))
				   (beginning-of-defun)
				   (setq st-line (line-number-at-pos))
				   (end-of-defun)
				   (setq ed-line (line-number-at-pos))
				   (message "function lines:%d" (1+ (- ed-line st-line)))
				   )
				 )))

  (evil-leader/set-key
    "mop" 'er/mark-org-parent
    "moe" 'er/mark-org-element
    "ms" 'er/mark-symbol
    "m\]" 'er/mark-sentence))


(global-set-key (kbd "<f8>") 'symbol-overlay-put)
(global-set-key (kbd "S-<f8>") 'symbol-overlay-jump-prev)
(global-set-key (kbd "S-<f9>") 'symbol-overlay-jump-next)

(global-set-key (kbd "C-'") 'symbol-overlay-put)
(global-set-key (kbd "C-<") 'symbol-overlay-jump-prev)
(global-set-key (kbd "C->") 'symbol-overlay-jump-next)


;; 设置英语检错，设置有问题，暂时未解决
(when IS-WINDOWS
  (setq ispell-program-name "aspell")
  (setq ispell-process-directory "~/MSYS2/mingw64/bin/")
  )

;; 由于高亮显示占用了evil的快捷键，且暂时不使用其自定义的快捷键，禁用symbol-overlay-mode
(with-eval-after-load 'symbol-overlay
  (setq symbol-overlay-inhibit-map t)
  ;; 默认的8个face不够用，这里增加到20个
  (defface symbol-overlay-face-9
    '((t (:background "SystemHilight" :foreground "black")))
    "Symbol Overlay default candidate 9"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-10
    '((t (:background "dark red" :foreground "black")))
    "Symbol Overlay default candidate 10"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-11
    '((t (:background "HotPink4" :foreground "black")))
    "Symbol Overlay default candidate 11"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-12
    '((t (:background "medium aquamarine" :foreground "black")))
    "Symbol Overlay default candidate 12"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-13
    '((t (:background "dim gray" :foreground "black")))
    "Symbol Overlay default candidate 13"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-14
    '((t (:background "khaki4" :foreground "black")))
    "Symbol Overlay default candidate 14"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-15
    '((t (:background "SkyBlue4" :foreground "black")))
    "Symbol Overlay default candidate 15"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-16
    '((t (:background "deep pink" :foreground "black")))
    "Symbol Overlay default candidate 16"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-17
    '((t (:background "cyan" :foreground "black")))
    "Symbol Overlay default candidate 17"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-18
    '((t (:background "peru" :foreground "black")))
    "Symbol Overlay default candidate 18"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-19
    '((t (:background "tomato" :foreground "black")))
    "Symbol Overlay default candidate 19"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-20
    '((t (:background "RoyalBlue1" :foreground "black")))
    "Symbol Overlay default candidate 20"
    :group 'symbol-overlay)

  ;; m1\n20|symbol-overlay-face-%d ，对于这种累加的变量，可以使用tiny-expand功能
  (setq symbol-overlay-faces
        '(symbol-overlay-face-1
          symbol-overlay-face-2
          symbol-overlay-face-3
          symbol-overlay-face-4
          symbol-overlay-face-5
          symbol-overlay-face-6
          symbol-overlay-face-7
          symbol-overlay-face-8
          symbol-overlay-face-9
          symbol-overlay-face-10
          symbol-overlay-face-11
          symbol-overlay-face-12
          symbol-overlay-face-13
          symbol-overlay-face-14
          symbol-overlay-face-15
          symbol-overlay-face-16
          symbol-overlay-face-17
          symbol-overlay-face-18
          symbol-overlay-face-19
          symbol-overlay-face-20
          ))
  )

;; bookmarks
(evil-leader/set-key
  "bm" 'bookmark-set
  "bl" 'bookmark-bmenu-list
  "rs" 'restart-emacs
  "rn" 'restart-emacs-start-new-emacs
  "nr" 'narrow-to-region
  "nw" 'widen
  "b \RET" 'counsel-bookmark
  "sy" 'symbol-overlay-save-symbol
  "si" 'spk/search-symbol-from-input
  "ss" 'spk/search-symbol-at-point
  )

;; ediff 配置
(setq-default ediff-split-window-function 'split-window-horizontally)

(global-set-key (kbd "<f5>") 'abbrev-mode)

;; 添加鼠标相关的配置，解决滚轮滑动屏幕过快的问题 
(setq mouse-scroll-delay 0.02)
(defun up-slightly () (interactive) (scroll-up 1))
(defun down-slightly () (interactive) (scroll-down 1))
(global-set-key [wheel-up] 'down-slightly)
(global-set-key [wheel-down] 'up-slightly)

;; 设置最近文件的最大条目数
(setq recentf-max-saved-items 1000)

;; 设置info-mode中的一些快捷键
(define-key Info-mode-map "v" 'evil-visual-char)

(provide 'init-editor)
