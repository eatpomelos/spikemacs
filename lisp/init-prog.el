;; 设置各种编程相关的设置

;; C编程设置
(setq c-default-style "linux"
      c-basic-offset 4)

;; 暂时用这种比较笨的做法
(defun spk-disable-electric-pair-mode ()
  "Disable `electric-pair-mode'."
  (electric-pair-mode -1))

(add-hook 'c-mode-hook 'spk-disable-electric-pair-mode)

;; 定义编程快捷键

;; (define-key c-mode-map (kbd "DEL") #'c-hungry-delete)

(provide 'init-prog)
