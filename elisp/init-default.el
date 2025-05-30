;; 关闭提示音和自动备份  -*- lexical-binding: t; -*-
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq w32-use-full-screen-buffer t)

;; 忽略告警
(setq warning-suppress-types '((lexical-binding)
                               (iedit)
                               ))

;; 关闭 emacs 的欢迎界面
(setq inhibit-splash-screen t)
;; 如果url路径不存在，则首先创建，避免配置拷贝下来之后加载失败
(unless (file-exists-p (concat spk-local-dir "url"))
  (make-directory (concat spk-local-dir "url")))
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

(defconst spk-scratch-log
  ";;   _____       _ __                                 
;;  / ___/____  (_) /_____  ____ ___  ____ ___________
;;  \\__ \\/ __ \\/ / //_/ _ \\/ __ `__ \\/ __ `/ ___/ ___/
;; ___/ / /_/ / / ,< /  __/ / / / / / /_/ / /__(__  ) 
;;/____/ .___/_/_/|_|\\___/_/ /_/ /_/\\__,_/\\___/____/  
;;    /_/
\n"
  )

;; 这里的配置可能导致latex编译出错，暂不确定原因
;; 设置默认语言环境，这部分配置只用在linux上，由于windows上还存在部分latex导出失败问题，这里做区分
(when IS-LINUX
  (set-language-environment 'utf-8)
  (setq default-file-name-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  )

(setq default-buffer-file-coding-system 'utf-8)

(global-auto-revert-mode t)

(setq auto-save-default nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq custom-file (expand-file-name "custom.el" spk-dir))
(if (file-exists-p custom-file)
    (load custom-file 'no-error 'no-message)
  (ignore-errors
    ;; (set-face-attribute 'default nil :font (font-spec :family "文泉驿等宽正黑" :size 20)))
    (set-face-attribute 'default nil :font (font-spec :family "文泉驿等宽正黑" :size 18)))
  )

;; (setq inhibit-splash-screen t)
(setq-default cursor-type 'bar)

;; 选中文字后可以直接替换，使用了evil的时候这个配置没用
;; (delete-selection-mode t)

;; 避免在切换不同文件按之后生成很多的buffer
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;; 开启括号的补全
(electric-pair-mode 1)
(setq electric-quote-comment t)

;; 显示当前列
(column-number-mode 1)

;; 修改打开大文件警告的阈值为30M，避免在一些大型项目的缓存文件打开时每次提示 
(setq large-file-warning-threshold 100000000)

;; recentf不保存以下文件，以下规则匹配emacs中的正则表达式
(setq recentf-exclude
      '("COMMIT_MSG"
        "COMMIT_EDITMSG"
        "github.*txt$"
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
        "/.emacs.d/straight/"
        )
)

(provide 'init-default)
