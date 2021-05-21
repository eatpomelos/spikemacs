;; 和编辑相关的一些插件的配置
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)
(straight-use-package 'json-mode)
(straight-use-package 'symbol-overlay)
(straight-use-package 'deadgrep)
;; (straight-use-package 'doom-modeline)

;; 考虑要不要加这个配置
(straight-use-package 'undo-tree)
(add-hook 'emacs-startup-hook #'global-undo-tree-mode)

;; 怎么在不添加新的package的情况下覆盖绑定?
(with-eval-after-load  'undo-tree
  (global-set-key (kbd "C-r") #'undo-tree-redo)
  (define-key evil-normal-state-map (kbd "C-r") #'undo-tree-redo)
  (global-set-key (kbd "C-/") #'undo-tree-undo)
  )

(require 'deadgrep)

;; 指定github上的包，并下载，由于当前的环境配置中 linux下的环境没有界面因此使用此package会导致emacs卡死
(when IS-WINDOWS
  (straight-use-package
   '(company-english-helper :type git
			    :host github
			    :repo "manateelazycat/company-english-helper"))
  ;; 指定一个函数从文件中自动加载，暂时理解成指定一个函数为autoload，当使用这个函数时自动加载那个文件
  (autoload #'toggle-company-english-helper "company-english-helper")
  (global-set-key (kbd "<f1>") 'toggle-company-english-helper))

;; TODO：有时间的时候看是否使用这个包替代现在的查询方案
;; (straight-use-package
;;  '(color-rg :type git
;; 	    :host github
;; 	    :repo "manateelazycat/color-rg"))
;; (require 'color-rg)

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

(global-set-key (kbd "C-c v") 'set-mark-command)
(global-set-key (kbd "C-c l") 'avy-goto-line)
(global-set-key (kbd "C-c C-l") 'goto-line)
(global-set-key (kbd "C-<down>") 'text-scale-decrease)
(global-set-key (kbd "C-<up>") 'text-scale-increase)

(with-eval-after-load 'expand-region
  (evil-leader/set-key
    "mop" 'er/mark-org-parent
    "moe" 'er/mark-org-element
    "ms" 'er/mark-symbol
    "m\]" 'er/mark-sentence))

(autoload #'symbol-overlay-put "symbol-overlay")
(autoload #'symbol-overlay-save-symbol "symbol-overlay")

(global-set-key (kbd "<f8>") 'symbol-overlay-put)
(global-set-key (kbd "S-<f8>") 'symbol-overlay-jump-prev)
(global-set-key (kbd "S-<f9>") 'symbol-overlay-jump-next)

;; 设置英语检错，设置有问题，暂时未解决
(when IS-WINDOWS
  (setq ispell-program-name "aspell")
  (setq ispell-process-directory "~/MSYS2/mingw64/bin/")
  ;; 设置词典，但是在此配置上出现了问题，暂时未解决
  ;; (setq
  ;;  ispell-dictionary (expand-file-name (concat spk-local-dir "english-words.txt"))
  ;;  ispell-complete-word-dict (expand-file-name (concat spk-local-dir "english-word.txt"))
  ;;  )
  )

;; 由于高亮显示占用了evil的快捷键，且暂时不使用其自定义的快捷键，禁用symbol-overlay-mode
(with-eval-after-load 'symbol-overlay
  (setq symbol-overlay-inhibit-map t))

;; bookmarks
(evil-leader/set-key
  "bm" 'bookmark-set
  "rs" 'restart-emacs
  "rn" 'restart-emacs-start-new-emacs
  "nr" 'narrow-to-region
  "nw" 'widen
  "b \RET" 'counsel-bookmark
  "sy" 'symbol-overlay-save-symbol
  "si" 'spk/search-symbol-at-point-with-browser
  )

;; ediff 配置

(provide 'init-editor)
