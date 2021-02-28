;;; ~/.doom.d/local/packages/my-find-file.el -*- lexical-binding: t; -*-
;; 编写一个查找文件的函数，这个函数文件用来查找文件
(require 'ivy)

(defun my-find-fie-in-project ()
  "Find file in DIRECTIRY."
  (let* ((cmd "find . -path \"*/.git\" -prune -o -print -type f -name \"*.*\"")
         (default-directory (locate-dominating-file default-directory ".\git"))
         (tcmd "fd \".*\\.png\" ~/tmp")
         (output (shell-command-to-string cmd))
         (lines (cdr (split-string output "[\n\r]+")))
         selecttd-line)
    (setq selecttd-line (ivy-read (format "Find file in %s:" default-directory)
                                  lines))
    (when (and selecttd-line (file-exists-p selecttd-line))
      (find-file selecttd-line))
    )
  )

;; find a file in project directory
(defun my-find-file ()
  (interactive)
  (let* ((cmd "find . -path \"*/.git\" -prune -o -print -type f -name \"*.*\"")
         (default-directory (locate-dominating-file default-directory ".\git"))
         (tcmd "fd \".*\\.png\" ~/tmp")
         (output (shell-command-to-string cmd))
         (lines (cdr (split-string output "[\n\r]+")))
         selecttd-line)
    (setq selecttd-line (ivy-read (format "Find file in %s:" default-directory)
                                  lines))
    (when (and selecttd-line (file-exists-p selecttd-line))
      (find-file selecttd-line))
    ))

;; default-directory 是绑定的在一个局部变量
;; 编写一个非交互函数，通过调用这个函数来扩展内容
