;;; Compiled snippets and support files for `objc-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'objc-mode
		     '(("prop" "- (${1:id})${2:foo}\n{\n    return $2;\n}\n\n- (void)set${2:$(capitalize yas-text)}:($1)aValue\n{\n    [$2 autorelease];\n    $2 = [aValue retain];\n}\n$0" "foo { ... } ; setFoo { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/objc-mode/prop" nil nil)))


;;; Do not edit! File generated at Wed Jan  6 14:05:15 2021
