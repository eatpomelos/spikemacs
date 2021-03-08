
(straight-use-package 'magit)
(straight-use-package 'vc-msg)

;; 下面的advice定义表示的是执行完magit-status 函数之后，切换evil模式到insert模式
(advice-add 'magit-status :after #'evil-insert-state)

(evil-leader/set-key
  "gs" 'magit-status
  "gb" 'magit-blame-addition
  "gq" 'magit-blame-quit
  "gm" 'vc-msg-show)

(provide 'init-magit)
