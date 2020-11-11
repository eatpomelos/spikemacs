;; 用来配置一些默认的东西，这里主要设置一些默认的行为和默认的路径，可以将一些需要使用的宏也新建一个路径来进行管理
;; 关闭提示音和自动备份
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq w32-use-full-screen-buffer t)

;; 设置一些文件夹的位置
(setq-default browse-url-temp-dir (concat spk-local-dir "url/"))
(setq-default temporary-file-directory (concat spk-local-dir "url/"))
(setq-default url-configuration-directory (concat spk-local-dir "url/"))
(setq-default url-cache-directory (concat spk-local-dir "url/cache/"))
(setq-default tramp-auto-save-directory (concat spk-local-dir "auto-save/"))
(setq-default message-auto-save-directory (concat spk-local-dir "auto-save/"))

;; 设置recentf 临时文件的位置
(setq recentf-save-file (concat spk-local-tmp-dir "recentf"))
;; 下面更改了路径之后读取不到package，暂时不知道是什么原因，先将原来的目录改回来，之后找到原因再做调整。
(setq package-user-dir (concat spk-local-dir "elpa"))
      
(setq default-directory "~")

;; 下面的配置是设置是否开启缩写模式，在配置完成了之后配合tiny在一些场景下有用
;; (abbrev-mode t) 

(global-auto-revert-mode t)
(global-linum-mode t)

(setq auto-save-default nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq custom-file (expand-file-name "custom.el" spk-dir))
(load custom-file 'no-error 'no-message)

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

;; 设置文件编码模式，有时候会显示乱码需要处理

(provide 'init-default)
