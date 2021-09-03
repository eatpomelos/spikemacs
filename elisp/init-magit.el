;; magit相关配置

(straight-use-package 'magit)
(straight-use-package 'vc-msg)

;; 下面的advice定义表示的是执行完magit-status 函数之后，切换evil模式到insert模式
(advice-add 'magit-status :after #'evil-insert-state)

(evil-leader/set-key
  "gs" 'magit-status
  "gb" 'magit-blame-addition
  "gq" 'magit-blame-quit
  "gm" 'vc-msg-show
  "gl" 'magit-log-all)

(with-eval-after-load 'magit
  ;; 设置magit 快捷键，适配evil的操作方式来进行设置
  (define-key magit-log-mode-map "h" #'backward-char)
  (define-key magit-log-mode-map "j" #'magit-section-forward)
  (define-key magit-log-mode-map "k" #'magit-section-backward)
  (define-key magit-log-mode-map "l" #'forward-char)
  )

(provide 'init-magit)
