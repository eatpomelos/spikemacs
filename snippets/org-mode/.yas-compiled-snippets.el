;;; Compiled snippets and support files for `org-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'org-mode
		     '(("w" "[[http://www.bing.com/dict/search?q=${1:word}&FORM=BDVSP6&mkt=zh-cn][${1:$(yas/substr yas-text \"[a-z-A-Z ]*\")}]" "word at online dictionary" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/w.yasnippet" nil nil)
		       ("u" "[[https://www.urbandictionary.com/define.php?term=${1:word}][${1:$(yas/substr yas-text \"[a-z-A-Z ]*\")}]" "urban dictionary definition" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/u.yasnippet" nil nil)
		       ("gclip" "`(replace-regexp-in-string \"^ *\\\\([^ \\n\\r]+\\\\) *$\" \"\\* TODO \\\\1\" (my-gclip))`" "TODOs from clipboard" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/todos-from-clipboard.yasnippet" nil nil)
		       ("title" "#+TITLE: ${1:title}\n" "Title Block" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/title" nil nil)
		       ("text" "#+TEXT: ${1:text}\n" "Text" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/text" nil nil)
		       ("startup" "#+STARTUP: ${1:options}\n" "Startup" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/startup" nil nil)
		       ("src" "#+begin_src ${1:javascript}\n$0\n#+end_src" "Source Block" nil nil
			((yas/indent-line 'fixed)
			 (yas/wrap-around-region 'nil))
			"d:/HOME/.emacs.d/snippets/org-mode/src.yasnippet" nil nil)
		       ("seq" "#+SEQ_TODO: ${1:STATES} | ${2:FINISHED}\n" "SEQ TODO" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/seq" nil nil)
		       ("prop" " :PROPERTIES:\n :VISIBILITY:folded:\n :END:\n" "Properties Folded" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/prop" nil nil)
		       ("pagebreak" "#+ODT: <text:p text:style-name=\"PageBreak\"/>\n" "page break for libreoffice" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/pagebreak.yasnippet" nil nil)
		       ("options" "#+OPTIONS: ${0}\n\n" "OPTIONS" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/options" nil nil)
		       ("main" "#+OPTIONS: ^:{} toc:nil H:3\n* ${1:myproject} (v0.0.1)\n\n[[http://melpa.org/#/${1:$(yas/substr yas-text \"[^ ]*\")}][file:http://melpa.org/packages/${1:$(yas/substr yas-text \"[^ ]*\")}-badge.svg]] [[http://stable.melpa.org/#/${1:$(yas/substr yas-text \"[^ ]*\")}][file:http://stable.melpa.org/packages/${1:$(yas/substr yas-text \"[^ ]*\")}-badge.svg]]\n\nOne liner to discribe this program.\n\n* Why\n- feature1\n- feature2\n* Install\nInstall it through [[http://melpa.org]].\n* Setup\n* Usage\n* Tips\n* Credits\n* Contact" "project README template" nil nil
			((yas-indent-line 'fixed))
			"d:/HOME/.emacs.d/snippets/org-mode/main-readme.yasnippet" nil nil)
		       ("main" "#+OPTIONS: ^:{} toc:nil H:3\n* ${1:blog-title}\nSome content here\n\nTest *bolded* test /italic text/ =verbatim.key[0].hello.value=\n\nThis is _underlined text_.\n\nThis is some code,\n#+begin_src javascript\nconsole.log('object=', object);\n#+end_src\n\nThis is [[http://www.google.com][google link]].\n\nFootnote1 [fn:n1] and footnote2 [fn:n2] to explain something.\n\n[fn:n1] The link is: http://orgmode.org\n\n[fn:n2] Just another footnote\n\n#+begin_example\nhere is some example\n#+end_example" "content for a new blog file" nil nil
			((yas-indent-line 'fixed))
			"d:/HOME/.emacs.d/snippets/org-mode/main-blog.yasnippet" nil nil)
		       ("latex" "#+BEGIN_LATEX\n${0}\n#+END_LATEX\n" "LATEX" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/latex" nil nil)
		       ("lang" "#+LANGUAGE: ${1:en}\n" "LANGUAGE" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/lang" nil nil)
		       ("keywords" "#+KEYWORDS: ${0}\n" "KEYWORDS" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/keywords" nil nil)
		       ("gclip" "`(replace-regexp-in-string \"^ *\\\\([^ \\n\\r]+\\\\) *$\" \"- [ ] \\\\1\" (my-gclip))`" "org items from clipboard" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/items-from-clipboard.yasnippet" nil nil)
		       ("inc" "#+INCLUDE: \"${1:file}\" ${2:src-example-quote} ${3:mode}\n\n" "Author" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/inc" nil nil)
		       ("html" "#+BEGIN_HTML\n${0}\n#+END_HTML\n" "HTML" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/html" nil nil)
		       ("file" "[[file:${1:file-path}]]\n" "[[file:link]]" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/file.snippet" nil nil)
		       ("figure" "#+attr_latex: width=$1\\textwidth\n`(org-insert-link '(4))`\n$0\n" "figure" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/figure" nil nil)
		       ("e" "#+begin_example\n$0\n#+end_example" "Example Block" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/example.yasnippet" nil nil)
		       ("email" "#+EMAIL: ${1:`user-mail-address`}\n" "Email" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/email" nil nil)
		       ("docbook" "#+BEGIN_DOCBOOK\n${0}\n#+END_DOCBOOK\n" "DOCBOOK" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/docbook" nil nil)
		       ("dita" "#+BEGIN_DITAA ${1:export-file-name} -r -S -E\n${0}\n#+END_DITAA\n" "DITAA" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/dita" nil nil)
		       ("desc" "#+DESCRIPTION: ${0}\n" "DESCRIPTION" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/desc" nil nil)
		       ("bridge" "|            | S | H | D | C |\n|------------+---+---+---+---|\n| N          |   |   |   |   |\n| S          |   |   |   |   |\n| NS (total) |   |   |   |   |\n|------------+---+---+---+---|\n| E          |   |   |   |   |\n| W          |   |   |   |   |\n| EW (total) |   |   |   |   |" "table for card reading in contract bridge" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/bridge.yasnippet" nil nil)
		       ("block" "#+begin_$1 $2\n  $0\n#+end_$1\n" "#+begin_...#+end_" nil nil
			((yas/indent-line 'fixed)
			 (yas/wrap-around-region 'nil))
			"d:/HOME/.emacs.d/snippets/org-mode/block" nil nil)
		       ("begin" "\\begin{$1}\n  $0\n\\end{$1}\n" "\\begin{...} ... \\end{...}" nil nil
			((yas/indent-line 'fixed)
			 (yas/wrap-around-region 'nil))
			"d:/HOME/.emacs.d/snippets/org-mode/begin" nil nil)
		       ("author" "#+AUTHOR: ${1:`user-full-name`}\n" "Author" nil nil nil "d:/HOME/.emacs.d/snippets/org-mode/author" nil nil)))


;;; Do not edit! File generated at Sun Mar  7 16:29:09 2021
