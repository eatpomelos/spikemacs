;; 放自己的org配置

;; 设置.txt为后缀的文件用org-mode打开
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))

;; 设置一下自己的任务管理的一些简单的配置,要是想放弃一个任务的时候，要进行说明，以后可能会再次启用这个任务
;; (setq org-todo-keywords '((sequence "TODO(t)" "DOING(i)" "PAUSE(p@)" "|" "DONE(d)" "ABORT(a@/!)")))
;; (setq org-todo-keyword-faces '(("TODO" . "red")
;;                                ("DOING" . "yellow")
;;                                ("DONE" . "green")
;;                                ("ABORT" . "blue")
;;                                ("PAUSE" . "cyan1")))

;; 设置几个常用的capture 的文件的路径
(defvar spk-org-directory "~/org/"
  "Default directory of org files"
  )

;; 设置笔记中用到的一些路径，包括日志路径、笔记路径，以及待办项目路径
(setq +org-capture-todo-file (expand-file-name "todo.org" spk-org-directory )
      +org-capture-journal-file (expand-file-name "journal.org" spk-org-directory )
      +org-capture-notes-file (expand-file-name "notes.org" spk-org-directory )
      )

;; (use-package! org-pomodoro
;;   :if (with-eval-after-load 'org-agenda)
;;   :config
;;   (define-key org-agenda-mode-map (kbd "C-p") 'org-pomodoro))

;; 重新定义org-capture的模板，主要是因为之前ｄｏｏｍ默认的模板不能直接插入ｔａｇ不方便后续进行检索
;; 在ｄｏｏｍ原来的设置中有一个比较好的做法是，在项目的文件中会直接生成一个ｔｏｄｏ文件而不是直接和其他的放在一起
;; 这里可以参考原来的设置，将一些需要自动加上ｔａｇ的加上ｔａｇ

;; 后续提高速度可以用eval-after-load来控制
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline +org-capture-todo-file "Workspace")
         "* TODO [#B] %?\n  %i\n %U"
         :empty-lines 1)
        ("n" "notes" entry (file+headline +org-capture-notes-file "Quick notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("e" "Emacs notes" entry (file+headline +org-capture-notes-file "Emacs notes")
         "* %?\n %i\n %U"
         :empty-lines 1)
        ("i" "Ideas" entry (file+headline +org-capture-notes-file "Ideas")
         "* %?\n %i\n %U")
        ("w" "work" entry (file+headline +org-capture-todo-file "Work")
         "* TODO [#A] %?\n %i\n %U"
         :empty-lines 1)
        ("l" "links" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n %i\n %a \n %U"
         :empty-lines 1)
        ("j" "Journal Entry"
         entry (file+olp+datetree +org-capture-journal-file)
         "* %U %? \n%i\n%a"
         :prepend t)

        ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
        ;; {todo,notes,changelog}.org file is found in a parent directory.
        ;; Uses the basename from `+org-capture-todo-file',
        ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
        ("p" "Templates for projects")
        ("pt" "Project-local todo" entry ; {project-root}/todo.org
         (file+headline +org-capture-project-todo-file "Inbox")
         "* TODO %?\n%i\n%a" :prepend t)
        ("pn" "Project-local notes" entry ; {project-root}/notes.org
         (file+headline +org-capture-project-notes-file "Inbox")
         "* %U %?\n%i\n%a" :prepend t)
        ("pc" "Project-local changelog" entry ; {project-root}/changelog.org
         (file+headline +org-capture-project-changelog-file "Unreleased")
         "* %U %?\n%i\n%a" :prepend t)

        ;; Will use {org-directory}/{+org-capture-projects-file} and store
        ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
        ;; support `:parents' to specify what headings to put them under, e.g.
        ;; :parents ("Projects")
        ("o" "Centralized templates for projects")
        ("ot" "Project todo" entry
         (function +org-capture-central-project-todo-file)
         "* TODO %?\n %i\n %a"
         :heading "Tasks"
         :prepend nil)
        ("on" "Project notes" entry
         (function +org-capture-central-project-notes-file)
         "* %U %?\n %i\n %a"
         :heading "Notes"
         :prepend t)
        ("oc" "Project changelog" entry
         (function +org-capture-central-project-changelog-file)
         "* %U %?\n %i\n %a"
         :heading "Changelog"
         :prepend t)
        ))
;; 在org中运行一些其他语言的程序，暂时设置一个快捷键，之后会再次进行更改
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lisp . t)
;;    (C . t)
;;    (perl . t)
;;    (shell . t)
;;    (latex . t)
;;    (python . t)
;;    (js . t)
;;    ))


(provide 'init-org)
