;; 用来管理和编程相关的配置
;; C编程设置
(setq c-default-style "linux"
      c-basic-offset 4)

;; 设置lispy作为扩展emacs的编辑环境
(use-package lispy
  :ensure t
  :defer 3
  :config
  (add-hook 'emacs-lisp-mode-hook 'lispy-mode)
  (define-key lispy-mode-map (kbd "M-;") 'lispy-comment)
  )

;; 当在编程语言的mode下开启此模式，显示前面的空格
(use-package highlight-indent-guides
  ;; :url https://github.com/DarthFennec/highlight-indent-guides
  :defer t
  :init
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))


;; 暂时用这种比较笨的做法
(defun spk-disable-electric-pair-mode ()
  "Disable `electric-pair-mode'."
  (electric-pair-mode -1))

(add-hook 'c-mode-hook 'spk-disable-electric-pair-mode)

(use-package yasnippet
  :defer 3 
  :init
  (setq yas-snippets-dirs (concat spk-dir "snippets/"))
  (setq yas--loaddir (concat spk-dir "snippets"))
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config
  (global-set-key (kbd "<f5>") #'company-yasnippet)
  (yas-compile-directory yas-snippets-dirs)
  (yas-reload-all)
  )
;; 定义编程快捷键

;; (define-key c-mode-map (kbd "DEL") #'c-hungry-delete)

;; 显示空白字符，在检查代码的时候可能有用，暂时不开启
(use-package whitespace
  :defer t
  ;; :hook (c-mode . whitespace-mode)
  )

;; 设置vc-msg 来显示git的提交信息
(use-package vc-msg
  :defer t
  :init
  (evil-leader/set-key
    "gm" 'vc-msg-show))

(provide 'spk-prog)
