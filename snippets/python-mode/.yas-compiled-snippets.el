;;; Compiled snippets and support files for `python-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'python-mode
		     '(("main" "import sympy as sympy\nimport numpy as np\nimport seaborn as sbn # pip install --user seaborn\nfrom scipy import *\nfrom matplotlib import pyplot as plt\nsbn.set()\nxData = np.arange(0, 10, 1)\nyData1 = xData.__pow__(2.0)\nyData2 = np.arange(15, 61, 5)\nplt.figure(num=1, figsize=(8, 6))\nplt.title('Plot 1', size=14)\nplt.xlabel('x-axis', size=14)\nplt.ylabel('y-axis', size=14)\nplt.plot(xData, yData1, color='b', linestyle='--', marker='o', label='y1 data')\nplt.plot(xData, yData2, color='r', linestyle='-', label='y2 data')\nplt.legend(loc='upper left')\n# plt.savefig('plot1.png', format='png')\nplt.show()" "draw plot with ipython" nil nil nil "d:/HOME/.emacs.d/snippets/python-mode/main.yasnippet" nil nil)
		       ("lo" "print '${1:object}=', ${1:$(yas/substr yas-text \"[^ ]*\")}\n" "print 'object=',object" nil nil nil "d:/HOME/.emacs.d/snippets/python-mode/logobject.yasnippet" nil nil)
		       ("indent" "# -*- coding: utf-8; mode: python; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=python:et:sw=4:ts=4:sts=4" "indent" nil nil nil "d:/HOME/.emacs.d/snippets/python-mode/indent.yasnippet" nil nil)))


;;; Do not edit! File generated at Sun Feb 28 09:41:15 2021
