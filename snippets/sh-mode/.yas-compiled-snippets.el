;;; Compiled snippets and support files for `sh-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'sh-mode
		     '(("lo" "echo \"${1:object}=\\$\\{${1:$(yas/substr yas-text \"[^ ]*\")}\\}\"\n" "echo \"object=${object}\"" nil nil nil "d:/HOME/.emacs.d/snippets/sh-mode/logobject.snippet" nil nil)
		       ("l" "echo \"${1:hello}\"\n" "echo \"hello\"" nil nil nil "d:/HOME/.emacs.d/snippets/sh-mode/log.snippet" nil nil)
		       ("if" "if [ \"\\$${1:str_var}\" = \"${2:hello}\" ]; then\n    $0\nelse\nfi;" "if [ \"$str\" = \"hello\" ];then ... else if" nil nil nil "d:/HOME/.emacs.d/snippets/sh-mode/if.yasnippet" nil nil)
		       ("if" "if [ \\$${1:num_var} -eq ${2:99} ]; then\n    $0\nelse\nfi;" "if [ $num -eq 3 ];then ... else if" nil nil nil "d:/HOME/.emacs.d/snippets/sh-mode/if-num.yasnippet" nil nil)
		       ("f" "function ${1:methodName} {\n    $0\n}\n" "function { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/sh-mode/function.snippet" nil nil)
		       ("for" "for i in {1..${1:100}}\ndo\n    $0\ndone" "for i in {1..100}" nil nil nil "d:/HOME/.emacs.d/snippets/sh-mode/for.yasnippet" nil nil)))


;;; Do not edit! File generated at Tue Dec 29 13:43:04 2020
