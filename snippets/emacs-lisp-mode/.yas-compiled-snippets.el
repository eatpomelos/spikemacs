;;; Compiled snippets and support files for `emacs-lisp-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-lisp-mode
		     '(("try" "(unwind-protect\n    (let (retval)\n      (condition-case ex\n          (setq retval ${1:\\(message \"try\"\\)})\n        ('error (message (format \"Caught exception: [%s]\" ex))))\n      retval)\n  (message \"${2:finally}\"))" "try...catch...finally" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/try.yasnippet" nil nil)
		       ("trim" "(replace-regexp-in-string (rx (* (any \" \\t\\n\")) eos)\n                          \"\"\n                          $0)" "(trim string)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/trim.yasnippet" nil nil)
		       ("thing" "(if (region-active-p)\n    (buffer-substring-no-properties (region-beginning) (region-end))\n  (thing-at-point 'symbol))" "thing under cursor selected region" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/thing-under-cursor.yasinppet" nil nil)
		       ("test" "(let* ((gc-cons-threshold most-positive-fixnum))\n  (message \"%S vs %S\"\n           (benchmark-run-compiled 100\n             (message \"test1\"))\n           (benchmark-run-compiled 100\n             (message \"test 2\"))))" "test performance" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/test-performance.yasnippet" nil nil)
		       ("foreach" "(mapc\n  (lambda (elem)\n    (message \"elem=%s\" elem)\n    $0\n  )\n  ${1:(list 1 2 3 4)}\n)\n" "(mapc FUNCTION SEQUENCE)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/mapc.yasnippet" nil nil)
		       ("main" ";;; `(file-name-nondirectory buffer-file-name)` --- ${1:purpose}\n\n;; Copyright (C) `(format-time-string \"%Y\")` `user-full-name`\n;;\n;; Version: 0.0.1\n;; Keywords: ${2:keyword1 keyword2}\n;; Author: `user-full-name` <`(replace-regexp-in-string \"\\\\.\" \" DOT \" (replace-regexp-in-string \"@\" \" AT \" user-mail-address))`>\n;; URL: http://github.com/${3:usrname}/`(file-name-base buffer-file-name)`\n;; Package-Requires: ((emacs \"24.4\"))\n\n;; This file is not part of GNU Emacs.\n\n;; This program is free software; you can redistribute it and/or modify\n;; it under the terms of the GNU General Public License as published by\n;; the Free Software Foundation; either version 3, or (at your option)\n;; any later version.\n\n;; This program is distributed in the hope that it will be useful,\n;; but WITHOUT ANY WARRANTY; without even the implied warranty of\n;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n;; GNU General Public License for more details.\n\n;; You should have received a copy of the GNU General Public License\n;; along with this program; if not, write to the Free Software\n;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n\n;;; Commentary:\n\n;; $0\n\n;;; Code:\n\n(message \"hello world\")\n(provide '`(file-name-base buffer-file-name)`)\n;;; `(file-name-nondirectory buffer-file-name)` ends here\n\n" "file template" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/main.yasnippet" nil nil)
		       ("lo" "(message \"${1:object}=%s\" ${1:$(yas/substr yas-text \"[^ ]*\")})" "(message \"object=%s\" object)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/logobject1.yasnippet" nil nil)
		       ("l3" "(message \"${1:object}=%s ${2:object}=%s ${3:object}=%s\" ${1:$(yas/substr yas-text \"[^ ]*\")} ${2:$(yas/substr yas-text \"[^ ]*\")} ${3:$(yas/substr yas-text \"[^ ]*\")})\n" "(message o1 o2 o3)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log3.yasnippet" nil nil)
		       ("l2" "(message \"${1:object}=%s ${2:object}=%s\" ${1:$(yas/substr yas-text \"[^ ]*\")} ${2:$(yas/substr yas-text \"[^ ]*\")})\n" "(message o1 o2)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log2.yasnippet" nil nil)
		       ("l" "(message \"${1:hello}\")" "(message \"hello\")" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log.yasnippet" nil nil)
		       ("lwf" "(message \"${1:`(which-function)`} called\")" "(message \"which function called\")" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log-which-function.yasnippet" nil nil)
		       ("lwf" "(message \"${1:`(which-function)`} called => `(my-yas-get-var-list-from-kill-ring)`)" "log function and var list from `kill-ring'" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log-which-function-with-var-list-from-kill-ring.yasnippet" nil nil)
		       ("lwf" "(message \"${1:`(which-function)`} called => `(mapconcat (lambda (i) \"%s\") (split-string (replace-regexp-in-string \"&optional \" \"\" (car kill-ring)) \"[ \\n\\t]+\") \" \")`\" `(mapconcat 'identity (split-string (replace-regexp-in-string \"&optional \" \"\" (car kill-ring)) \"[ \\n\\t]+\") \" \")`)" "(message function+params)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log-which-function-with-para.yasnippet" nil nil)
		       ("lo" "(message \"`(car kill-ring)`=%s\" `(car kill-ring)`)" "log top one in kill-ring" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log-recent-kill-ring.yasnippet" nil nil)
		       ("lb" "# buffer-substring-no-properties start end\n(with-current-buffer ${1:object} (message \"${1:$(yas/substr yas-text \"[^ ]*\")}=%s\" (buffer-substring-no-properties (point-min) (point-max))))\n" "(message \"buffer=%s\" buffer)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/log-buffer.yasnippet" nil nil)
		       ("l" "(let* ($0)\n  )" "let*" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/let.yasnippet" nil nil)
		       ("join" "(mapconcat 'identity ${1:'\\(\"hello\" \"world\"\\)} \"${2: }\")\n" "list => string" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/join-string.yasnippet" nil nil)
		       ("root" "(setq ${1:root-dir} (locate-dominating-file (file-name-as-directory (file-name-directory buffer-file-name)) \".git\"))\n(when (and ${1:$(yas/substr yas-text \"[^ ]*\")} (file-exists-p ${1:$(yas/substr yas-text \"[^ ]*\")}))\n  $0)" "git root directory" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/git-root.yasnippet" nil nil)
		       ("f" ";;;###autoload\n(defun ${1:func-name} ($2)\n  (interactive)\n  (let* ($3)\n  $0\n  ))\n" ";;;###autoload (defun (interfactive)...)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/function.yasnippet" nil nil)
		       ("f" "(defun ${1:func-name} ()\n  (let* (v1)\n  $0\n  ))\n" "(defun ...)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/function-tiny.yasnippet" nil nil)
		       ("eval" "(eval-after-load '${1:major-mode}\n  '(progn\n    $0\n    ))" "(eval-after-load 'major-mode ...)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/eval-after-load.yasnippt" nil nil)
		       ("dolist" "(let ((i 0) found item)\n  (while (and (not found)\n              (< i (length ${1:items})))\n    (setq item (nth i ${1:$(yas/substr yas-text \"[^ ]*\")}))\n    (when (${2:t})\n      (setq found t)\n      )\n    (setq i (1+ i))\n    ))" "(dolist () break)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/dolist.yasnippet" nil nil)
		       ("dolis" "(dolist (i ${1:items})\n  $0\n)" "(dolist (i items) ...)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/dolis.yasnippet" nil nil)
		       ("con" "(cond\n ((${1:CONDITION})\n  $0)\n (t\n  (message \"default\")))\n" "(cond (COND1 BODY) (t ...))" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/cond.yasnippet" nil nil)
		       ("advice" "(defadvice ${1:find-file} (around ${1:$(yas/substr yas-text \"[^ ]*\")}-hack activate)\n  (message \"original-args=%s\" (ad-get-args 0))\n  ;; @see https://ftp.gnu.org/old-gnu/Manuals/elisp-manual-21-2.8/html_node/elisp_220.html\n  ;; you can use (ad-get-arg 0) and (ad-set-arg 0) to tweak the arguments\n  $0\n  ad-do-it)\n" "(defadvice ... around)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/advice.snippet" nil nil)
		       ("advice" "(defadvice ${1:find-file} (before ${1:$(yas/substr yas-text \"[^ ]*\")}-before-hack activate)\n  $0)\n" "(defadvice ... before)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/advice-before.snipppet" nil nil)
		       ("advice" "(defadvice ${1:find-file} (after ${1:$(yas/substr yas-text \"[^ ]*\")}-after-hack activate)\n  $0)\n" "(defadvice ... after)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/advice-after.snippet" nil nil)
		       ("hook" "(defun ${1:major-mode}-hook-setup ()\n  $0\n  (local-set-key (kbd \"M-;\") 'comment-dwim))\n(add-hook '${1:$(yas/substr yas-text \"[^ ]*\")}-hook '${1:$(yas/substr yas-text \"[^ ]*\")}-hook-setup)" "(add-hook 'major-mode-hook ...)" nil nil nil "d:/HOME/.emacs.d/snippets/emacs-lisp-mode/add-hook.yasnippet" nil nil)))


;;; Do not edit! File generated at Mon Mar 15 07:53:03 2021
