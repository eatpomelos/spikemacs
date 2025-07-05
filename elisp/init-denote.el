;; -*- lexical-binding: t; -*-
(straight-use-package 'denote)
(straight-use-package 'denote-journal)
(straight-use-package 'consult-notes)

(require 'denote)
(require 'denote-journal)
(require 'consult-notes)
;; 安装denote，用denote来管理笔记系统
;; 临时设者一个目录用于测试denote的基本功能

(setq denote-directory "~/spk-tmp")
(setq denote-journal-directory "~/spk-tmp/journal")

(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)

;; https://github.com/mclear-tools/consult-noteus
(setq consult-notes-sources
      '(
        ("notes"    ?o "~/spk-tmp")
        ("journal"  ?j "~/spk-tmp/journal")
        ))
(provide 'init-denote)
