;; 和org 相关的配置

;; 由于使用strainght.el 升级package 中org 有一个变量的名字发生了改变，此处使用本地org 包防止出现使用错误
;; (straight-use-package '(org :type built-in))
;; (straight-use-package 'org-pomodoro)
(straight-use-package 'org)
;; (require 'org)
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))

;; 设置一下自己的任务管理的一些简单的配置,要是想放弃一个任务的时候，要进行说明，以后可能会再次启用这个任务
(setq org-todo-keywords '((sequence "TODO(t)" "DOING(i)" "PAUSE(p@)" "|" "DONE(d)" "ABORT(a@/!)")))
(setq org-todo-keyword-faces '(("TODO" . "red")
                               ("DOING" . "yellow")
                               ("DONE" . "green")
                               ("ABORT" . "blue")
                               ("PAUSE" . "cyan1")))

;; 设置几个常用的capture 的文件的路径
(defvar spk-private-doc-dir "~/.emacs.d/docs/"
  "My private document directory.")

(defvar spk-org-directory "~/.emacs.d/docs/org"
  "Default directory of org files."
  )

;; 设置自己的个人笔记目录
(defvar spk-local-notes-dir
  (concat spk-org-directory "notes/")
  "Local notes path.")

;; 设置agenda文件,注意以下这种写法，不加括号直接用字符串是不行的
(setq org-agenda-files '("~/.emacs.d/docs/org"
			             "~/.emacs.d/docs/org/notes"
                         "~/.emacs.d/docs/daily"))

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

;; 后续提高速度可以用eval-after-load来控制
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

;; 下面使用的是别人提供的模板，主要是latex中使用的一些东西
;;org-export latex
(setq org-alphabetical-lists t)
  ;;(setq org-latex-to-pdf-process (list "latexmk -pdf %f"))
  ;;(require 'ox-bibtex)

;; 在windows上命令不统一，导致下面的rm命令无法执行，从而会保留一部分中间文件
(when IS-LINUX
    (setq org-latex-pdf-process
	  '("xelatex -interaction nonstopmode %f"
	    "bibtex %b"
	    "xelatex -interaction nonstopmode %f"
	    "xelatex -interaction nonstopmode %f"
	    "rm -fr %b.out %b.log %b.tex %b.brf %b.bbl auto"
	    )))

;; 由于windows上的命令和linux不一致需要设置进行区分
(when IS-WINDOWS
  (setq org-latex-pdf-process
	'("xelatex -interaction nonstopmode %f"
	  "bibtex %b"
	  "xelatex -interaction nonstopmode %f"
	  "xelatex -interaction nonstopmode %f"
	  "del %b.out %b.log %b.tex %b.brf %b.bbl auto"
	  )))

(setq org-latex-compiler "xelatex")

;; 看这个给require 怎么优化
(require 'ox-latex)
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

;; org-mode其余相关插件的初始化
(require 'init-org-roam)

(provide 'init-org)
