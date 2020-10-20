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
  (global-set-key (kbd "<f7>") 'highlight-symbol-query-replace)
  )

;; 设置有道词典进行翻译
(use-package youdao-dictionary
  :defer t
  :init
  (evil-leader/set-key
    "yo" 'youdao-dictionary-search-at-point+ 
    )
  )


;; 用来存放自己的一些临时的测试函数
(defun spk-func1 ()
  (interactive)
  (load-theme 'dracula))

(defun spk-func2 ()
  (interactive)
  (load-theme 'spk-mint))

(global-set-key (kbd "<f3>") 'spk-func1)
(global-set-key (kbd "<f5>") 'spk-func2)

;; 在自己的配置文件路径中查找文件
(defun spk-find-local-conf ()
  "Find local config in the local path."
  (interactive)
  (counsel-find-file (concat spikemacs-dir "lisp/")))

;; 打开电脑上的其他emacs配置
(defun spk-find-emacs-confs ()
  "Find another emacs config file."
  (interactive)
  (let* ((emacs-conf-dir nil))
    (setq emacs-conf-dir
	  (cond (IS-WINDOWS "d:/HOME/configs")
		(IS-LINUX "~/emacs-config")))
    (counsel-find-file emacs-conf-dir)))

;; 使用懒猫大佬的snails 暂时体会不到使用的提升，暂时不添加进来
;; (add-to-list 'load-path "~/.emacs.d/.local/packages/snails/")
;; (require 'snails)

;; ;; 当调用snails的时候，自动进入evil-insert-state
;; (defadvice snails (after spk-snails-hack activate)
;;   (evil-insert-state))

(provide 'init-tools)
