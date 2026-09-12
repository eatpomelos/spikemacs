;; 配置 emacs 上的evil 相关的插件  -*- lexical-binding: t; -*-

;; 必须在 evil 加载之前设置，否则 evil 会注册默认键绑定，
;; 与 evil-collection 冲突导致部分功能失效。
;; straight.el 更新后 (straight-use-package 'evil) 会立即加载 evil，
;; 所以这行必须放在所有 straight-use-package 之前。
(setq evil-want-keybinding nil)

(straight-use-package 'evil)
(straight-use-package 'evil-leader)
(straight-use-package 'evil-surround)
(straight-use-package 'evil-nerd-commenter)
(straight-use-package 'evil-smartparens)
(straight-use-package 'evil-goggles)
(straight-use-package 'evil-collection)
(straight-use-package 'key-chord)

;; 在启用 global-evil-leader-mode 之前先设置 leader 键
;; 直接设置变量，避免 evil-leader/set-leader 在 evil 未完全初始化时调用报错
(setq evil-leader/leader "<SPC>")

;; 必须在 (evil-mode 1) 之前启用，否则初始 buffer（*scratch*, *Messages* 等）
;; 不会启用 evil-leader-mode，导致 leader 键失效。
;; 参见 evil-leader.el 注释：
;; "You should enable `global-evil-leader-mode' before you enable `evil-mode'"
(global-evil-leader-mode t)

(evil-mode 1)

(with-eval-after-load 'evil
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  
  ;; evil leader keybinding，当加载evil的时候这些函数还没有加载，后续优化顺序
  (evil-leader/set-key
    "fj" 'dired-jump
    "fy" 'spk/yank-buffer-filename
    "fr" 'consult-recent-file
    "bd" 'kill-current-buffer
    "bb" 'consult-buffer
    "bs" 'spk/switch-to-scratch
    "TAB" 'evil-switch-to-windows-last-buffer
    "hp" 'spk/find-repo-code
    "hb" 'describe-bindings
    "hi" 'info
    "hk" 'describe-key
    "hv" 'describe-variable
    "hav" 'apropos-variable
    "haf" 'apropos-function
    "haa" 'apropos-command
    "had" 'apropos-documentation
    "hf" 'describe-function
    "hr" 'info-emacs-manual
    )
  
  ;; (require 'evil-surround)
  (global-evil-surround-mode 1)
  
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces)
  
  (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
  (with-eval-after-load 'evil-nerd-commenter
    (evil-leader/set-key
      ;; 下面的是官方文档中的快捷键设置，先注释掉，需要的时候开启想要的功能
      "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
      "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
      "cc" 'evilnc-copy-and-comment-lines
      "cp" 'evilnc-comment-or-uncomment-paragraphs
      ))

  (straight-use-package 'which-key)
  
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
  
  ;; 使用 key-chord-mode 来实现键映射延迟功能
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.08)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

  ;; 开启evil-collection 模式，给大多数模式提供默认配置
  (evil-collection-init '(calendar dired calc ediff info magit imenu imenu-list xref man neotree vundo eww))
  )

(provide 'init-evil)
