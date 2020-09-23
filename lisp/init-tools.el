;; 配置自己使用的一些小工具，和之前的misc文件类似，这里主要配置一些比较使用的小插件类似tiny这种
(use-package tiny
  :ensure nil
  ;; :defer 2
  :config
  (bind-key* "M-." 'tiny-expand))

(provide 'init-tools)
