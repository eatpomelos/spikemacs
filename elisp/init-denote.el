;; -*- lexical-binding: t; -*-
(straight-use-package 'denote)
(straight-use-package 'denote-journal)
(straight-use-package 'denote-journal-capture)
(straight-use-package 'consult-notes)

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
      spk-denote-work-directory (concat denote-directory "work/")
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
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-excluded-directories-regexp nil)
(setq denote-excluded-keywords-regexp nil)
(setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
;; 添加子目录选项，添加笔记时候，指定添加的目录
(setq denote-prompts '(title keywords signature subdirectory))

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
        ("work"         ?w ,spk-denote-work-directory)
        ("reading"      ?r ,spk-denote-reading-directory)
        ))

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

;; 定义一个函数，实现打开当前光标下的链接功能
(defun spk/open-link-at-point ()
  "Open link at point."
  (interactive)
  (let* ((url (thing-at-point 'url))
         )
    (cond
     ((get-text-property (point) 'denote-link-query-part)
      (denote-link-open-at-point))
     (url
      (if (and (eq major-mode 'org-mode) (string-match-p "^file:" url))
          (org-open-at-point)
        (if (commandp 'eaf-open)
            (eaf-open-url-at-point)
          (eww url)
          )))
     ((eq major-mode 'org-mode)
      (org-open-at-point))
     (t (message "Can not open link at point.")))
    )
  )

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
                                         (concat spk-scripts-dir "update_file_cache")
                                         (expand-file-name spk-denote-ref-file-directory)
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
(global-set-key (kbd "C-c ndn") 'denote-journal-new-entry)
(global-set-key (kbd "C-c ndt") 'spk/find-today-journal-denote-entry)
(global-set-key (kbd "C-c n n") 'denote)
(global-set-key (kbd "C-c n l") 'spk/org-insert-ref-file)
(global-set-key (kbd "C-c n q") 'spk/denote-find-ref-file)
(global-set-key (kbd "C-c n r") 'denote-find-backlink)

(evil-leader/set-key
  ;; org-roam 的快捷键，笔记迁移完成后删除
  "oo" 'org-roam-node-find
  "of" 'consult-notes
  "os" 'consult-notes-search-in-all-notes
  "ob" 'denote-find-backlink
  "or" 'denote-find-link
  "oi" 'denote-insert-link
  "ol" 'spk/org-insert-ref-file
  "oq" 'spk/denote-find-ref-file
  "oj" 'spk/open-link-at-point
  "odt" 'spk/find-today-journal-denote-entry
  "odn" 'denote-journal-new-entry
  "odd" 'denote
  "odr" 'denote-region
  "ods" 'denote-signature
  )

(provide 'init-denote)
