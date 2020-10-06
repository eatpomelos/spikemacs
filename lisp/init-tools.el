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
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
  )
(provide 'init-tools)
