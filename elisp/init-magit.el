;; magit相关配置  -*- lexical-binding: t; -*-
;; 指定 magit 版本
(straight-use-package
 '(magit :type git
         :host github
         :repo "magit/magit"
         ))

;; 通用的配置通过magit-status触发，基于单独文件的log基于magit-log触发
(evil-leader/set-key
  ;; 将 status 作为一个大的入口
  "gs" 'magit-status
  ;; gb 作为 branch 和 blame 命令的前缀
  "gbc" 'magit-branch-checkout
  "gbn" 'magit-branch-and-checkout
  "gbd" 'magit-branch-delete
  "gbb" 'magit-blame-addition
  "gbq" 'magit-blame-quit
  ;; gl 作为 log 命令的前缀
  "gll" 'magit-log
  "gla" 'magit-log-all
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  ;; gt 作为 stash 命令的前缀
  "gtt" 'magit-stash
  "gti" 'magit-stash-index
  "gtd" 'magit-stash-drop
  "gtp" 'magit-stash-pop
  "gta" 'magit-stash-apply
  "gts" 'magit-stash-show
  ;; gr 作为 ref 的前缀包括 reflog 和 refs
  "grs" 'magit-show-refs
  "grc" 'magit-reflog-current
  "gro" 'magit-reflog-other
  "grh" 'magit-reflog-head
  ;; 其他命令
  )

(provide 'init-magit)
