;; v2版本已经更新到主线，这里直接使用发布版本
(straight-use-package 'org-roam)
;; (straight-use-package 'org-roam-server)
;; 设置org-roam的补全
(straight-use-package 'company-org-roam)
(straight-use-package 'org-roam-bibtex)
 
(straight-use-package
 '(org-roam-ui
   :type git
   :host github
   :repo "org-roam/org-roam-ui"
   ))

;; 先直接打开
;; (autoload #'org-roam-find-file "org-roam")
;; (autoload #'org-roam-server-mode "org-roam-server")

;; org-roam config
;; 配置org-roam 的模板，自动插入到文件中
;; (setq org-roam-capture-templates)

(setq
 org-roam-directory (concat user-emacs-directory "docs/")
 org-roam-db-location (concat spk-org-directory "org-roam.db")
 org-roam-tag-sources '(prop vanilla)
 org-roam-v2-ack t
 )

;; 后面使用org-roam-caputure的方式来进行记录，使用agenda来记录和安排重要工作
(global-set-key (kbd "C-c r") 'org-roam-capture)
(global-set-key (kbd "C-c d") 'org-roam-dailies-capture-date)
(global-set-key (kbd "C-c t") 'org-roam-dailies-capture-today)
(global-set-key (kbd "C-c n") 'org-roam-dailies-capture-tomorrow)
(global-set-key (kbd "C-c y") 'org-roam-dailies-capture-yesterday)


;; org-roam也可以用来处理日记，有时间可以了解一下
(evil-leader/set-key
  "of" 'org-roam-node-find
  ;; 暂不清楚ref在新版的org-roam中是怎么使用的
  "or" 'org-roam-ref-find
  )

;; https://www.zmonster.me/2020/06/27/org-roam-introduction.html
;; 设置笔记的模板，之后可以使用capture来新增笔记，将自己日常会写的笔记进行分类，设置不同模板
(setq org-roam-capture-templates
      '(("d" "default" plain "%?" 
         :if-new (file+head "${slug}.org" "#+title: ${title}\n#+date: %T\n#+filetags: ")
         :unnarrowed t
         :empty-lines 1)
        ("t" "Term" plain
         "- 领域: %^{术语所属领域}\n- 名词:%?\n- 释义:n- 参考链接:"
         :if-new (file+head "spk-Wiki.org" "#+title: ${title}\n#+filetags: Term English\n")
         :unnarrowed nil
         :empty-lines 1
         )

        ("s" "Solve" plain
         "- 问题描述: %?\n- 解决方案:%?\n- 定位过程:\n- 参考链接:"
         :if-new (file+head "${slug}.org" "#+title: ${title}\n#+filetags: issue \n")
         :unnarrowed nil
         :empty-lines 1
         )

        ;; 需要注意的是，这里的笔记可能会作为一个文件来进行整理。而阅读相关的笔记则是可以整理成多个文件，也可以整理成一个文件
        ;; 这里的plain实际支持5种类型，但是在org-roam中都是一样的，这里一律设置为plain，另外测试发现这里设置entry会有问题
        ("n" "notes")
        ("nr" "Reading notes" plain
         "%?"
         :if-new (file+head "${slug}.org" "#+title: ${title}\n#+date: %T\n#+filetags: Reading\n")
         )
        ("no" "Output documents" plain
         "%?"
         :if-new (file+head "${slug}.org" "#+title: ${title}\n#+date: %T\n#+filetags: documents\n")
         )
        ))

;; 日常模板暂时没有好的想法，先不设置,使用默认模板

;; (setq org-roam-capture-templates
;;       '(
;;         ("d" "default" plain (function org-roam-capture--get-point)
;;          "%?"
;;          :file-name "%<%Y%m%d%H%M%S>-${slug}"
;;          :head "#+title: ${title}\n#+roam_alias:\n\n")
;;         ("g" "group")
;;         ("ga" "Group A" plain (function org-roam-capture--get-point)
;;          "%?"
;;          :file-name "%<%Y%m%d%H%M%S>-${slug}"
;;          :head "#+title: ${title}\n#+roam_alias:\n\n")
;;         ("gb" "Group B" plain (function org-roam-capture--get-point)
;;          "%?"
;;          :file-name "%<%Y%m%d%H%M%S>-${slug}"
;;          :head "#+title: ${title}\n#+roam_alias:\n\n")))

;; 使用org-roam-bibtex扩展
(with-eval-after-load 'org-roam
  (require 'org-ref)
  (require 'org-roam-ui)

  (require 'websocket)
  (require 'simple-httpd)
  
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t)
  (org-roam-setup)
  )

(provide 'init-org-roam)
