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
(setq denote-known-keywords '("emacs" "philosophy" "politics" "economics"))
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

;; https://github.com/mclear-tools/consult-noteus
(setq consult-notes-sources
      `(
        ("notes"    ?n ,spk-denote-notes-directory)
        ("journal"  ?j ,denote-journal-directory)
        ))
(provide 'init-denote)
