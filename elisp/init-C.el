;; 和C语言相关的配置
(defconst spk-c-identifier-regex "[a-zA-Z_]?[a-zA-Z0-9_]+"
  "C identifier regular expression.")

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "linux")))
(setq c-basic-offset 4)

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

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook-if0)
(setq indent-tabs-mode nil)

;;;###autoload
(defun spk-disable-electric-pair-mode ()
  "Disable `electric-pair-mode'."
  (electric-pair-mode -1))

;; 经过测试company-ctags比company-etags使用体验要好不少，这里使用ctags来进行补全，避免在大型项目中造成严重卡顿
;;;###autoload
(defun spk/cc-mode-setup ()
  (when (boundp 'company-backends)
	(make-local-variable 'company-backends)
	(setq company-backends '((company-keywords company-ctags company-yasnippet company-capf company-cmake company-dabbrev company-dabbrev-code))))
  ;; 默认 在linux 下 C-mode 使用 lsp-bridge 来进行补全
  (when IS-LINUX
    (company-box-mode -1))

  ;; 在C-mode中deadgrep基于当前路径进行搜索
  (require 'deadgrep)
  (when (boundp 'deadgrep-project-root-function)
    (make-local-variable 'deadgrep-project-root-function)
    (setq deadgrep-project-root-function 'spk/deadgrep-search-default-dir))

  ;; 在进入C-mode的时候如果在根目录中发现了compile_command.json 文件则使用lsp-bridge的快捷键
  (when (and (+spk-get-complete-file "compile_commands.json") IS-LINUX)
    (evil-define-key* 'normal c-mode-map "gd" #'lsp-bridge-find-def)
    (evil-define-key* 'normal c-mode-map "gr" #'lsp-bridge-find-references)
    )
  )

(add-hook 'c-mode-hook #'spk/cc-mode-setup)
(add-hook 'c-mode-hook #'hs-minor-mode)

;;;###autoload
(defun spk-get-c-defun-name ()
  (when (eq major-mode 'c-mode)
    (save-excursion
      (let* ((def-s nil))
        (beginning-of-defun)
        (when (ignore-errors (re-search-forward "[a-zA-Z_]?[a-zA-Z0-9_]+\s*("))
          (backward-char 2)
          (thing-at-point 'symbol)
          )
        ))))


;; 在C项目中获取当前所在的函数名，并将函数名push到kill-ring中
;;;###autoload
(defun spk-display-func-name ()
  "Display current C function name,
and push it to `kill-ring'."
  (interactive)
  ;; 使用overlay的方式显示函数名不太美观
  ;; (spk/display-string-base-overlay (spk-get-c-defun-name))
  (let* ((def-name nil))
    (setq def-name (spk-get-c-defun-name))
    (when def-name
      (message (kill-new def-name)))))

;; 可能hs-minor-mode的功能比较鸡肋，这里待商榷
(define-key evil-normal-state-map (kbd ",n") #'spk-display-func-name)
(define-key evil-normal-state-map (kbd ",hb") #'hs-hide-block)
(define-key evil-normal-state-map (kbd ",ha") #'hs-hide-all)
(define-key evil-normal-state-map (kbd ",sb") #'hs-show-block)
(define-key evil-normal-state-map (kbd ",sa") #'hs-show-all)

(defalias 'cmode 'c-mode)

(provide 'init-C)
