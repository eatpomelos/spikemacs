;;; Compiled snippets and support files for `cc-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
		     '(("pri" "println(\"${1:var}\" + $1);\n" "println (...)" nil nil nil "d:/HOME/.emacs.d/snippets/cc-mode/pri" nil nil)
		       ("lo" "fprintf(stderr,\"${1:object}=%s\\n\", ${1:$(yas/substr yas-text \"[^ ]*\")});" "fprintf(stderr, description,object)" nil nil nil "d:/HOME/.emacs.d/snippets/cc-mode/logobject.yasnippet" nil nil)
		       ("lo" "fprintf(stderr,\"`(my-yas-get-var-list-from-kill-ring)`);" "fprintf(stderr, var_list_from_kill_ring)" nil nil nil "d:/HOME/.emacs.d/snippets/cc-mode/log-var-list-from-kill-ring.yasnippet" nil nil)
		       ("lwf" "fprintf(stderr,\"`(which-function)` called => `(my-yas-get-var-list-from-kill-ring)`);" "fprintf(stderr, function, var_list_from_kill_ring)" nil nil nil "d:/HOME/.emacs.d/snippets/cc-mode/log-function-and-var-list-from-kill-ring.yasnippet" nil nil)
		       ("indent" "$0\n// Local Variables:\n// c-basic-offset: ${1:2}\n// indent-tabs-mode: nil\n// End:\n//\n// vim: et sts=${1:$(yas/substr yas-text \"[0-9]*\")} sw=${1:$(yas/substr yas-text \"[0-9]*\")}\n" "indent (c++ style)" nil nil nil "d:/HOME/.emacs.d/snippets/cc-mode/indent.yasnippet" nil nil)))


;;; Do not edit! File generated at Sun Feb 28 09:41:15 2021
