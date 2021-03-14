;; 关于目录操作相关的配置主要是dired 以及其余对于目录等操作相关的

(straight-use-package 'neotree)
;; (straight-use-package 'dired-git-info)

(evil-leader/set-key
  "ft" 'neotree-toggle)

(with-eval-after-load "dired"
  (define-key dired-mode-map "w" #'wdired-change-to-wdired-mode))

(provide 'init-dired)
