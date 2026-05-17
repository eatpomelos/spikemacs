;; -*- lexical-binding: t; -*-
(straight-use-package 'corfu)
(straight-use-package 'cape)

(setq corfu-auto t)
(setq corfu-cycle t)
(setq corfu-preview-current nil)
(setq corfu-on-exact-match nil)
(setq corfu-auto-delay 0.2)
(setq corfu-auto-prefix 1)
(setq corfu-min-width 25)
(setq corfu-max-width 100)
(setq corfu-quit-at-boundary 'separator)
(setq corfu-quit-no-match 'separator)

;; 全局激活 Corfu 弹窗前端
(global-corfu-mode)

(with-eval-after-load 'cape
  (setq cape-dabbrev-ignore-buffers "\\`[ *]\\|TAGS\\|tags")
  
  (add-to-list 'completion-at-point-functions #'cape-file)      ; 文件路径补全 (比如输入 ./ )
  (add-to-list 'completion-at-point-functions #'cape-keyword)   ; 编程语言关键字补全
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))  ; 全局文本乱猜 (替代原本 company-dabbrev)

(defun spk/setup-corfu-in-org-mode ()
  "强行激活 Org-mode 下的自动打字补全，并捕获 Org 的专属输入事件。"
  (setq-local corfu-auto t)
  (setq-local corfu-auto-commands '(self-insert-command org-self-insert-command))
  (setq-local completion-at-point-functions (list #'cape-dabbrev #'cape-file)))

;; 挂载到 org-mode-hook，让进入 org-mode 的时候自动执行
(add-hook 'org-mode-hook #'spk/setup-corfu-in-org-mode)

(provide 'init-corfu)
