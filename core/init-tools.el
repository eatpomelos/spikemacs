;; 配置自己使用的一些小工具，和之前的misc文件类似，这里主要配置一些比较使用的小插件类似tiny这种
(use-package tiny
  :ensure nil
  ;; :defer 2
  :config
  (bind-key* "M-." 'tiny-expand))

;; 安装lisp demos当需要使用一些内置函数时，用作参考
(use-package elisp-demos
  :defer 2
  :init
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1))

;; 设置延时启动，当调用相关函数的时候就会启动了，没有必要在加载的时候启动
(use-package highlight-symbol
  :defer t
  :init
  ;; 设置高亮symbol的快捷键，这里设置为source insight的f8
  (global-set-key (kbd "<f8>") 'highlight-symbol)
  (global-set-key (kbd "S-<f8>") 'highlight-symbol-prev)
  (global-set-key (kbd "S-<f9>") 'highlight-symbol-next)
  (global-set-key (kbd "<f1>") 'highlight-regexp)
  )

;; 设置有道词典进行翻译
(use-package youdao-dictionary
  :defer t
  :init
  (evil-leader/set-key
    "yo" 'youdao-dictionary-search-at-point+ 
    )
  )

;; 用来分析emacs启动速度，从而优化启动速度 
(use-package esup
  :ensure t
  :pin melpa
  :commands (esup)
  )

;; 快速选中的一些接口
(use-package expand-region
  :defer t
  :init
  (define-key evil-insert-state-map (kbd "C-\-") 'er/contract-region)
  (define-key evil-insert-state-map (kbd "C-=") 'er/expand-region)
  ;; org-binding
  (evil-leader/set-key
    "mop" 'er/mark-org-parent
    "moe" 'er/mark-org-element)
  )
;; 在浏览器中需要编辑的时候，使用emacs来进行编辑 
(use-package edit-server
  :ensure t
  :defer 5
  :config (edit-server-start))

(provide 'init-tools)
