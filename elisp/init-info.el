;; 不习惯默认的info-mode的绑定，这里手动配置一下info-mode中的一些快捷键，这样能够顺手一些  -*- lexical-binding: t; -*-
;; 使用 posframe 暂时实现一些简单的需求
(straight-use-package 'posframe)
(require 'posframe)

;; 使用 posframe 实现一个简单的弹窗来显示 info 模式下的快捷键，参考 posframe 提供的 demo
(defvar spk-info-mode-pos-buf " *spk-info-posframe-buffer*")

(defadvice Info-mode (after spk-info-hack activate)
  (when (file-exists-p (expand-file-name "info.txt" (concat spk-local-code-dir "posframe")))
    (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
      (erase-buffer)
      (insert-file-contents (expand-file-name "info.txt" (concat spk-local-code-dir "posframe")))))
  )

;; 增加一个函数用于显示临时内容
(defun spk/set-pos-buf-ctx ()
  "set current marked text to posfram buffer."
  (interactive)
  (let* ((buf-ctx (buffer-substring (region-beginning) (region-end))))
    (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
      (erase-buffer)
      (insert buf-ctx)
      ))
  )

;; 在 Info 模式下提供一个快速查看快捷键的函数   
(defun spk/bulletin-peek ()
  "Info help peek."
  (interactive)
  (when (posframe-workable-p) 
    (posframe-show spk-info-mode-pos-buf
                   :background-color (face-background 'default nil t)
                   :foreground-color (face-foreground 'font-lock-string-face nil t)
                   :internal-border-width 1
                   :internal-border-color "red"
                   :position (point))
    (unwind-protect
        (sit-for 10)
      (posframe-hide spk-info-mode-pos-buf))
    )
  )

(global-set-key (kbd "C-c h") #'spk/bulletin-peek)

;; 在windows上找不到 manual 节点，手动将emacs doc的位置添加到info-directory-list里面去
(when IS-WINDOWS
  (add-to-list 'Info-directory-list
	           "d:/HOME/spike/spk-shareFile/emacs-30.2/info")
  (add-to-list 'Info-additional-directory-list
               (concat spk-doc-dir "Code/elisp/Elisp_manual/info"))
  )

(provide 'init-info)
