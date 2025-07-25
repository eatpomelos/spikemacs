;; 和 org 相关的配置  -*- lexical-binding: t; -*-

;; 由于使用 strainght.el 升级 package 中 org 有一个变量的名字发生了改变，此处使用本地 org 包防止出现使用错误
(straight-use-package '(org :type built-in))
(straight-use-package 'org-pomodoro)
;; 增加 org 转换 srt 的插件
(straight-use-package 'ox-rst)
(straight-use-package 'markdown-mode)
(straight-use-package 'markdown-preview-mode)
;; (straight-use-package 'org)
;; 实现 org-mode 中表格的对齐
(straight-use-package 'valign)

(straight-use-package
 '(org-bars :type git
			:host github
			:repo "tonyaldon/org-bars"
			))

;; 默认在 markdown 文件中使用 org-mode
(add-to-list 'auto-mode-alist '("\\.md\\'" . org-mode))

;; 设置折叠时显示的符号
(when IS-LINUX
  (setq org-ellipsis "⤵"))
;; 设置一下自己的任务管理的一些简单的配置,要是想放弃一个任务的时候，要进行说明，以后可能会再次启用这个任务
(setq org-todo-keywords '((sequence "TODO(t)" "PENDING(i)" "PAUSE(p@)" "|" "DONE(d)" "ABORT(a@/!)")))
(setq org-todo-keyword-faces '(("PENDING" . error)
                               ("ABORT" . success)
                               ("PAUSE" . warning)))

(defvar spk-doc-dir "~/spk-docs/"
  "Default directory of document files."
  )

(defvar spk-org-directory
  (concat spk-doc-dir "org/")
  "Default directory of org files."
  )

;; 如果目录不存在则创建
(unless (file-exists-p spk-doc-dir)
  (make-directory spk-doc-dir)
  )
;; 设置自己的个人笔记目录
(defvar spk-local-notes-dir
  (concat spk-org-directory "notes/")
  "Local notes path.")

;; 设置org文件导出时的默认路径
(setq spk-org-report_dir (concat spk-local-dir "ox-report/"))

;; 设置 agenda 文件,注意以下这种写法，不加括号直接用字符串是不行的
(setq org-agenda-files '("~/spk-docs/org"
			             "~/spk-docs/org/notes"
                         "~/spk-docs/roam/daily"
                         "~/.emacs.d/.local/pravite"))

;; 设置笔记中用到的一些路径，包括日志路径、笔记路径，以及待办项目路径
(setq spk-capture-todo-file (expand-file-name "todo.org" spk-org-directory)
      spk-capture-journal-file (expand-file-name "journal.org" spk-org-directory)
      spk-capture-notes-file (expand-file-name "notes.org" spk-org-directory)
      ;; 用来存放一些工具的使用笔记，包括正则表达式等一些有用的语法，或者是其他工具软件的使用方法
      spk-notes-tools-file (expand-file-name "tools.org" spk-local-notes-dir)
      spk-notes-language-file (expand-file-name "languages.org" spk-local-notes-dir)
      spk-notes-reading-file (expand-file-name "reading.org" spk-local-notes-dir)
      spk-notes-tips-file (expand-file-name "tips.org" spk-local-notes-dir)
      )

;; 后续提高速度可以用 eval-after-load 来控制
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline spk-capture-todo-file "Workspace")
         "* TODO [#B] %?\n  %i\n %U"
         :empty-lines 1)
        ("i" "Ideas" entry (file+headline spk-capture-notes-file "Ideas")
         "* %?\n %i\n %U")
        ("w" "work" entry (file+headline spk-capture-todo-file "Work")
         "* TODO [#A] %?\n %i\n %U"
         :empty-lines 1)
        ("l" "links" entry (file+headline spk-capture-notes-file "Quick notes")
         "* TODO [#C] %?\n %i\n %a \n %U"
         :empty-lines 1)
	("s" "suggestions" entry (file+headline spk-notes-tips-file "Tips")
         "* %?\n %i\n \n %U")
        ("j" "Journal Entry"
         entry (file+olp+datetree spk-capture-journal-file)
         "* %U %? \n%i\n%a"
         :prepend t)
	;; 用于保存本地笔记的模板
	("n" "Templates for local notes")
	("nq" "Quick notes" entry (file+headline spk-capture-notes-file "Quick notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("ne" "Emacs notes" entry (file+headline spk-capture-notes-file "Emacs notes")
         "* %?\n %i\n %U"
         :empty-lines 1)
	("nr" "Reading notes" entry (file+headline spk-notes-reading-file "Reading notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("nt" "Tools notes" entry (file+headline spk-notes-tools-file "Tools notes")
         "* %?\n %i\n %U"
         :empty-lines 1) 
        ("nl" "Language notes" entry (file+headline spk-notes-language-file "Languages notes")
         "* %?\n %i\n %U"
         :empty-lines 1)))

;; 下面使用的是别人提供的模板，主要是 latex 中使用的一些东西
;;org-export latex
(require 'ox-latex)
(setq org-alphabetical-lists t)
  ;;(setq org-latex-to-pdf-process (list "latexmk -pdf %f"))
  ;;(require 'ox-bibtex)

;; 在 windows 上命令不统一，导致下面的 rm 命令无法执行，从而会保留一部分中间文件
(when IS-LINUX
    (setq org-latex-pdf-process
	  '("xelatex -interaction nonstopmode %f"
	    "bibtex %b"
	    "xelatex -interaction nonstopmode %f"
	    "xelatex -interaction nonstopmode %f"
	    "rm -fr %b.out %b.log %b.tex %b.brf %b.bbl auto"
	    )))

;; 由于 windows 上的命令和 linux 不一致需要设置进行区分
(when IS-WINDOWS
  (setq org-latex-pdf-process
	'("xelatex -interaction nonstopmode %f"
	  "bibtex %b"
	  "xelatex -interaction nonstopmode %f"
	  "xelatex -interaction nonstopmode %f"
	  "del %b.out %b.log %b.tex %b.brf %b.bbl auto"
	  )))

(setq org-latex-compiler "xelatex")

(add-to-list 'org-latex-classes
	       '("org-dissertation"
		 "\\documentclass[UTF8,twoside,a4paper,12pt,openright]{ctexrep}
                \\setcounter{secnumdepth}{4}
                \\usepackage[linkcolor=blue,citecolor=blue,backref=page]{hyperref}
                \\hypersetup{hidelinks}
                \\usepackage{xeCJK}
                \\usepackage{fontspec}
                \\setCJKmainfont{SimSun}
                \\setCJKmonofont{SimSun}
                \\setCJKfamilyfont{kaiti}{KaiTi}
                \\newcommand{\\KaiTi}{\\CJKfamily{kaiti}}
                \\setmainfont{Times New Roman}
                \\usepackage[namelimits]{amsmath}
                \\usepackage{amssymb}
                \\usepackage{mathrsfs}
                \\newcommand{\\chuhao}{\\fontsize{42.2pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaochu}{\\fontsize{36.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\yihao}{\\fontsize{26.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoyi}{\\fontsize{24.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\erhao}{\\fontsize{22.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoer}{\\fontsize{18.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sanhao}{\\fontsize{16.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosan}{\\fontsize{15.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sihao}{\\fontsize{14.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosi}{\\fontsize{12.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\wuhao}{\\fontsize{10.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaowu}{\\fontsize{9.0pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\liuhao}{\\fontsize{7.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoliu}{\\fontsize{6.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\qihao}{\\fontsize{5.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\bahao}{\\fontsize{5.0pt}{\\baselineskip}\\selectfont}
                \\usepackage{color}
                \\usepackage{geometry}
                \\geometry{top=2cm,bottom=2cm,right=2cm,left=2.5cm}
                \\geometry{headsep=0.5cm}
                \\usepackage{setspace}
                \\setlength{\\baselineskip}{22pt}
                \\setlength{\\parskip}{0pt}
                \\usepackage{enumerate}
                \\usepackage{enumitem}
                \\setenumerate[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setitemize[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setdescription{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\usepackage{fancyhdr}
	              \\pagestyle{fancy}
	              \\fancyhead{}
	              \\fancyhead[CE]{\\KaiTi \\wuhao xxxx}
	              \\fancyhead[CO]{\\KaiTi \\wuhao xxxxxx}
	              \\fancypagestyle{plain}{\\pagestyle{fancy}}
                \\ctexset{contentsname=\\heiti{目{\\quad}录}}
                \\ctexset{section={format=\\raggedright}}
                \\usepackage{titlesec}
	              \\titleformat{\\chapter}[block]{\\normalfont\\xiaoer\\bfseries\\centering\\heiti}{第{\\zhnumber{\\thechapter}}章}{10pt}{\\xiaoer}
	              \\titleformat{\\section}[block]{\\normalfont\\xiaosan\\bfseries\\heiti}{\\thesection}{10pt}{\\xiaosan}
	              \\titleformat{\\subsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsection}{10pt}{\\sihao}
	              \\titleformat{\\subsubsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsubsection}{10pt}{\\sihao}
	              \\titlespacing{\\chapter} {0pt}{-22pt}{0pt}{}
	              \\titlespacing{\\section} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsection} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsubsection} {0pt}{0pt}{0pt}
                \\usepackage[super,square,numbers,sort&compress]{natbib}
                \\usepackage{graphicx}
                \\usepackage{subfigure}
                \\usepackage{caption}
                \\captionsetup{font={small}}
                [NO-DEFAULT-PACKAGES]
                [NO-PACKAGES]
                [EXTRA]"
                ("\\chapter{%s}" . "\\chapter*{%s}")
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(add-to-list 'org-latex-classes
	       '("org-article"
		 "\\documentclass[UTF8,twoside,a4paper,12pt,openright]{ctexart}
                \\setcounter{secnumdepth}{4}
                \\usepackage[linkcolor=blue,citecolor=blue,backref=page]{hyperref}
                \\hypersetup{hidelinks}
                \\usepackage{xeCJK}
                \\usepackage{fontspec}
                \\setCJKmainfont{SimSun}
                \\setCJKmonofont{SimSun}
                \\setCJKfamilyfont{kaiti}{KaiTi}
                \\newcommand{\\KaiTi}{\\CJKfamily{kaiti}}
                \\setmainfont{Times New Roman}
                \\usepackage[namelimits]{amsmath}
                \\usepackage{amssymb}
                \\usepackage{mathrsfs}
                \\newcommand{\\chuhao}{\\fontsize{42.2pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaochu}{\\fontsize{36.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\yihao}{\\fontsize{26.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoyi}{\\fontsize{24.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\erhao}{\\fontsize{22.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoer}{\\fontsize{18.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sanhao}{\\fontsize{16.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosan}{\\fontsize{15.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sihao}{\\fontsize{14.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosi}{\\fontsize{12.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\wuhao}{\\fontsize{10.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaowu}{\\fontsize{9.0pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\liuhao}{\\fontsize{7.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoliu}{\\fontsize{6.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\qihao}{\\fontsize{5.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\bahao}{\\fontsize{5.0pt}{\\baselineskip}\\selectfont}
                \\usepackage{color}
                \\usepackage{geometry}
                \\geometry{top=2cm,bottom=2cm,right=2cm,left=2.5cm}
                \\geometry{headsep=0.5cm}
                \\usepackage{setspace}
                \\setlength{\\baselineskip}{22pt}
                \\setlength{\\parskip}{0pt}
                \\usepackage{enumerate}
                \\usepackage{enumitem}
                \\setenumerate[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setitemize[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setdescription{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\usepackage{fancyhdr}
	              \\pagestyle{fancy}
	              \\fancyhead{}
	              \\fancyhead[CE]{\\KaiTi \\wuhao xxxxx}
	              \\fancyhead[CO]{\\KaiTi \\wuhao xxxx}
	              \\fancypagestyle{plain}{\\pagestyle{fancy}}
                \\ctexset{contentsname=\\heiti{目{\\quad}录}}
                \\ctexset{section={format=\\raggedright}}
                \\usepackage{titlesec}
	              %\\titleformat{\\chapter}[block]{\\normalfont\\xiaoer\\bfseries\\centering\\heiti}{第{\\zhnumber{\\thechapter}}章}{10pt}{\\xiaoer}
	              \\titleformat{\\section}[block]{\\normalfont\\xiaosan\\bfseries\\heiti}{\\thesection}{10pt}{\\xiaosan}
	              \\titleformat{\\subsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsection}{10pt}{\\sihao}
	              \\titleformat{\\subsubsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsubsection}{10pt}{\\sihao}
	              %\\titlespacing{\\chapter} {0pt}{-22pt}{0pt}{}
	              \\titlespacing{\\section} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsection} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsubsection} {0pt}{0pt}{0pt}
                \\usepackage[super,square,numbers,sort&compress]{natbib}
                \\usepackage{graphicx}
                \\usepackage{subfigure}
                \\usepackage{caption}
                \\captionsetup{font={small}}
                [NO-DEFAULT-PACKAGES]
                [NO-PACKAGES]
                [EXTRA]"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
;; 用来返回当前目录

(setq org-startup-with-inline-images t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (C . t) ;; 启用 Python 语言
   (emacs-lisp . t) ;; 启用 Python 语言
   (perl . t) ;; 启用 Python 语言
   (python . t) ;; 启用 Python 语言
   ;; 这里可以添加其他你需要的语言，例如：
   (dot . t)
   (plantuml . t)
   ))

;;;###autoload
(defun spk/deadgrep-search-default-dir ()
  default-directory)

;; org-mode 启用的时候调用的函数，将需要在 org-mode 中添加的部分都放到这里来
;;;###autoload
(defun spk/org-mode-setup ()
  (require 'deadgrep)
  (when (boundp 'deadgrep-project-root-function)
    (make-local-variable 'deadgrep-project-root-function)
    (setq deadgrep-project-root-function 'spk/deadgrep-search-default-dir))
  ;; 由于org默认绑定了想要使用的全局快捷键，这里在加载org-mode时单独绑定按按键到org-mode
  (when (commandp 'symbol-overlay-put)
    (define-key org-mode-map (kbd "C-\'") #'symbol-overlay-put)
    )
  )

;; 加载ox-rst
(require 'ox-rst)
(with-eval-after-load 'ox-rst
  ;; 与实际使用时相比，一级标题也使用了=，这里在原来的基础上增加一个=
  (setq org-rst-headline-underline-characters '(?= ?- ?~ ?^ ?: ?' ?\ ?_))
  (setq org-rst-link-use-ref-role t)
  (defadvice org-rst-export-to-rst (after spk-org-rst-hack activate)
    (let* ((rst-file (concat (file-name-sans-extension (buffer-file-name)) ".rst"))
           (exec-script (concat spk-scripts-dir "org-ox-rst-table-multicol"))
           (cmd-str nil)
           )
      (setq cmd-str (format "%s %s" exec-script rst-file))
      (message "prepare to exec:%s" cmd-str)
	  (shell-command cmd-str)
      )
    ))

;; 添加相应 hook
(add-hook 'org-mode-hook 'org-num-mode)
(add-hook 'org-mode-hook #'org-bars-mode)
;; (add-hook 'org-mode-hook 'focus-mode)
;; (add-hook 'org-mode-hook 'org-indent-mode)
;; (add-hook 'org-mode-hook 'valign-mode)
(add-hook 'org-mode-hook 'spk/org-mode-setup)

;; (setq valign-fancy-bar t)
;; 从懒猫大佬配置里面抄的将 org 导出为 docx 的函数，需要依赖于 pandoc
(defun org-export-docx ()
    "Export current buffer to docx file with the template.docx."
    (interactive)
    (let ((docx-file (concat (file-name-sans-extension (buffer-file-name)) ".docx"))
          (template-file (expand-file-name "template.docx" spk-private-doc-dir)))
      (shell-command (format "pandoc %s -o %s --reference-doc=%s"
                             (buffer-file-name) docx-file template-file))
      (message "Convert finish: %s" docx-file)))

;; 新增tip类型的自定义block，用于在导出成rst时生成tips
(add-to-list 'org-structure-template-alist '("t" . "tip"))
(add-to-list 'org-structure-template-alist '("w" . "attention"))
(add-to-list 'org-structure-template-alist '("i" . "important"))

;; org-mode 其余相关插件的初始化
(require 'init-denote)

(provide 'init-org)

