;;; Compiled snippets and support files for `snippet-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'snippet-mode
		     '(("same" "\\${${1:1}:\\$(yas/substr yas-text \"[^ ]*\")}" "same as ${1}" nil nil nil "d:/HOME/.emacs.d/snippets/snippet-mode/same.yasnippet" nil nil)
		       ("main" "# -*- mode: snippet -*-\n# name: ${1:description}\n# key: ${2:key}\n# contributor: `user-full-name`\n# --\n$0" "main snippet" nil nil nil "d:/HOME/.emacs.d/snippets/snippet-mode/main.yasnippet" nil nil)))


;;; Do not edit! File generated at Wed Mar 10 08:30:21 2021
