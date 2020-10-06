;; 用来配置一些默认的东西，这里主要设置一些默认的行为和默认的路径，可以将一些需要使用的宏也新建一个路径来进行管理
;; 关闭提示音和自动备份
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)

;; 设置一些在后面使用到的路径
;; 设置用来防止保存的或者下载的路径，这个路径在后面要写入.gitignore规则

(setq url-configuration-directory (concat spikemacs-local-dir "url/"))
(setq url-cache-directory (concat spikemacs-local-dir "url/cache/"))

;; 下面更改了路径之后读取不到package，暂时不知道是什么原因，先将原来的目录改回来，之后找到原因再做调整。
(setq package-user-dir (concat spikemacs-local-dir "elpa"))
      
(setq default-directory "~")

;; 下面的配置是设置是否开启缩写模式，在配置完成了之后配合tiny在一些场景下有用
;; (abbrev-mode t) 

(global-auto-revert-mode t)
(global-linum-mode t)

(setq auto-save-default nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq custom-file (expand-file-name "custom.el" spikemacs-dir))
(load custom-file 'no-error 'no-message)

;; (setq inhibit-splash-screen t)
(setq-default cursor-type 'bar)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; 高亮更改文本,但是这个配置不好用的地方在于你保存了之后，不会自动取消你之前改变的文本
(global-highlight-changes-mode 1)
;; 当保存了buffer之后，移除之前的高亮,另外，当移除更改的时候也需要移除高亮
(defadvice save-buffer (after spike-remove-highlight activate)
  (when (highlight-changes-mode)
    (highlight-changes-remove-highlight (point-min) (point-max))))

;; 当撤销到最后一步的时候也需要取消高亮
(defadvice undo-tree-undo (after spik-remove-highlight activate)
  (when (highlight-changes-mode)
    (unless (buffer-modified-p)
      (highlight-changes-remove-highlight (point-min) (point-max)))))

;; 开启括号的补全
(electric-pair-mode 1)

(provide 'init-default)
