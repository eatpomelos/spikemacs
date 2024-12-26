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

(require 'lsp-bridge)
;; (add-hook 'prog-mode-hook 'lsp-bridge-mode)
(add-hook 'c-mode-hook 'lsp-bridge-mode)

;;;###autoload
(defun spk/find-def-entry ()
  (interactive)
  (if (+spk-get-complete-file "compile_commands.json")
      (lsp-bridge-find-def)
    (xref-find-definitions (thing-at-point 'symbol))
    ))

;;;###autoload
(defun spk/find-ref-entry ()
  (interactive)
  (if (+spk-get-complete-file "compile_commands.json")
      (lsp-bridge-find-references)
    (xref-find-references (thing-at-point 'symbol))
    ))

;; 在进入 C-mode 的时候如果在根目录中发现了 compile_command.json 文件则使用 lsp-bridge 的快捷键
(add-hook 'c-mode-hook #'(lambda ()
                           (when IS-LINUX
                             (evil-define-key* 'normal c-mode-map "gd" #'spk/find-def-entry)
                             (evil-define-key* 'normal c-mode-map "gr" #'spk/find-ref-entry)
                             )))

;; 在开启lsp的时候，移除company-mode的hook，使用lsp的补全
(remove-hook 'prog-mode-hook 'company-mode)

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
