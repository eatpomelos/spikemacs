;; -*- lexical-binding: t; -*-
(straight-use-package 'org-roam)
 
(straight-use-package
 '(org-roam-ui
   :type git
   :host github
   :repo "org-roam/org-roam-ui"
   ))

;; (autoload #'org-roam-server-mode "org-roam-server")
(setq
 org-roam-directory (concat spk-note-dir "roam")
 org-roam-db-location (concat spk-local-dir "org-roam.db")
 org-roam-tag-sources '(prop vanilla)
 org-roam-v2-ack t
 )

(provide 'init-org-roam)
