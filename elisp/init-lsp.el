;; 只在 linux 下使用 lsp，暂时不配置其他的东西  -*- lexical-binding: t; -*-
(straight-use-package 'projectile)

(setq projectile-git-fd-args "-H -0 -E .git -tf -c never")
;; (setq projectile-fd-executable "fd")

(straight-use-package
 '(lsp-bridge
   :type git
   :host github
   :repo "manateelazycat/lsp-bridge"
   :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
   :build (:not compile)
   ))

(unless (is-gui)
  (straight-use-package
   '(popon :host nil :repo "https://codeberg.org/akib/emacs-popon.git"))
  (straight-use-package
   '(acm-terminal :host github :repo "twlz0ne/acm-terminal")))

(require 'yasnippet)
(yas-global-mode 1)

;; lsp-bridge terminal patch
(when (is-tui)
  (with-eval-after-load 'acm
    (require 'acm-terminal)))
              
(require 'lsp-bridge)
(add-hook 'c-mode-hook 'lsp-bridge-mode)
(add-hook 'nix-mode-hook 'lsp-bridge-mode)

(setq acm-enable-tabby nil)
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
                             (evil-define-key* 'normal c-mode-map "gp" #'lsp-bridge-peek)
                             )))

;; 在开启 lsp 的时候，移除 company-mode 的 hook，使用 lsp 的补全
(remove-hook 'prog-mode-hook 'company-mode)

(add-hook 'perl-mode-hook 'lsp-bridge-mode)
(add-hook 'emacs-lisp-mode-hook 'lsp-bridge-mode)
(add-hook 'python-mode-hook 'lsp-bridge-mode)
(add-hook 'inferior-emacs-lisp-mode-hook 'lsp-bridge-mode)

;; 进入开启了 lsp-bridge-mode 的 Buffer 时，关闭 corfu-mode
(defun spk/disable-corfu-in-lsp-bridge ()
  (if (bound-and-true-p lsp-bridge-mode)
      (progn
        (corfu-mode -1)
        (setq-local corfu-auto nil))
    
    ;; 只有在非编程环境的特定文档模式下，才允许打开 corfu
    (when (derived-mode-p 'org-mode 'text-mode)
      (corfu-mode 1)
      (kill-local-variable 'corfu-auto))))

(add-hook 'lsp-bridge-mode-hook #'spk/disable-corfu-in-lsp-bridge)

(setq lsp-bridge-search-words-rebuild-cache-idle 0.5)

(setq lsp-bridge-popup-documentation-frame t)

(add-hook 'python-mode-hook (lambda ()
                              (evil-define-key* 'normal python-mode-map "gd" #'lsp-bridge-find-def)
                              (evil-define-key* 'normal python-mode-map "gr" #'lsp-bridge-find-references)
                              ))

(evil-set-initial-state 'lsp-bridge-ref-mode 'emacs)

(provide 'init-lsp)
