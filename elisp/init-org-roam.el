(straight-use-package 'org-roam)
;; (straight-use-package 'org-roam-server)
;; 设置org-roam的补全
(straight-use-package 'company-org-roam)
 
(straight-use-package
 '(org-roam-ui
   :type git
   :host github
   :repo "org-roam/org-roam-ui"
   ))

;; (autoload #'org-roam-server-mode "org-roam-server")
(setq
 org-roam-directory (concat user-emacs-directory "docs/roam")
 org-roam-db-location (concat spk-local-dir "org-roam.db")
 org-roam-tag-sources '(prop vanilla)
 org-roam-v2-ack t
 )

;; 后面使用org-roam-caputure的方式来进行记录，使用agenda来记录和安排重要工作
(global-set-key (kbd "C-c r") 'org-roam-capture)
(global-set-key (kbd "C-c d") 'org-roam-dailies-capture-date)
(global-set-key (kbd "C-c t") 'org-roam-dailies-capture-today)
(global-set-key (kbd "C-c n") 'org-roam-dailies-capture-tomorrow)
(global-set-key (kbd "C-c y") 'org-roam-dailies-capture-yesterday)

; org-roam也可以用来处理日记，有时间可以了解一下
(evil-leader/set-key
  "of" 'org-roam-node-find
  ;; 暂不清楚ref在新版的org-roam中是怎么使用的
  "or" 'org-roam-ref-find
  "odt" 'org-roam-dailies-goto-today
  "odd" 'org-roam-dailies-goto-date
  "odn" 'org-roam-dailies-goto-next-note
  "odp" 'org-roam-dailies-goto-previous-note
  )

;; https://www.zmonster.me/2020/06/27/org-roam-introduction.html
;; 设置笔记的模板，之后可以使用capture来新增笔记，将自己日常会写的笔记进行分类，设置不同模板
(setq org-roam-capture-templates
      '(("d" "default" plain "%?" 
         :if-new (file+head "${slug}.org" "# -*- coding: utf-8 -*-\n#+title: ${title}\n#+date: %T\n#+filetags: ")
         :unnarrowed t
         :empty-lines 1)
        ("t" "Term" plain
         "- 领域: %^{术语所属领域}\n- 名词:%?\n- 释义:\n- 参考链接:"
         :if-new (file+head "spk-Wiki.org" "# -*- coding: utf-8 -*-\n#+title: ${title}\n#+filetags: Term English\n")
         :unnarrowed nil
         :empty-lines 1
         )

        ("s" "Solve" plain
         "* 问题标题: %?\n- 解决方案:\n- 定位过程:\n- 参考链接:"
         :if-new (file+head "${slug}.org" "# -*- coding: utf-8 -*-\n#+title: ${title}\n#+filetags: issue \n")
         :unnarrowed nil
         :empty-lines 1
         )

        ;; 需要注意的是，这里的笔记可能会作为一个文件来进行整理。而阅读相关的笔记则是可以整理成多个文件，也可以整理成一个文件
        ;; 这里的plain实际支持5种类型，但是在org-roam中都是一样的，这里一律设置为plain，另外测试发现这里设置entry会有问题
        ("n" "notes")
        ("nr" "Reading notes" plain
         "%?"
         :if-new (file+head "${slug}.org" "# -*- coding: utf-8 -*-\n#+title: ${title}\n#+date: %T\n#+filetags: Reading\n")
         )
        ("no" "Output documents" plain
         "%?"
         :if-new (file+head "${slug}.org" "# -*- coding: utf-8 -*-\n#+title: ${title}\n#+date: %T\n#+filetags: documents\n")
         )
        ))

;; 设置日常笔记的模板，添加默认使用utf-8格式
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry "* %?" :target
        (file+head "%<%Y-%m-%d>.org" "# -*- coding: utf-8 -*-\n#+title: %<%Y-%m-%d>"))
       )
)


;; 这部分配置暂时用不到，页面的org-roam-ui暂时不能正常显示
(with-eval-after-load 'org-roam
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
