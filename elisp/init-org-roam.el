(straight-use-package 'org-roam-server)

;; v2版本的org-roam 支持headline的引用
(straight-use-package
 '(org-roam :type git
			:host github
			:repo "org-roam/org-roam"
			;; :branch "v2"
			))

(autoload #'org-roam-find-file "org-roam")
(autoload #'org-roam-server-mode "org-roam-server")

;; org-roam config
;; 配置org-roam 的模板，自动插入到文件中
;; (setq org-roam-capture-templates)

(setq
 org-roam-directory (concat spk-local-notes-dir "roam/")
 org-roam-db-location (concat spk-org-directory "org-roam.db")
 org-roam-rename-file-on-title-change nil
 org-roam-tag-sources '(prop vanilla)
 )

(evil-leader/set-key
  "of" 'org-roam-find-file
  "or" 'org-roam-find-ref
  "od" 'org-roam-find-directory
  "og" 'org-roam-graph
  "oi" 'org-roam-insert
  "oI" 'org-roam-insert-immediate)

(setq org-roam-server-host "127.0.0.1"
      org-roam-server-port 9090
      org-roam-server-export-inline-images t
      org-roam-server-authenticate nil
      org-roam-server-network-label-truncate t
      org-roam-server-network-label-truncate-length 60
      org-roam-server-network-label-wrap-length 20)

(with-eval-after-load 'org-roam
  (require 'org-roam-server))

(provide 'init-org-roam)
