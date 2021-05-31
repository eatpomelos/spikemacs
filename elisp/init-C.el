;; 和C语言相关的配置
(setq c-default-style "linux"
      c-basic-offset 4)

;; 用于生成产品端的ctags命令
(defconst spk-ctags-base-command-for-c "ctags -e -R --exclude=targes --exclude=vendor --exclude=bsp/kernel/kpatch"
  "Ctags command for C.")

(setq spk-linux-code-dir "d:/work/linux_code")

;; 检测if 0 并用注释的face来显示这段内容
;; highlight c
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start (match-beginning 0) 'font-lock-comment-face)
              (setq start nil))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)

(defun my-c-mode-common-hook-if0 ()
  (font-lock-add-keywords
   nil
   '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end))

;; 在进入c-mode 的时候将indent-tabs-mode 关掉，并打开whitespace-mode 
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook-if0)
;; (add-hook 'c-mode-common-hook #'whitespace-mode)
(setq indent-tabs-mode nil)

;;;###autoload
(defun spk-disable-electric-pair-mode ()
  "Disable `electric-pair-mode'."
  (electric-pair-mode -1))

;; (add-hook 'c-mode-hook 'spk-disable-electric-pair-mode)
;; (add-hook 'c-mode-hook 'ctags-auto-update-mode)

(provide 'init-C)
