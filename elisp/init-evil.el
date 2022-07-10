;; 配置 emacs 上的evil 相关的插件

(straight-use-package 'evil)
(straight-use-package 'evil-leader)
(straight-use-package 'evil-surround)
(straight-use-package 'evil-nerd-commenter)
(straight-use-package 'evil-smartparens)

(add-hook 'emacs-startup-hook #'evil-mode)

(with-eval-after-load 'evil
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  
  ;; (require 'evil-leader)
  (global-evil-leader-mode t)
  (evil-leader/set-leader "<SPC>")

  ;; evil leader keybinding，当加载evil的时候这些函数还没有加载，后续优化顺序
  (evil-leader/set-key
    "fj" 'dired-jump
    "fy" 'spk/yank-buffer-filename
    "fr" 'counsel-recentf
    "bd" 'kill-this-buffer
    "bb" 'counsel-switch-buffer
    "bs" 'spk-switch-to-scratch
    "TAB" 'evil-switch-to-windows-last-buffer
    "hk" 'describe-key
    "hv" 'describe-variable
    "hf" 'describe-function
    "hp" 'spk/find-repo-code
    "hb" 'describe-bindings
    "hi" 'info
    "hr" 'info-emacs-manual
    ;; "sp" 'counsel-rg
    )
  
  (evil-leader/set-key-for-mode
    'emacs-lisp-mode "sp" 'counsel-rg
    )
  ;; (require 'evil-surround)
  (global-evil-surround-mode 1)

  (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
  (with-eval-after-load 'evil-nerd-commenter
    (evil-leader/set-key
      ;; 下面的是官方文档中的快捷键设置，先注释掉，需要的时候开启想要的功能
      ;; "ci" 'evilnc-comment-or-uncomment-lines
      "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
      "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
      "cc" 'evilnc-copy-and-comment-lines
      "cp" 'evilnc-comment-or-uncomment-paragraphs
      ;; "cr" 'comment-or-uncomment-region
      ;; "cv" 'evilnc-toggle-invert-comment-line-by-line
      ;; "."  'evilnc-copy-and-comment-operator
      ;; "\\" 'evilnc-comment-operator	; if you prefer backslash key
      ))

  (straight-use-package 'which-key)
  
  ;; (require 'smartparens)
  ;; (require 'evil-smartparens)
  
  ;; (smartparens-global-mode t)
  ;; (evil-smartparens-mode t)

  ;; (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  ;; (sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)

  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
  )

(provide 'init-evil)
