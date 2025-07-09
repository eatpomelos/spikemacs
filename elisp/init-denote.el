;; -*- lexical-binding: t; -*-
(straight-use-package 'denote)
(straight-use-package 'denote-journal)
(straight-use-package 'denote-journal-capture)
(straight-use-package 'consult-notes)

(require 'denote)
(require 'denote-journal)
(require 'denote-journal-capture)
(require 'consult-notes)
;; 安装denote，用denote来管理笔记系统
;; 临时设者一个目录用于测试denote的基本功能

(setq spk-denote-dir (concat spk-doc-dir "denote/")
      denote-directory spk-denote-dir
      denote-journal-directory (concat denote-directory "journal/")
      spk-denote-notes-directory (concat denote-directory "notes/")
      )

(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)


(add-hook 'markdown-mode-hook #'denote-fontify-links-mode)
(add-hook 'text-mode-hook #'denote-fontify-links-mode)
;; 不忽略org-mode 的 fontiffy-links-mode
(add-hook 'org-mode-hook #'denote-fontify-links-mode)

(setq denote-save-buffers nil)
;; 常用的关键字，这里需要仔细配置一下
(setq denote-known-keywords '("emacs" "linux" "work" "economics"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-prompts '(title keywords))
(setq denote-excluded-directories-regexp nil)
(setq denote-excluded-keywords-regexp nil)
(setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))

;; Pick dates, where relevant, with Org's advanced interface:
(setq denote-date-prompt-use-org-read-date t)

;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
(denote-rename-buffer-mode 1)
(consult-notes-denote-mode 1)

;; https://github.com/mclear-tools/consult-noteus
(setq consult-notes-sources
      `(
        ("denote"   ?d ,denote-directory)
        ("notes"    ?n ,spk-denote-notes-directory)
        ("journal"  ?j ,denote-journal-directory)
        ))

;; 获取当天的denote-journal 文件，这里和原始的用法不同，默认认为一天只会有一个journal文件
(defun spk/find-today-journal-denote-entry ()
  "Get today denote journal entry."
  (interactive)
  (make-local-variable 'denote-directory)
  (setq denote-directory denote-journal-directory)
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

;; 在笔记未迁移完成前先保留org-roam 的配置
(require 'init-org-roam)

;; 设置denote 快捷键，常用的快捷键需要配置一下
(global-set-key (kbd "C-c n j") 'denote-link-open-at-point)
(global-set-key (kbd "C-c n f") 'consult-notes)
(global-set-key (kbd "C-c n i") 'denote-insert-link)
(global-set-key (kbd "C-c ndn") 'denote-journal-new-entry)
(global-set-key (kbd "C-c ndt") 'spk/find-today-journal-denote-entry)
(global-set-key (kbd "C-c n n") 'denote)
(global-set-key (kbd "C-c n r") 'denote-find-backlink)

(evil-leader/set-key
  ;; org-roam 的快捷键，笔记迁移完成后删除
  "oo" 'org-roam-node-find
  "of" 'consult-notes
  "os" 'consult-notes-search-in-all-notes
  "or" 'denote-find-backlink
  "oi" 'denote-insert-link
  "oj" 'denote-link-open-at-point
  "odt" 'spk/find-today-journal-denote-entry
  "odn" 'denote-journal-new-entry
  "odd" 'denote
  "odr" 'denote-region
  )

(provide 'init-denote)
