;; 和编辑相关的一些插件的配置
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)
(straight-use-package 'highlight-symbol)
(straight-use-package 'json-mode)

;; 指定github上的包，并下载
(straight-use-package
 '(company-english-helper :type git
			  :host github
			  :repo "manateelazycat/company-english-helper"))

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

;; 指定一个函数从文件中自动加载，暂时理解成指定一个函数为autoload，当使用这个函数时自动加载那个文件
(autoload #'toggle-company-english-helper "company-english-helper")

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
    "rs" 'restart-emacs
    "rn" 'restart-emacs-start-new-emacs
    "nr" 'narrow-to-region
    "nw" 'widen
    "m\]" 'er/mark-sentence))

(with-eval-after-load 'highlight-symbol
  (global-set-key (kbd "<f8>") 'highlight-symbol)
  (global-set-key (kbd "S-<f8>") 'highlight-symbol-prev)
  (global-set-key (kbd "S-<f9>") 'highlight-symbol-next)
)

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



;; bookmarks
(evil-leader/set-key
  "bm" 'bookmark-set
  "b \RET" 'counsel-bookmark)

;; ediff 配置

(provide 'init-editor)
