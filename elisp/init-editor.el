;; 和编辑相关的一些插件的配置
(straight-use-package 'expand-region)
(straight-use-package 'restart-emacs)
(straight-use-package 'json-mode)
(straight-use-package 'symbol-overlay)
(straight-use-package 'deadgrep)
;; (straight-use-package 'doom-modeline)

;; 下面的是为了解决之前输入中文卡顿的原因，同时也解决了一些字显示的问题。
(set-language-environment 'UTF-8)
(set-locale-environment "UTF-8")

;; 设置编码终端解决乱码问题，待测试
(set-terminal-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

;; 添加autoload函数  
(autoload #'er/mark-defun "expand-region")
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

(define-key global-map (kbd "C-=") 'er/expand-region)
(define-key global-map (kbd "C-\-") 'er/contract-region)

(global-set-key (kbd "C-c v") 'set-mark-command)
(global-set-key (kbd "C-c l") 'avy-goto-line)
(global-set-key (kbd "C-c C-l") 'goto-line)
;; 在minibuff中输入的时候由于焦点的变化导致光标无法回到minibuffer的输入框，且无法用C-g来解决
(global-set-key (kbd "C-c C-g") 'minibuffer-keyboard-quit)
(global-set-key (kbd "C-<down>") 'text-scale-decrease)
(global-set-key (kbd "C-<up>") 'text-scale-increase)

(with-eval-after-load 'expand-region

  ;; 标记整个函数的时候，打印这个函数的行数
  ;; (save-restriction) 函数是在执行之后恢复原来的buffer状态，包括变窄的状态等
  (advice-add
   'er/mark-defun
   :before #'(lambda ()
			   (save-excursion
				 (let* ((ed-line 0)
						(st-line 0))
				   (beginning-of-defun)
				   (setq st-line (line-number-at-pos))
				   (end-of-defun)
				   (setq ed-line (line-number-at-pos))
				   (message "function lines:%d" (- ed-line st-line))
				   )
				 )))

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
  "si" 'spk/search-symbol-from-input
  "ss" 'spk/search-symbol-at-point
  )

;; ediff 配置

(provide 'init-editor)
