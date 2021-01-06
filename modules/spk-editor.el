;; 用来管理和编辑相关的配置
;; tiny定义了一种语法，可以批量生成格式化的文本，但是对于一些转义符的支持不是很友好
(use-package tiny
  :ensure nil
  :defer 2
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
    "ys" 'youdao-dictionary-search-from-input
    "yp" 'youdao-dictionary-play-voice-at-point
    )
  (add-hook 'youdao-dictionary-mode-hook #'evil-insert-state)
  )

;; 用来分析emacs启动速度，从而优化启动速度 
;; (use-package esup
;;   :ensure t
;;   :pin melpa
;;   :commands (esup)
;;   )

;; 这个插件的作用是：当你打开一个其他窗口是，光标会跳转到对应的窗口上去
(use-package popwin
  :defer 3
  :init
  (popwin-mode t))

;; 快速选中的一些接口
(use-package expand-region
  :defer 5
  :init
(bind-key* "C-=" 'er/expand-region)
(bind-key* "C-\-" 'er/contract-region)
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

;; 下载json-mode来编写json文件，暂时不需要额外的配置，后面可能会需要优化快捷键
(use-package json-mode
  :defer 3)

;; 使用拼音缩写来进行跳转
(use-package ace-pinyin
  :defer 5
  :init (global-set-key (kbd "C-c C-/") 'ace-pinyin-jump-char-2)
  (ace-pinyin-global-mode t))

;; aspell 拼写检查，后续分类
(setq ispell-program-name "aspell")

(setq company-ispell-dictionary
      (expand-file-name (concat spk-local-dir "english-words.txt"))
      ispell-complete-word-dict
      (expand-file-name (concat spk-local-dir "english-words.txt")))

;; 设置单词补全，放到后面
(setq company-backends
      '(company-bbdb company-semantic company-cmake company-capf company-clang company-files company-ispell
		      (company-dabbrev-code company-gtags company-etags company-keywords)
		      company-oddmuse company-dabbrev))
;; company-backends

;; (setq demo (list 1 2 3 4 5))
;; (push 6 demo)

(provide 'spk-editor)
