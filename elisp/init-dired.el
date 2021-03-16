;; 关于目录操作相关的配置主要是dired 以及其余对于目录等操作相关的

(straight-use-package 'neotree)
;; (straight-use-package 'dired-git-info)

(evil-leader/set-key
  "ft" 'neotree-toggle)

(with-eval-after-load "neotree"
  (define-key neotree-mode-map "o" #'spk-open-file-with-system-application)
  (define-key neotree-mode-map "h" #'left-char)
  (define-key neotree-mode-map "j" #'neotree-next-line)
  (define-key neotree-mode-map "k" #'neotree-previous-line)
  (define-key neotree-mode-map "l" #'right-char)
  )

(with-eval-after-load "dired"
  (define-key dired-mode-map "w" #'wdired-change-to-wdired-mode)
  )

(provide 'init-dired)
