;; 关闭提示音和自动备份
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq w32-use-full-screen-buffer t)

;; 关闭 emacs 的欢迎界面
(setq inhibit-splash-screen t)
;; 设置一些文件夹的位置
(setq-default browse-url-temp-dir (concat spk-local-dir "url/"))
(setq-default temporary-file-directory (concat spk-local-dir "url/"))
(setq-default url-configuration-directory (concat spk-local-dir "url/"))
(setq-default url-cache-directory (concat spk-local-dir "url/cache/"))
(setq-default tramp-auto-save-directory (concat spk-local-dir "auto-save/"))
(setq-default message-auto-save-directory (concat spk-local-dir "auto-save/"))

;; 设置transient一些文件的保存位置
(setq-default transient-history-file (concat spk-local-tmp-dir "transient/history.el"))
(setq-default transient-levels-file (concat spk-local-tmp-dir "transient/levels.el"))
(setq-default transient-values-file (concat spk-local-tmp-dir "transient/values.el"))

(setq-default bookmark-file (concat spk-local-tmp-dir "bookmarks"))
;; 设置server认证的目录位置
(setq-default server-auth-dir (concat spk-local-dir "server/"))

;; 设置自动保存的前缀，避免保存在emacs的主目录导致主目录文件夹过多
(setq-default auto-save-list-file-prefix (concat spk-local-tmp-dir "auto-save-list/.saves-"))

;; 设置recentf 临时文件的位置
(setq-default recentf-save-file (concat spk-local-tmp-dir "recentf"))

;; 设置eshell的路径
(setq-default eshell-directory-name (concat spk-local-tmp-dir "eshell/"))

;; 设置默认语言环境
;; (set-language-environment 'utf-8)
;; (prefer-coding-system 'utf-8)
;; (setq default-file-name-coding-system 'utf-8)

(global-auto-revert-mode t)
(global-linum-mode t)

(setq auto-save-default nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq custom-file (expand-file-name "custom.el" spk-dir))
(when (file-exists-p custom-file)
  (load custom-file 'no-error 'no-message))

;; (setq inhibit-splash-screen t)
(setq-default cursor-type 'bar)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; 选中文字后可以直接替换，使用了evil的时候这个配置没用
;; (delete-selection-mode t)

;; 避免在切换不同文件按之后生成很多的buffer
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;; ;; 高亮更改文本,但是这个配置不好用的地方在于你保存了之后，不会自动取消你之前改变的文本
;; (global-highlight-changes-mode 1)
;; ;; 当保存了buffer之后，移除之前的高亮,另外，当移除更改的时候也需要移除高亮
;; (defadvice save-buffer (after spike-remove-highlight activate)
;;   (when (highlight-changes-mode)
;;     (highlight-changes-remove-highlight (point-min) (point-max))))

;; ;; 当撤销到最后一步的时候也需要取消高亮
;; (defadvice undo-tree-undo (after spik-remove-highlight activate)
;;   (when (highlight-changes-mode)
;;     (unless (buffer-modified-p)
;;       (highlight-changes-remove-highlight (point-min) (point-max)))))

;; 开启括号的补全
(electric-pair-mode 1)

;; recentf不保存以下文件，以下规则匹配emacs中的正则表达式
(setq recentf-exclude
      '("COMMIT_MSG"
        "COMMIT_EDITMSG"
        "github.*txt$"
        ;; "/tmp/"
        "/ssh:"
        "/sudo:"
        "/TAGS$"
        "/GTAGS$"
        "/GRAGS$"
        "/GPATH$"
        "\\.mkv$"
        "\\.mp[34]$"
        "\\.avi$"
        "\\.pdf$"
        "\\.sub$"
        "\\.srt$"
        "\\.ass$"
        ".*png$"
        ".*bmp$"
        ".*db$"
        "init\\.el$"
        "/roam/"
        "/.emacs.d/"))
(provide 'init-default)
