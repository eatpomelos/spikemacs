;; 配置 emacs 上的evil 相关的插件  -*- lexical-binding: t; -*-

(straight-use-package 'evil)
(straight-use-package 'evil-leader)
(straight-use-package 'evil-surround)
(straight-use-package 'evil-nerd-commenter)
(straight-use-package 'evil-smartparens)
(straight-use-package 'evil-goggles)
(straight-use-package 'evil-collection)
(straight-use-package 'key-chord)

;; See https://github.com/emacs-evil/evil-collection/issues/60 
(setq evil-want-keybinding nil)
(evil-mode 1)

(with-eval-after-load 'evil
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  
  ;; See https://github.com/emacs-evil/evil-collection/issues/60 
  (setq evil-want-keybinding nil)
  (global-evil-leader-mode t)
  (evil-leader/set-leader "<SPC>")

  ;; evil leader keybinding，当加载evil的时候这些函数还没有加载，后续优化顺序
  (evil-leader/set-key
    "fj" 'dired-jump
    "fy" 'spk/yank-buffer-filename
    "fr" 'counsel-recentf
    "bd" 'kill-current-buffer
    "bb" 'counsel-switch-buffer
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
    ;; "sp" 'counsel-rg
    )
  
  (evil-leader/set-key-for-mode
    'emacs-lisp-mode "sp" 'counsel-rg
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
  (evil-collection-init '(calendar dired calc ediff info magit imenu imenu-list xref man neotree))
  )

(provide 'init-evil)
