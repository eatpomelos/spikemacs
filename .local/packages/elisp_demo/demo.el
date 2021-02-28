;; 用来学习陈斌的lisp教程
(require 'ivy)

(defun my-find-file ()
  (interactive)
  ;; -type f 表示要搜索的是文件而不是其他功能
  (let* ((cmd "find . -type f -name \"*.*\"")
	 (output (shell-command-to-string cmd))
	 (lines (split-string output "[\n]+"))
	 selected-line)
    (setq selected-line (ivy-read "find-file:" lines))
    (when (and selected-line (file-exists-p selected-line))
      (find-file selected-line))
    ))

;; 在使用find-file 的时候 可以使用!来过滤相应的文件

;; 使用find 排除相应的目录
;; find . -path ./src/emacs -prune -o -print
