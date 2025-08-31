;; 和编辑相关的一些插件的配置  -*- lexical-binding: t; -*-
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)
(straight-use-package 'json-mode)
(straight-use-package 'sis)
(straight-use-package 'pangu-spacing)
(straight-use-package 'orderless)
(straight-use-package 'vterm)

;; 使用xclip解决在wsl的终端无法共享剪切板的问题
(straight-use-package 'xclip)

(setq completion-styles '(orderless))

;; 将此库文件更新为 fork 版本
(straight-use-package
 '(symbol-overlay
   :type git
   :host github
   :repo "eatpomelos/symbol-overlay"
   )
 )

(require 'xclip)
(xclip-mode t)

;; 打开版本控制的文件时不询问
(setq vc-follow-symlinks t)

;; 参考自：https://emacs-china.org/t/topic/25811/7
(setq-default bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(if IS-WINDOWS
    ;; windows 上 sis 设置
    (sis-ism-lazyman-config nil t 'w32)
  ;; linux上使用fcitx5，这里需要多设置一个英文输入法，这里的1是安装的rime
  (sis-ism-lazyman-config "2" "1" 'fcitx5)
  )

;; enable the /cursor color/ mode
(sis-global-cursor-color-mode t)
;; enable the /respect/ mode
(sis-global-respect-mode t)
;; enable the /context/ mode for all buffers
(sis-global-context-mode t)
;; enable the /inline english/ mode for all buffers
(sis-global-inline-mode t)


;; 需要注意的是下面的相关配置会导致 org-mode 使用 latex 导出 pdf 时失败，暂时屏蔽以下配置，后续优化
;; 下面的是为了解决之前输入中文卡顿的原因，同时也解决了一些字显示的问题。
(when IS-LINUX
  (set-language-environment 'utf-8)
  (set-locale-environment "utf-8")
  (set-terminal-coding-system 'utf-8)
  (modify-coding-system-alist 'process "*" 'utf-8)
  (setq default-process-coding-system '(utf-8 . utf-8))

  ;; 配置 selectrum 
  (straight-use-package 'selectrum)
  (selectrum-mode +1))

;; 在 org-mode 中打开自动折行功能，避免一行过长
(add-hook 'org-mode-hook #'auto-fill-mode)
(setq-default fill-column 90)

(global-set-key (kbd "C-r") #'undo-redo)
(global-set-key (kbd "C-/") #'undo)

;; 指定 github 上的包，并下载，由于当前的环境配置中 linux 下的环境没有界面因此使用此 package 会导致 emacs 卡死
(straight-use-package
 '(company-english-helper :type git
			              :host github
			              :repo "manateelazycat/company-english-helper"))
;; 指定一个函数从文件中自动加载，暂时理解成指定一个函数为 autoload，当使用这个函数时自动加载那个文件

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

(global-set-key (kbd "C-c v") 'set-mark-command)
(global-set-key (kbd "C-c l") 'avy-goto-line)
;; 在 minibuff 中输入的时候由于焦点的变化导致光标无法回到 minibuffer 的输入框，且无法用 C-g 来解决
(global-set-key (kbd "C-c C-g") 'exit-minibuffer)
(global-set-key (kbd "C-<down>") 'text-scale-decrease)
(global-set-key (kbd "C-<up>") 'text-scale-increase)

(with-eval-after-load 'expand-region
  ;; 标记整个函数的时候，打印这个函数的行数
  ;; (save-restriction) 函数是在执行之后恢复原来的 buffer 状态，包括变窄的状态等
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


(when (is-gui)
  (global-set-key (kbd "C-\'") 'symbol-overlay-put)
  (global-set-key (kbd "C-\"") 'symbol-overlay-rename)
  (global-set-key (kbd "C-:") 'symbol-overlay-jump-prev)
  (global-set-key (kbd "C-;") 'symbol-overlay-jump-next))

;; ;; 设置英语检错，设置有问题，暂时未解决
(when IS-WINDOWS
  (setq ispell-program-name "aspell")
  (setq ispell-process-directory "~/MSYS2/mingw64/bin/")
  )

;; 由于高亮显示占用了 evil 的快捷键，且暂时不使用其自定义的快捷键，禁用 symbol-overlay-mode
(with-eval-after-load 'symbol-overlay
  (setq symbol-overlay-inhibit-map t)
  ;; 默认的 8 个 face 不够用，这里增加到 20 个
  (defface symbol-overlay-face-9
    '((t (:background "DarkOrchid4" :foreground "black")))
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

  ;; m1\n20|symbol-overlay-face-%d ，对于这种累加的变量，可以使用 tiny-expand 功能
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
  )

;; 修改书签后自动保存
(setq bookmark-save-flag t)
;; 显示文件大小
(size-indication-mode t)

;; ediff 配置
(setq-default ediff-split-window-function 'split-window-horizontally)

;; 添加鼠标相关的配置，解决滚轮滑动屏幕过快的问题 
(when EMACS29-
  (setq mouse-scroll-delay 0.02)
  (defun up-slightly () (interactive) (scroll-up 1))
  (defun down-slightly () (interactive) (scroll-down 1))
  (global-set-key [wheel-up] 'down-slightly)
  (global-set-key [wheel-down] 'up-slightly))

(when EMACS29+
  (pixel-scroll-precision-mode t))

(evil-set-initial-state 'profiler-report-mode 'emacs)
(evil-set-initial-state 'edebug-mode 'emacs)

;; 设置最近文件的最大条目数
(setq recentf-max-saved-items 1000)
;; 设置不清空recentf，避免卡顿
(setq recentf-auto-cleanup 'never)

;; 这个包用于自动在中英文间插入空格
(require 'pangu-spacing)
;; 在中英文之间真的插入一个空格，而不是仅显示一个空格，方便在编程中智能删除中英文
(setq pangu-spacing-real-insert-separtor nil)
(global-pangu-spacing-mode 1)

(add-hook 'org-mode-hook
          #'(lambda ()
             (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)))

(provide 'init-editor)
