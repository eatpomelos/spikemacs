;;; Compiled snippets and support files for `erlang-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'erlang-mode
		     '(("undef" "-undef($1).\n$0" "-undef(...)." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/undef" nil nil)
		       ("try" "try $1 of\n    $0\ncatch\nafter\nend" "try ... of ... catch after end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/try" nil nil)
		       ("rec" "-record($1,{$2}).\n$0" "-record(...,{...})." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/rec" nil nil)
		       ("rcv" "receive\nafter\n    $1 -> $0\nend" "receive after ... -> ... end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/rcv.after" nil nil)
		       ("rcv" "receive\n    $1 -> $0\nend" "receive ... -> ... end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/rcv" nil nil)
		       ("mod" "-module(${1:`(file-name-nondirectory\n              (file-name-sans-extension (or (buffer-file-name) (buffer-name))))`}).\n$0" "-module()." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/mod" nil nil)
		       ("main" "-module(`(file-name-base (buffer-file-name))`).\n-export([${1:helloworld}/${2:1}]).\n\n%% Only this function is exported\n${1:$(yas/substr yas-text \"[^ ]*\")}([]) ->    % No output for empty list\n    ok;" "main" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/main.yasnippet" nil nil)
		       ("main" "-module(`(file-name-base (buffer-file-name))`, [Req, SessionID]).\n-compile(export_all).\n\n%% @see http://www.chicagoboss.org/api-controller.html  \n\n%% Get /`(file-name-base (buffer-file-name))`/${1:view}/1234\n${1:$(yas/substr yas-text \"[^ ]*\")}('GET', [Id]) -> \n    {output, \"<h1>Hello world</h1>\"}." "CB controller" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/main-cb.yasnippet" nil nil)
		       ("loop" "${1:loop}($2) ->\n    receive\n	${3:_} ->\n	    $1($2)\n    end.\n$0" "loop(...) -> receive _ -> loop(...) end." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/loop" nil nil)
		       ("inc" "-include_lib(\"$1\").\n$0" "-include_lib(\"...\")." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/inc.lib" nil nil)
		       ("inc" "-include(\"$1\").\n$0" "-include(\"...\")." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/inc" nil nil)
		       ("imp" "-import(${1:lists}, [${2:map/2, sum/1}]).\n$0" "-import([])." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/imp" nil nil)
		       ("ifndef" "-ifndef($1).\n$0\n-endif." "-ifndef(...). ... -endif." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/ifndef" nil nil)
		       ("ifdef" "-ifdef($1).\n$0\n-endif." "-ifdef(...). ... -endif." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/ifdef" nil nil)
		       ("if" "if\n    $1 -> $2;\n    true -> $0\nend" "if ... -> ... ; true -> ... end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/if" nil nil)
		       ("fun" "fun ($1) -> $0 end" "fun (...) -> ... end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/fun" nil nil)
		       ("exp" "-export([${1:start/0}]).\n$0" "-export([])." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/exp" nil nil)
		       ("def" "-define($1,$2).\n$0" "-define(...,...)." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/def" nil nil)
		       ("compile" "-compile([${1:export_all}]).\n$0" "-compile(...)." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/compile" nil nil)
		       ("case" "case ${1:variable} of\n    ${2:condition1} ->\n        ok;\n    true  ->\n        ok;\nend." "case ... of ... end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/case" nil nil)
		       ("beh" "-behaviour(${1:gen_server}).\n$0" "-behaviour(...)." nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/beh" nil nil)
		       ("begin" "begin\n    $0\nend" "begin ... end" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/begin" nil nil)
		       ("after" "after\n    $1 -> $0" "after ... ->" nil nil nil "d:/HOME/.emacs.d/snippets/erlang-mode/after" nil nil)))


;;; Do not edit! File generated at Sun Mar  7 16:29:09 2021
