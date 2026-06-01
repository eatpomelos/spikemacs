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

;; 设置插入denote链接时仅显示标题，避免signature被修改
(setq denote-link-description-format "%T")

(setq spk-note-dir (concat spk-doc-dir "spk-notes/")
      denote-directory (concat spk-note-dir "denote/")
      spk-denote-index-directory (concat denote-directory "index/")
      denote-journal-directory (concat spk-note-dir "denote-journal/")
      spk-denote-notes-directory (concat denote-directory "notes/")
      spk-denote-work-directory (concat denote-directory "works/")
      spk-denote-reading-directory (concat denote-directory "reading/")
      spk-denote-ref-file-directory (concat spk-note-dir "ref_File/")
      )

(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)

;; 覆盖基于修改事件的排序函数，什么都不干，避免插入链接时较慢，主要通过关键字来查找
(with-eval-after-load 'denote
  (defun spk/denote-sort-bypass-dummy (_file-a _file-b) nil)
  (advice-add 'denote-sort-modified-time-greaterp :override #'spk/denote-sort-bypass-dummy))

(add-hook 'markdown-mode-hook #'denote-fontify-links-mode)
(add-hook 'text-mode-hook #'denote-fontify-links-mode)
;; 不忽略org-mode 的 fontiffy-links-mode
(add-hook 'org-mode-hook #'denote-fontify-links-mode)

(defvar-local spk--denote-last-keywords nil 
  "存储当前缓冲区最后一次添加的 Denote 高亮关键字。")

(defun spk/dired-denote-status-colors ()
  (require 'denote)
  ;; 清除旧规则
  (when spk--denote-last-keywords
    (font-lock-remove-keywords nil spk--denote-last-keywords))
  
  (let ((keywords 
         `((,(concat denote-date-identifier-regexp ".*\\(?1:_mustcheck\\).*") (0 'error t))
           (,(concat denote-date-identifier-regexp ".*\\(?1:_incubating\\).*") (0 'error t))
           (,(concat denote-date-identifier-regexp ".*\\(?1:_permanent\\).*") (0 'success t))
           (,(concat denote-date-identifier-regexp ".*\\(?1:_archived\\).*")  (0 'shadow t)))))
    (setq spk--denote-last-keywords keywords)
    (font-lock-add-keywords nil keywords)
    ;; 触发重新渲染
    (font-lock-flush)))

(add-hook 'dired-mode-hook #'spk/dired-denote-status-colors)
(add-hook 'dired-after-readin-hook #'font-lock-flush)

(setq denote-save-buffers nil)

;; 属性层：强调知识属性与思考深度
(setq spk-denote-class-keywords 
      '(("logic"      . "原理推导 (Why)")
        ("concept"    . "概念内化 (What/Nature)")
        ("sop"        . "实战手册 (How)")
        ("wiki"       . "某个实现的记录")
        ("example"    . "代码用例")
        ("project"    . "工程项目相关")
        ("literature" . "文献输入")
        ("idea"       . "灵感闪念")
        ("index"      . "索引地图")))

;; 状态层：强调生命周期与完备程度
(setq spk-denote-state-keywords 
      '(("mustcheck"   . "待处理 (最高优先级)")
        ("incubating"  . "完善中")
        ("permanent"   . "已定型 (永久资产)")
        ("archived"    . "已归档 (历史参考)")))

(defconst spk-all-known-keywords (append spk-denote-class-keywords spk-denote-state-keywords))
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
        ("works"        ?w ,spk-denote-work-directory)
        ("reading"      ?r ,spk-denote-reading-directory)
        ))

(defun spk/denote-toggle-keyword (target &optional mutex)
  "快速开关当前文件的关键字标签。
TARGET 可以是 ((\"keyword\" . \"说明\")) 格式的 alist。"
  (interactive)
  (let* ((file (or (buffer-file-name)
                   (dired-get-filename nil t))))
    (unless (and file (file-exists-p file) (denote-file-has-identifier-p file))
      (user-error "无效操作：当前文件不是有效的 Denote 笔记"))
    
    (let* ((current-kw (denote-extract-keywords-from-path file))
           (candidates (or target spk-denote-class-keywords))
           (actual-target 
            (spk/completing-read "Select state tag: " candidates))
           (is-adding (not (member actual-target current-kw)))
           (actual-current-kw
            (if mutex
                (cl-remove-if (lambda (k) 
                                (member k (if (and (listp candidates) (listp (car candidates)))
                                              (mapcar #'car candidates)
                                            (if (listp target) target (list target)))))
                              current-kw)
              current-kw))
           (total-current-kw
            (if is-adding
                (cons actual-target actual-current-kw)
              (remove actual-target actual-current-kw)))
           (denote-rename-confirmations nil)
           (denote-save-buffers t)
           (denote-after-rename-file-hook nil))
        
      (setq total-current-kw (sort (delete-dups total-current-kw) #'string<))
      (denote-rename-file file 'keep-current total-current-kw 'keep-current 'keep-current 'keep-current)
        
      (when (derived-mode-p 'dired-mode)
        (dired-revert))

      (message "Keyword '%s' %s. (Current: %s)" 
               actual-target
               (if is-adding "Added" "Removed")
               (mapconcat #'identity total-current-kw ", ")))))

;; 快速移除mustcheck
(defun spk/denote-toggle-card-state ()
  (interactive)
  (spk/denote-toggle-keyword spk-denote-state-keywords t))

;; 快速修改卡片类别
(defun spk/denote-toggle-card-class ()
  (interactive)
  (spk/denote-toggle-keyword spk-denote-class-keywords t))

(defun spk/denote-toggle-buffer-keyword ()
  "从当前 Denote 笔记已有的标签中选择一个进行 toggle 操作。"
  (interactive)
  (when-let* ((file (buffer-file-name))
              ((denote-file-has-identifier-p file)))
      (spk/denote-toggle-keyword (denote-extract-keywords-from-path file))
      ))

;; 获取当天的denote-journal 文件，这里和原始的用法不同，默认认为一天只会有一个journal文件
(defun spk/find-today-journal-denote-entry ()
  "获取今天的日记（增强过滤版）。"
  (interactive)
  (let* ((today-regexp (denote-journal--filename-date-regexp (current-time)))
         ;; 获取所有匹配的文件名
         (all-files (directory-files denote-journal-directory t today-regexp t))
         ;; 过滤：必须是文件，且不能是目录
         (files (seq-filter (lambda (f) (and (file-regular-p f) 
                                             (not (file-directory-p f)))) 
                            all-files))
         ;;  当 files 有内容时才弹出选择框
         (file (when files (denote-journal-select-file-prompt files))))
    
    (if (and file (file-exists-p file) (not (file-directory-p file)))
        ;; 找到了文件且不是目录，跳转
        (let ((buf (get-file-buffer file)))
          (if buf
              (switch-to-buffer buf)
            (find-file file)))
      ;; 没找到文件，或者 file 为空，创建新条目
      (message "今日无日记或路径无效，准备创建新条目...")
      (denote-journal-new-entry))))

;; 定义查找journal的函数
(defun spk/consult-find-journal-denote-entry ()
  (interactive)
  (let ((file (read-file-name "Journal: " denote-journal-directory)))
    (when (fboundp 'find-file)
      (find-file file))))

(defun spk/list-cards-keyword (keyword)
  "列出当前denote卡片中带keyword关键字的卡片"
  (let* ((files (denote-directory-files))
         (matched-files (seq-filter
                           (lambda (file)
                             (string-match-p (format "__.*%s" keyword) file))
                           files))
         (grouped-files (seq-group-by (lambda (f)
                                        (file-name-nondirectory
                                         (directory-file-name (file-name-directory f))))
                                      matched-files)))
    (with-current-buffer (get-buffer-create (format "*Denote %s*" keyword))
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (make-string 30 ?=) "\n")
        (insert (format "*TOTAL %s: %d*\n" (upcase keyword) (length matched-files)))
        (insert (make-string 30 ?=) "\n")

        (if (null matched-files)
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
        (evil-local-set-key 'normal "q" #'quit-window)
        (evil-local-set-key 'normal "g" #'(lambda () (interactive)
                                            (spk/list-cards-keyword keyword)))
        (goto-char (point-min))
        (show-all)
        (pop-to-buffer (current-buffer))
        (setq buffer-read-only t)
        (message (format "%s: %d items." keyword (length matched-files)))))))

(defun spk/list-mustcheck-cards ()
  "列出当前denote卡片中被标记为mustcheck的卡片"
  (interactive)
  (spk/list-cards-keyword "mustcheck")
  )

(defun spk/list-incubating-cards ()
  "列出当前denote卡片中被标记为mustcheck的卡片"
  (interactive)
  (spk/list-cards-keyword "incubating"))

(defun spk/list-keyword-cards ()
  (interactive)
  (spk/list-cards-keyword
   (spk/completing-read "Input a keyword: " spk-all-known-keywords)))

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

(defvar spk-rest-timer nil
  "由于存储休息定时器")

(defvar spk-rest-note nil
  "由于存储休息备注")

;; 设置一个定时器，在特定时间后显示信息，提醒回归正常工作
(defun spk/denote-tiny-rest (note min)
  "设置一个简易的番茄钟，用于提醒自己"
  (interactive "srest for a while: \nnAfter(min): \n")
  ;; 如果已经有一个定时器在跑，先取消它
  (when (timerp spk-rest-timer)
    (cancel-timer spk-rest-timer)
    (setq spk-rest-timer nil)
    (message (format "已取消定时器: \"%s\"。" spk-rest-note)))
  
  (if (and  (> min 0) (<= min 60))
      (progn
        (setq spk-rest-note note)
        (setq spk-rest-timer
              (run-with-timer
               (* min 60) nil
               (lambda ()
                 (let ((old-bulletin spk-bulletin-tmp-ctx))
                   (spk/set-pos-buf-ctx (format "⏰ %s finished!!!\n" spk-rest-note))
                   ;; 用阻塞模式显示，强行显示10秒
                   (spk/bulletin-peek t)
                   (when old-bulletin
                     (spk/set-pos-buf-ctx old-bulletin))
                   (spk/reset-pos-buf-ctx)
                   ;; 任务完成后清理变量
                   (setq spk-rest-timer nil)
                   (setq spk-rest-note nil)
                   )))))
    (message "Valid time:%d min input 0 < time <= 60.\n" min))
  )

(defun spk/cancel-rest-timer ()
  "手动取消当前的提醒任务。"
  (interactive)
  (if (timerp spk-rest-timer)
      (progn
        (cancel-timer spk-rest-timer)
        (setq spk-rest-timer nil)
        (message (format "提醒: \"%s\" 已提前取消。" spk-rest-note)))
    (message "当前没有运行中的提醒任务。")))

(global-set-key (kbd "C-c b") 'consult-buffer)
(global-set-key (kbd "C-c z z") 'spk/denote-tiny-rest)
(global-set-key (kbd "C-c z q") 'spk/cancel-rest-timer)

;; 设置denote 快捷键，常用的快捷键需要配置一下
(global-set-key (kbd "C-c n j") 'spk/open-link-at-point)
(global-set-key (kbd "C-c n f") 'consult-notes)
(global-set-key (kbd "C-c n i") 'denote-insert-link)
(global-set-key (kbd "C-c n o") 'spk/list-mustcheck-cards)
(global-set-key (kbd "C-c n g") 'spk/list-incubating-cards)
(global-set-key (kbd "C-c n k") 'spk/list-keyword-cards)
(global-set-key (kbd "C-c n d") 'spk/consult-find-journal-denote-entry)
(global-set-key (kbd "C-c n n") 'denote)
(global-set-key (kbd "C-c n l") 'spk/org-insert-ref-file)
(global-set-key (kbd "C-c n q") 'spk/denote-find-ref-file)
(global-set-key (kbd "C-c n r") 'denote-find-backlink)
(global-set-key (kbd "C-c n t") 'spk/denote-toggle-card-state)
(global-set-key (kbd "C-c n c") 'spk/denote-toggle-card-class)
(global-set-key (kbd "C-c n a") 'spk/denote-toggle-buffer-keyword)

(evil-leader/set-key
  "oo" 'spk/list-mustcheck-cards
  "og" 'spk/list-incubating-cards
  "ok" 'spk/list-keyword-cards
  "of" 'consult-notes
  "os" 'consult-notes-search-in-all-notes
  "ob" 'denote-find-backlink
  "or" 'denote-find-link
  "oi" 'denote-insert-link
  "ol" 'spk/org-insert-ref-file
  "ot" 'spk/denote-toggle-card-state
  "oc" 'spk/denote-toggle-card-class
  "oa" 'spk/denote-toggle-buffer-keyword
  "oq" 'spk/denote-find-ref-file
  "oj" 'spk/open-link-at-point
  "odd" 'spk/consult-find-journal-denote-entry
  "odt" 'spk/find-today-journal-denote-entry
  "onn" 'denote
  "onr" 'denote-region
  "ons" 'denote-signature
  "oei" 'denote-explore-isolated-files
  "oew" 'denote-explore-random-keyword
  "oer" 'denote-explore-rename-keyword
  "oed" 'denote-explore-missing-links
  "ozz" 'spk/denote-tiny-rest
  "ozq" 'spk/create-cache-from-dir
  )

(provide 'init-denote)
