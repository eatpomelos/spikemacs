(straight-use-package 'better-jumper)
(straight-use-package 'smart-hungry-delete)
;; (straight-use-package 'aggressive-indent-mode)
(straight-use-package 'deadgrep)
(straight-use-package 'beacon)
(straight-use-package 'minimap)
(straight-use-package 'yasnippet)

(defvar spk-source-code-dir nil
  "Path to store the source code.")

;; 替换xref的搜索程序，暂时没在windows上察觉到明显的速度变化
(when (and EMACS28+ IS-LINUX)
  (setq xref-search-program 'ripgrep)
  )

(setq spk-source-code-dir
      (cond (IS-WINDOWS "D:/work/linux_code/")
            (IS-LINUX "~/spk/source_code/")))

;; TODO：有时间的时候看是否使用这个包替代现在的查询方案
(straight-use-package
 '(color-rg :type git
			:host github
			:repo "manateelazycat/color-rg"
			))
;; (require 'color-rg)

(with-eval-after-load 'yasnippet
  (let ((inhibit-message nil))
    (setq yas-snippets-dirs (concat spk-dir "snippets/"))
    (setq yas--loaddir (concat spk-dir "snippets"))
    (yas-compile-directory yas-snippets-dirs)
    (yas-reload-all)))

(require 'init-tags)

;; citre暂时有以下缺点：
;; 生成的tags由于信息比较全导致tags文件很大，原TAGS文件400M，生成tags12G左右
;; 对于ctags版本有要求，但是在windows环境下，ctags的版本太低
;; 自己之前写的文件缓存的函数不能使用
;; 但是看效果要比etags好很多
;; (require 'init-citre)
(add-hook 'c-mode-hook (lambda ()
                         (define-key c-mode-map (kbd "DEL") 'smart-hungry-delete-backward-char)
                         (define-key c-mode-map (kbd "C-d") 'smart-hungry-delete-forward-char)))

(straight-use-package 'highlight-indent-guides)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; 设置tab的空格数，并不使用tab缩进而是使用空格来替代tab
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(straight-use-package 'imenu-list)
;; (straight-use-package 'projectile)

;; 编程时自动修改缩进，在某些时候很好用，在实际写代码时，会频繁缩进，导致体验下降 
;; (add-hook 'prog-mode-hook #'aggressive-indent-mode)
;; (advice-add 'makefile-gmake-mode :after
;;             '(lambda ()
;;                (aggressive-indent-mode 0)))

(add-hook 'prog-mode-hook #'better-jumper-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'hl-line-mode)

;; (autoload #'projectile-mode "projectile")
;; (add-hook 'prog-mode-hook #'projectile-mode)
;; keybindings
(global-set-key (kbd "<f12>") 'eshell)
(global-set-key (kbd "<f2>") 'imenu-list-smart-toggle)

(with-eval-after-load 'imenu-list
  (setq
   imenu-list-position 'left
   imenu-list-size 0.25
   ;; 此值设为t时，运行imenu-list-show会将光标移动到imenu-list的window
   imenu-list-focus-after-activation t
   )

  ;; 在imenu中跳转到条目所在位置，但是光标保留在当前位置
  (defun spk/imenu-list-peek-entry ()
    "Imenu-list peek."
    (interactive)
    (let* ((line-num (line-number-at-pos)))
      (imenu-list-goto-entry)
      (require 'winum)
      (winum-select-window-1)
      (goto-line line-num)
      )
    )
  (define-key imenu-list-major-mode-map (kbd "TAB") 'spk/imenu-list-peek-entry)
  (advice-add 'imenu-list-show :after #'evil-emacs-state)
  )

;; xref config
;; (advice-add 'xref--xref-buffer-mode :after #'evil-insert-state)
;; (define-key xref--xref-buffer-mode-map (kbd "j") 'xref-next-line)
;; (define-key xref--xref-buffer-mode-map (kbd "k") 'xref-prev-line)

;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=29619
(setq xref-prompt-for-identifier
      '(not
	xref-find-references
	xref-find-definitions
	xref-find-definitions-other-window
	xref-find-definitions-other-frame)
      )

;; functions

;; 跳转到函数开头，两秒内如果有操作则回到当前位置，否则两秒后自动跳转回来
;;;###autoload
(defun spk/project-peek-functions-head ()
  (interactive)
  (save-excursion
	(beginning-of-defun)
	(xref-pulse-momentarily)
	(sit-for 2)
	)
  )

;; 跳转到项目根目录 
;;;###autoload
(defun spk/project-find-file-in-root ()
  (interactive)
  (let* ((root-dir (+spk-get-file-dir "TAGS")))
    (unless root-dir
      (setq root-dir (+spk-get-file-dir ".git")))
    (if root-dir
        (counsel-find-file root-dir)
      (message "Not in a project")))
  )

;; 使用color-rg中的api在项目中搜索字符串
;;;###autoload
(defun spk/project-search-symbol-base-color-rg (&optional sym)
  (let* ((prog-dir (+spk-get-file-dir "TAGS"))
		 )
	(unless prog-dir
	  (setq prog-dir (+spk-get-file-dir ".git")))
	(unless sym
	  (setq sym (read-string "Please input symbol: ")))
	(message (format "sym=%s dir=%s" sym prog-dir))
	(if (and prog-dir (not (string= sym "")))
		(color-rg-search-input sym prog-dir "*.[ch]")
	  (message "Not in a project."))))

;;;###autoload
(defun spk/project-find-file ()
  "Find file in project root directory."
  (interactive)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
	(unless dir
	  (setq dir (locate-dominating-file default-directory ".\svn")))
    (if dir
		(spk-search-file-internal dir)
      (message "Not in a project directory."))
	))

;;;###autoload
(defun spk/project-search-symbol (&optional symbol)
  (let* ((dir (locate-dominating-file default-directory ".\git")))
    (unless dir
      (setq dir (locate-dominating-file default-directory "TAGS")))
    (unless dir
      (setq dir default-directory))
    (spk-search-file-internal dir t symbol (+spk-current-buffer-file-postfix))
    ))

;; 在大型项目中搜索字符串,使用基于color-rg的api来搜索
;;;###autoload
(defun spk/project-search-symbol-at-point ()
  (interactive)
  (spk/project-search-symbol-base-color-rg (thing-at-point 'symbol))
  )

;;;###autoload
(defun spk/project-search-symbol-from-input ()
  (interactive)
  (spk/project-search-symbol-base-color-rg nil)
  )

;; 在跳转到C函数时，将光标移动到函数名上 
;;;###autoload
(defun spk/jump-to-beginning-of-defname ()
  (interactive)
  (let* ((def-name nil))
    (if (not (eq major-mode 'c-mode))
        (beginning-of-defun)
      (setq def-name (spk-get-c-defun-name))
      (beginning-of-defun)
      (when def-name
        (re-search-forward def-name)
        (when (looking-at "(")
          (backward-char))
        ))))

;;;###autoload
(defun spk/project-find-docs-dir ()
  (interactive)
  (let* ((pjt-doc-dir nil))
    (cond ((setq pjt-doc-dir (+spk-get-complete-file "docs")))
          ((setq pjt-doc-dir (+spk-get-complete-file "doc")))
          ((setq pjt-doc-dir (+spk-get-complete-file "Documentation")))
          ((setq pjt-doc-dir (+spk-get-complete-file "documentation")))
          )
    (if pjt-doc-dir
        (find-file pjt-doc-dir)
      (message "documents dir not found"))
    ))

;; key bindings
(evil-leader/set-key
  "pd" 'xref-find-definitions
  "pt" 'counsel-etags-find-tag-at-point
  "ps" 'spk/project-search-symbol-at-point
  "pi" 'spk/project-search-symbol-from-input
  "pff" 'spk/find-file-entry
  "pfr" 'spk/project-find-file-in-root
  "pfa" 'spk/project-fast-find-all-file
  ;; "pcf" 'spk/project-ctags-find-file
  "pfe" 'counsel-etags-find-tag
  "pfd" 'spk/project-find-docs-dir
  ;; "pgd" 'spk/project-tags-code-navigation
  "eb" 'eval-buffer
  "mf" 'er/mark-defun
  "sp" 'dg                              ;;deadgrep
  )

;; 充分利用avy的api来进行跳转等操作,可以考虑用bind-key的api来定义快捷键
(define-key evil-normal-state-map (kbd ",w") #'avy-goto-char-2)
(define-key evil-normal-state-map (kbd ",b") #'isearch-backward)
(define-key evil-normal-state-map (kbd ",f") #'isearch-forward)
(define-key evil-normal-state-map (kbd ",l") #'avy-goto-line)
(define-key evil-normal-state-map (kbd ",p") #'spk/project-peek-functions-head)
(define-key evil-normal-state-map (kbd ",a") #'spk/jump-to-beginning-of-defname)
(define-key evil-normal-state-map (kbd ",e") #'end-of-defun)

;; 配置better-jumper快捷键来满足跳转需求
(with-eval-after-load 'better-jumper
  ;; 在进行跳转之后，闪一下当前行，便于在大段代码中定位行
  (advice-add 'better-jumper-jump-backward :after #'xref-pulse-momentarily)
  (advice-add 'better-jumper-jump-forward :after #'xref-pulse-momentarily)

  (define-key prog-mode-map (kbd "C-<f8>") 'better-jumper-jump-backward)
  (define-key prog-mode-map (kbd "C-<f9>") 'better-jumper-jump-forward)

  ;; LINUX上的备用按键
  (define-key prog-mode-map (kbd "C-\{") 'better-jumper-jump-backward)
  (define-key prog-mode-map (kbd "C-\}") 'better-jumper-jump-forward)
  )

(defalias 'dg 'deadgrep)

;; 是否有匹配多个map的按键配置方案?
(with-eval-after-load 'deadgrep
  
  (defun spk/deadgrep-exit ()
    (interactive)
    (deadgrep-kill-process)
    (deadgrep-kill-all-buffers)
    )
  (define-key deadgrep-mode-map  "q" 'spk/deadgrep-exit)

  ;; 默认分割窗口时分在右边 
  ;; (setq split-window-preferred-function 'split-window-right)
  
  (define-key deadgrep-mode-map (kbd "RET") 'deadgrep-visit-result-other-window)
  
  ;; 用下面的advice来是实现deadgrep匹配项的预览，此函数需要配合winum使用
  (setq spk-last-window (winum-get-number))
  (defadvice deadgrep-visit-result-other-window
      (before spk-save-last-window activate)
    (setq spk-last-window (winum-get-number)))
 
  ;; 当跳转到下一个deadgrep匹配项时，自动跳转视图，并将光标移动回来
  (advice-add 'deadgrep-forward-match :after
              #'(lambda ()
                  (deadgrep-visit-result-other-window)
                  (winum-select-window-by-number spk-last-window)))
  
  (advice-add 'deadgrep-backward-match :after
              #'(lambda ()
                  (deadgrep-visit-result-other-window)
                  (winum-select-window-by-number spk-last-window)))
  )

;; ;; 高亮更改文本,但是这个配置不好用的地方在于你保存了之后，不会自动取消你之前改变的文本
;; 当保存了buffer之后，移除之前的高亮,另外，当移除更改的时候也需要移除高亮
(defadvice save-buffer (after spike-remove-highlight activate)
  (when (highlight-changes-mode)
    (highlight-changes-remove-highlight (point-min) (point-max))))

;; 当撤销到最后一步的时候也需要取消高亮
(defadvice undo-tree-undo (after spik-remove-highlight activate)
  (when (highlight-changes-mode)
    (unless (buffer-modified-p)
      (highlight-changes-remove-highlight (point-min) (point-max)))))

(with-eval-after-load 'minimap
  (advice-add 'symbol-overlay-put
              :after
              #'(lambda ()
                 (when minimap-mode
                   (minimap-sync-overlays)
                   )))
  )

(add-hook 'c-mode-hook 'highlight-changes-mode)
(add-hook 'c-mode-hook 'beacon-mode)
(global-set-key (kbd "<f10>") 'beacon-blink)

;; 在org配置中增加对 sdasfkj 

;; 在通用的编程设置完成之后，读取针对相应编程语言的设置
(require 'init-elisp)
(require 'init-C)

(when IS-LINUX
  (require 'init-lsp))

;; (require 'init-lsp)

(provide 'init-prog)
