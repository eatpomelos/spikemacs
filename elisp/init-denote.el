;; -*- lexical-binding: t; -*-
(straight-use-package 'denote)
(straight-use-package 'denote-journal)
(straight-use-package 'consult-notes)

(require 'denote)
(require 'denote-journal)
(require 'consult-notes)
;; 安装denote，用denote来管理笔记系统
;; 临时设者一个目录用于测试denote的基本功能

(setq spk-denote-dir (concat spk-doc-dir "denote/")
      denote-directory spk-denote-dir
      denote-journal-directory (concat denote-directory "journal/")
      spk-denote-notes-directory (concat denote-directory "notes/")
      )

(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)

;; https://github.com/mclear-tools/consult-noteus
(setq consult-notes-sources
      `(
        ("notes"    ?n ,spk-denote-notes-directory)
        ("journal"  ?j ,denote-journal-directory)
        ))
(provide 'init-denote)
