;; 只在linux下使用lsp，暂时不配置其他的东西  -*- lexical-binding: t; -*-
(straight-use-package 'projectile)
(straight-use-package 'posframe)
(straight-use-package 'corfu)

(setq spk-lsp-bridge-dir (concat spk-local-packges-dir "lsp-bridge/"))

(setq projectile-git-fd-args "-H -0 -E .git -tf -c never")
;; (setq projectile-fd-executable "fd")

(unless (file-exists-p spk-lsp-bridge-dir)
  (shell-command-to-string (format "git clone https://gitee.com/manateelazycat/lsp-bridge %s" spk-lsp-bridge-dir)))

(add-to-list 'load-path spk-lsp-bridge-dir)

(require 'yasnippet)
(yas-global-mode 1)

;; 设置一个定时器每隔 15 秒获取一次剩余内存
(setq spk-lsp-free-check-timer nil)

(defun spk/lsp-consider-restart-lsp-bridge ()
  (unless (> (/ (+spk-get-memavailable) 1024) 300)
    (message (format "run out of memory consider to restart lsp-bridge"))
    (lsp-bridge-restart-process))
  )

(add-hook 'lsp-bridge-mode-hook #'(lambda ()
                                    (unless spk-lsp-free-check-timer
                                      (message (format "spike start timer"))
                                      (setq spk-lsp-free-check-timer
                                            (run-with-timer 0 15 #'spk/lsp-consider-restart-lsp-bridge)))))

(add-hook 'lsp-bridge-stop-process-hook #'(lambda ()
                                            (when spk-lsp-free-check-timer
                                              (message (format "spike cancel timer"))
                                              (cancel-timer spk-lsp-free-check-timer)
                                              (setq spk-lsp-free-check-timer nil)
                                              )))

(require 'lsp-bridge)
;; (add-hook 'prog-mode-hook 'lsp-bridge-mode)
(add-hook 'c-mode-hook 'lsp-bridge-mode)
(add-hook 'perl-mode-hook 'lsp-bridge-mode)
(add-hook 'emacs-lisp-mode-hook 'lsp-bridge-mode)
(add-hook 'python-mode-hook 'lsp-bridge-mode)
(add-hook 'inferior-emacs-lisp-mode-hook 'lsp-bridge-mode)

(setq lsp-bridge-search-words-rebuild-cache-idle 0.5)

;; (global-lsp-bridge-mode)

;; 将隐藏补全框的字符设置成 nil，在所有情况下都进行补全，后续实际体验过程中再修改
;; (setq lsp-bridege-completion-hide-characters nil)

(add-hook 'python-mode-hook (lambda ()
                              (evil-define-key* 'normal python-mode-map "gd" #'lsp-bridge-find-def)
                              (evil-define-key* 'normal python-mode-map "gr" #'lsp-bridge-find-references)
                              ))

(evil-set-initial-state 'lsp-bridge-ref-mode 'emacs)

(provide 'init-lsp)
