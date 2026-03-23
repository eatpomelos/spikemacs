;; -*- lexical-binding: t; -*-
(straight-use-package 'denote)
(straight-use-package 'denote-journal)
(straight-use-package 'denote-journal-capture)
(straight-use-package 'consult-notes)
(straight-use-package 'denote-explore)

(require 'denote)
(require 'denote-journal)
(require 'denote-journal-capture)
(require 'consult-notes)

(defvar spk-denote-ref-path-depth 2)
(defvar spk-denote-ref-update-interval 20
  "Interval in seconds between updating the ref file cache.")

(setq spk-note-dir (concat spk-doc-dir "spk-notes/")
      denote-directory (concat spk-note-dir "denote/")
      spk-denote-index-directory (concat denote-directory "index/")
      denote-journal-directory (concat denote-directory "journal/")
      spk-denote-notes-directory (concat denote-directory "notes/")
      spk-denote-work-directory (concat denote-directory "works/")
      spk-denote-reading-directory (concat denote-directory "reading/")
      spk-denote-ref-file-directory (concat spk-note-dir "ref_File/")
      )

(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)


(add-hook 'markdown-mode-hook #'denote-fontify-links-mode)
(add-hook 'text-mode-hook #'denote-fontify-links-mode)
;; 不忽略org-mode 的 fontiffy-links-mode
(add-hook 'org-mode-hook #'denote-fontify-links-mode)

(setq denote-save-buffers nil)
;; 常用的关键字，这里需要仔细配置一下
(setq denote-known-keywords '("emacs" "linux" "work" "reading" "programming" "wiki" "literature"))
;; 定义自己的控制标签，用来标识一个文件的生命周期
(setq spk-denote-known-keywords '("mustcheck" "archived" "permanent"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-excluded-directories-regexp nil)
(setq denote-excluded-keywords-regexp nil)
(setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
;; 添加子目录选项，添加笔记时候，指定添加的目录
(setq denote-prompts '(title keywords subdirectory))

;; Pick dates, where relevant, with Org's advanced interface:
(setq denote-date-prompt-use-org-read-date t)

;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
(denote-rename-buffer-mode 1)
;; 由于这里想要去掉journal目录，所以不开启consult-notes-denote-mode
(consult-notes-denote-mode 0)

;; https://github.com/mclear-tools/consult-noteus
(setq consult-notes-sources
      `(
        ("index"        ?i ,spk-denote-index-directory)
        ("notes"        ?n ,spk-denote-notes-directory)
        ("works"         ?w ,spk-denote-work-directory)
        ("reading"      ?r ,spk-denote-reading-directory)
        ))

(defun spk/denote-toggle-keyword (&optional target)
  "快速开关当前文件的关键字标签。
若未提供 TARGET，则从 `spk-denote-known-keywords` 中 Ivy 选一个。"
  (interactive)
  (let* ((file (or (buffer-file-name)
                   (dired-get-filename nil t))))
    (unless (and file (file-exists-p file) (denote-file-has-identifier-p file))
      (user-error "无效操作：当前文件不是有效的 Denote 笔记"))
    (let* ((current-kw (denote-extract-keywords-from-path file))
           (actual-target (or target 
                              (completing-read "Select state tag: " 
                                               (cl-remove-if (lambda (k) (member k current-kw))
                                                             spk-denote-known-keywords))))
           (denote-rename-confirmations nil)
           (denote-save-buffers t)
           (denote-after-rename-file-hook nil))

      ;; 如果添加 permanent，自动移除 mustcheck；
      ;; 如果添加 mustcheck，自动移除 permanent。
      (let* ((is-adding (not (member actual-target current-kw)))
             (new-kw (if is-adding
                         (cons actual-target current-kw)
                       (remove actual-target current-kw))))
        ;; 自动清理互斥状态
        (when is-adding
          (cond 
           ((string= actual-target "permanent") 
            (setq new-kw (cl-set-difference new-kw '("mustcheck" "archived") :test #'string=)))
           ((string= actual-target "mustcheck") 
            (setq new-kw (cl-set-difference new-kw '("permanent" "archived") :test #'string=)))
           ((string= actual-target "archived") 
            (setq new-kw (cl-set-difference new-kw '("mustcheck" "permanent") :test #'string=)))))
        
        (setq new-kw (sort new-kw #'string<))
        (denote-rename-file file 'keep-current new-kw 'keep-current 'keep-current 'keep-current)
        
        ;; 如果在 Dired 模式，刷新当前行
        (when (derived-mode-p 'dired-mode)
          (dired-revert))

        (message "'%s' %s (Current: %s)" 
                 actual-target
                 (if is-adding "Added" "Removed")
                 (mapconcat #'identity new-kw ", "))))))

;; 快速移除mustcheck
(defun spk/denote-toggle-card-state ()
  (interactive)
  (spk/denote-toggle-keyword))

(defun spk/denote-toggle-buffer-keyword ()
  "从当前 Denote 笔记已有的标签中选择一个进行 toggle 操作。"
  (interactive)
  (when-let* ((file (buffer-file-name))
              ((denote-file-has-identifier-p file))
              (current-kws (denote-extract-keywords-from-path file))
              ;; 只有当文件有标签时才弹出选择
              (target (completing-read "Select keyword to toggle: " current-kws nil nil)))
    (spk/denote-toggle-keyword target)))

;; 获取当天的denote-journal 文件，这里和原始的用法不同，默认认为一天只会有一个journal文件
(defun spk/find-today-journal-denote-entry ()
  "Get today denote journal entry."
  (interactive)
  (if-let* ((files
             (denote-directory-files
              (denote-journal--filename-date-regexp (current-time))))
            (file (denote-journal-select-file-prompt files)))
      (progn
        ;; 如果当前文件已经打开，则直接跳转到对应buffer
        (cond ((get-file-buffer file) (switch-to-buffer (get-file-buffer file)))
              (t (funcall denote-open-link-function file))
              ))
    (denote-journal-new-entry)
    )
  )

(defun spk/list-mustcheck-links ()
  "列出当前denote卡片中被标记为mustcheck的卡片"
  (interactive)
  (let* ((files (denote-directory-files))
         (mustcheck-files (seq-filter
                           (lambda (file)
                             (string-match-p "__.*mustcheck" file))
                           files))
         (grouped-files (seq-group-by (lambda (f)
                                        (file-name-nondirectory
                                         (directory-file-name (file-name-directory f))))
                                      mustcheck-files)))
    (with-current-buffer (get-buffer-create "*Denote MustCheck*")
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (make-string 30 ?=) "\n")
        (insert (format "*TOTAL MUSTCHECK: %d*\n" (length mustcheck-files)))
        (insert (make-string 30 ?=) "\n")

        (if (null mustcheck-files)
            (insert "No pending items.")
          (dolist (group grouped-files)
            (let ((dir-name (car group))
                  (file-list (cdr group)))
              (insert (format "\n* %s (%d)\n" (upcase dir-name) (length file-list)))
              (dolist (file file-list)
                (let* ((id (denote-retrieve-filename-identifier file))
                       (title (denote-retrieve-filename-title file)))
                  (insert (format "[[denote:%s][%s]]\n" id title)))))))
        (org-mode)
        (goto-char (point-min))
        (show-all)
        (switch-to-buffer-other-window (current-buffer))
        (message "MustCheck: %d items." (length mustcheck-files))))))

;; 定义一个函数，实现打开当前光标下的链接功能
(defun spk/open-link-at-point ()
  "Open link at point."
  (interactive)
  (let* ((url (thing-at-point 'url))
         (org-link-elisp-confirm-function nil))
    (cond
     ((get-text-property (point) 'denote-link-query-part)
      (denote-link-open-at-point))
     (url
      (if (and (eq major-mode 'org-mode) (not (string-match-p "^\\(https?\\|ftp\\):" url)))
          (org-open-at-point)
        (if (commandp 'eaf-open)
            (eaf-open-url-at-point)
          (eww url)
          )))
     ((eq major-mode 'org-mode)
      (org-open-at-point))
     ((thing-at-point 'filename) (find-file-at-point))
     (t (message "Can not open link at point."))
     )
    ))

;; denote--get-link-file-path-at-point
(defun spk/org-bulletin-file-peek ()
  (interactive)
  (let* ((peek-file
          (cond
           ((get-text-property (point) 'denote-link-query-part)
            (denote--get-link-file-path-at-point))
           ((thing-at-point 'url) (thing-at-point 'url))
           (t nil)
           )))
    (if (and peek-file (string-match-p "^file:" peek-file))
        (spk/set-pos-buf-ctx (replace-regexp-in-string "^file:*" "" peek-file) 5 20)
      (spk/set-pos-buf-ctx "bulletin is null")
      )
    ))

(add-to-list 'spk-bulletin-help-alist '(org-mode . spk/org-bulletin-file-peek))

(defun spk/denote-get-ref-file ()
  "get denote ref file path."
  (let* ((default-directory spk-denote-ref-file-directory)
         (cache-file (expand-file-name spk-prj-all-cache-file spk-denote-ref-file-directory))
         (ins-file
          (cond
           ((file-exists-p cache-file)
            (spk/find-file-from-cache cache-file nil))
           (t (spk-search-file-internal spk-denote-ref-file-directory nil))))
         )
    (if (file-exists-p ins-file)
        ins-file
      nil)))

;; 简单封装一个函数，在插入链接时，基于ref_File 目录插入，由于ref_File 目录的文件较多，
;; 所以需要查找补全插入，为了提升速度，基于文件缓存的方式是最快的，可以考虑不用默认的org方式
(defun spk/org-insert-ref-file ()
  "Insert denote ref file link."
  (interactive)
  (let* ((ins-file (spk/denote-get-ref-file))
         (description (read-string "Description: " nil t nil))
         (link-string (format "[[file:%s]%s]"
                              (abbreviate-file-name ins-file)
                              (if (> (length description) 0)
                                  (format "[%s]" description)
                                description))))
    (if ins-file
        (insert link-string)
      (message "file:%s is not exist." ins-file))
    )
  )

;; 增加接口查找并打开ref文件
(defun spk/denote-find-ref-file ()
  (interactive)
  (let* ((ref-file (spk/denote-get-ref-file)))
    (when ref-file
      (find-file ref-file))))

;; 启用一个定时器，检测ref目录的文件结构变化，如果发生变化，则重新生成文件缓存
(run-with-timer 0 spk-denote-ref-update-interval #'(lambda ()
                         (let* (cmd-str)
                           (setq cmd-str
                                 (format "%s %s %d"
                                         (shell-quote-argument (concat spk-scripts-dir "update_file_cache"))
                                         (shell-quote-argument (expand-file-name spk-denote-ref-file-directory))
                                         spk-denote-ref-path-depth))
                           (start-process "update-denote-ref-cache" nil "sh" "-c" cmd-str))
                         ))

;; 在笔记未迁移完成前先保留org-roam 的配置
(require 'init-org-roam)

(global-set-key (kbd "C-c b") 'consult-buffer)

;; 设置denote 快捷键，常用的快捷键需要配置一下
(global-set-key (kbd "C-c n j") 'spk/open-link-at-point)
(global-set-key (kbd "C-c n f") 'consult-notes)
(global-set-key (kbd "C-c n i") 'denote-insert-link)
(global-set-key (kbd "C-c n n") 'spk/list-mustcheck-links)
(global-set-key (kbd "C-c n d") 'denote)
(global-set-key (kbd "C-c n l") 'spk/org-insert-ref-file)
(global-set-key (kbd "C-c n q") 'spk/denote-find-ref-file)
(global-set-key (kbd "C-c n r") 'denote-find-backlink)
(global-set-key (kbd "C-c n t") 'spk/denote-toggle-card-state)
(global-set-key (kbd "C-c n a") 'spk/denote-toggle-buffer-keyword)

(evil-leader/set-key
  ;; org-roam 的快捷键，笔记迁移完成后删除
  "oo" 'spk/list-mustcheck-links
  "op" 'org-roam-node-find
  "of" 'consult-notes
  "os" 'consult-notes-search-in-all-notes
  "ob" 'denote-find-backlink
  "or" 'denote-find-link
  "oi" 'denote-insert-link
  "ol" 'spk/org-insert-ref-file
  "ot" 'spk/denote-toggle-card-state
  "oa" 'spk/denote-toggle-buffer-keyword
  "oq" 'spk/denote-find-ref-file
  "oj" 'spk/open-link-at-point
  "odt" 'spk/find-today-journal-denote-entry
  "odn" 'denote-journal-new-entry
  "odd" 'denote
  "odr" 'denote-region
  "odl" 'spk/list-mustcheck-links
  "ods" 'denote-signature
  "oei" 'denote-explore-isolated-files
  "oew" 'denote-explore-random-keyword
  "oer" 'denote-explore-rename-keyword
  "oed" 'denote-explore-missing-links)


(provide 'init-denote)
