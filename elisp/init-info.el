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

;; 在 Info 模式下提供一个快速查看快捷键的函数   
(defun spk/info-help-peek ()
  "Info help peek."
  (interactive)
  (when (posframe-workable-p) 
    (posframe-show spk-info-mode-pos-buf
                   :background-color (face-background 'default nil t)
                   :foreground-color (face-foreground 'font-lock-string-face nil t)
                   :internal-border-width 1
                   :internal-border-color "red"
                   :position (point))
    (sit-for 10)
    (posframe-hide spk-info-mode-pos-buf)
    )
  )

(with-eval-after-load 'info
  (define-key Info-mode-map (kbd "<f1>") #'spk/info-help-peek)
  ;; 在 Info-mode 下进入 emacs-state，便于直接使用 Info-mode 中的快捷键
  (evil-set-initial-state 'Info-mode 'emacs)

  ;; 定义vim中的移动模式，这里上下左右快捷键设置一下，和之前的冲突则找一下替代方法
  (define-key Info-mode-map "h" 'backward-char)
  (define-key Info-mode-map "j" 'next-line)
  (define-key Info-mode-map "k" 'previous-line)
  (define-key Info-mode-map "l" 'forward-char)
  (define-key Info-mode-map "L" 'Info-forward-node)
  (define-key Info-mode-map "H" 'Info-backward-node)
  (define-key Info-mode-map "r" 'Info-history-back)
  (define-key Info-mode-map "R" 'Info-history-forward)
  (define-key Info-mode-map "\\" 'Info-history)
  (define-key Info-mode-map (kbd "C-c h") 'Info-help)
  (define-key Info-mode-map "R" 'Info-history-back)
  )
;; 在windows上找不到 manual 节点，手动将emacs doc的位置添加到info-directory-list里面去
(when IS-WINDOWS
  (add-to-list 'Info-directory-list
	           "d:/HOME/spike/code/emacs-27.1/emacs-27.1/info")
  (add-to-list 'Info-additional-directory-list
             "d:/HOME/.emacs.d/docs/Code/elisp/Elisp_manual/info")
  )

(provide 'init-info)
