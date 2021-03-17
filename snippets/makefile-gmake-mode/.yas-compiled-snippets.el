;;; Compiled snippets and support files for `makefile-gmake-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'makefile-gmake-mode
		     '(("main" ".PHONY = all clean\nTARGET = ${1:main}\nSOURCES = $(wildcard *.c)\nOPT = -O2 -Wall\nCC = gcc\nCFLAGS = $(OPT) -L /usr/X11R6/lib -lX11 -lm\nall: $(SOURCES)\n	$(CC) -o $(TARGET) $^ $(CFLAGS)\nclean:\n	rm -rf *.o $(TARGET)" "makefile for XLib" nil nil
			((yas-indent-line 'fixed)
			 (indent-tabs-mode t))
			"d:/HOME/.emacs.d/snippets/makefile-gmake-mode/main.yansippet" nil nil)))


;;; Do not edit! File generated at Wed Mar 17 08:05:47 2021
