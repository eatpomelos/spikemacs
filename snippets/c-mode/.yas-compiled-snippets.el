;;; Compiled snippets and support files for `c-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'c-mode
		     '(("swi" "switch(${1:condition}) {\ncase ${2:condition}:\n    $3\n    break;\ndefault:\n    $0\n    break;\n}\n" "switch (...) { ...}" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/switch.yasnippet" nil nil)
		       ("#include" "#include <stdio.h>\n\nint main(int argc,char*argv[])\n{\n  $1\n  return 0;\n}\n" "#include" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/main.yasnippet" nil nil)
		       ("l" "printf(\"${1:hello world}\\n\");\n" "printf(\"hello\\n\");" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/log.yasnippet" nil nil)
		       ("lwf" "printf(\"${1:`(which-function)`} called\\n\");\n" "printf which function called" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/log-which-function.yasnippet" nil nil)
		       ("indent" "/* -*- mode: c; c-basic-offset: ${1:4}; indent-tabs-mode: nil; -*-\n * vim: et sw=${1:$(yas/substr yas-text \"[0-9]*\")} ts=${1:$(yas/substr yas-text \"[0-9]*\")} sts=0:\n */\n" "indent (c-style)" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/indent.yasnippet" nil nil)
		       ("i" "#include $0" "#include \"...\"" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/include.yasnippet" nil nil)
		       ("ifeie.yasnippet" "if (${1:condition}) {\n     $2\n} else if (${3:condition}) {\n     $4\n} else {\n     $0\n}\n" "if (...) { ... } else if (...) { ... } else { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/ifeie.yasnippet" nil nil)
		       ("ifei.yasnippet" "if (${1:condition}) {\n    $2\n} else if (${3:condition}) {\n    $0\n}\n" "if (...) { ... } else if (...) { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/ifei.yasnippet" nil nil)
		       ("ife" "if (${1:true}) {\n  $0\n} else {\n}\n" "if ... else ..." nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/ife.yasnippet" nil nil)
		       ("if" "if (${1:true}) {\n  $0\n}\n" "if" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/if.yasnippet" nil nil)
		       ("elseif.yasnippet" "} else if (${1:condition}) {\n     $0\n" "else if (...) { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/elseif.yasnippet" nil nil)
		       ("a" "assert($0);\n" "assert" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/assert.yasnippet" nil nil)
		       ("alloc" "(${1:newsize} + 32767) & ~32767\n" "find minimum n*32768 greater than newsize" nil nil nil "d:/HOME/.emacs.d/snippets/c-mode/alloc-size.yasnippet" nil nil)))


;;; Do not edit! File generated at Sun Feb 28 23:02:43 2021
