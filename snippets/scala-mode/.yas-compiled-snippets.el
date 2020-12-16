;;; Compiled snippets and support files for `scala-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'scala-mode
		     '(("with" "with $0" "with T" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/with" nil nil)
		       ("whi" "while (${1:condition}) {\n  $0\n}" "while(cond) { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/whi" nil nil)
		       ("var.ret" "var ${1:name}: ${2:T} = ${3:obj} $0\n" "var name: T = .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/var.ret" nil nil)
		       ("var.new" "var ${1:name} = new ${2:obj} $0\n" "var name = new .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/var.new" nil nil)
		       ("var" "var ${1:name} = ${2:obj} $0\n" "var name = .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/var" nil nil)
		       ("val.ret" "val ${1:name}: ${2:T} = ${3:obj} $0\n" "val name: T = .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/val.ret" nil nil)
		       ("val.new" "val ${1:name} = new ${2:obj} $0" "val name = new .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/val.new" nil nil)
		       ("val" "val ${1:name} = ${2:obj} $0" "val name = .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/val" nil nil)
		       ("tup.paren" "(${1:element1}, ${2:element2}) $0" "(element1, element2)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/tup.paren" nil nil)
		       ("tup.arrow" "${1:element1} -> ${2:element2} $0" "element1 -> element2" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/tup.arrow" nil nil)
		       ("try.finally" "try {\n\n} finally {\n  $0\n}" "try { .. } finally { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/try.finally" nil nil)
		       ("try.catch-finally" "try {\n  $0\n} catch {\n  case ${1:e}: ${2:Exception} => \n    ${1:println(\\\"ERROR: \\\" + e) // TODO: handle exception}\\n}\n} finally {\n\n}" "try { .. } catch { case e => ..} finally { ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/try.catch-finally" nil nil)
		       ("try" "try {\n  $0\n} catch {\n  case ${1:e}: ${2:Exception} => \n    ${1:println(\\\"ERROR: \\\" + e) // TODO: handle exception}\\n}\n}" "try { .. } catch { case e => ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/try" nil nil)
		       ("tr.with" "trait ${1:name} with ${2:trait} {\n  $0\n}" "trait T1 with T2 { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/tr.with" nil nil)
		       ("tr.ext-with" "trait ${1:name} extends ${2:class} with ${3:trait} {\n  $0\n}" "trait T1 extends C with T2 { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/tr.ext-with" nil nil)
		       ("tr.ext" "trait ${1:name} extends ${2:class} {\n  $0\n}" "trait T extends C { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/tr.ext" nil nil)
		       ("tr" "trait ${1:name} {\n  $0\n}" "trait T { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/tr" nil nil)
		       ("throw" "throw new ${1:Exception}(${2:msg}) $0" "throw new Exception" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/throw" nil nil)
		       ("test" "//@Test\ndef test${1:name} = {\n  $0\n}" "@Test def testX = ..." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/test" nil nil)
		       ("suite" "import org.scalatest._\n\nclass ${1:name} extends Suite {\n  $0\n}" "class T extends Suite { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/suite" nil nil)
		       ("pro.param" "protected[${1:this}] $0" "protected[this]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pro.param" nil nil)
		       ("pro" "protected $0" "protected" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pro" nil nil)
		       ("pri.param" "private[${1:this}] $0" "private[this]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pri.param" nil nil)
		       ("pri" "private $0" "private" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pri" nil nil)
		       ("pr.trace" "println(\"${1:obj}: \" + ${1:obj}) $0" "println(\"obj: \" + obj)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pr.trace" nil nil)
		       ("pr.string" "println(\"${1:msg}\") $0" "println(\"..\")" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pr.string" nil nil)
		       ("pr.simple" "print(${1:obj}) $0" "print(..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pr.simple" nil nil)
		       ("pr.newline" "println(${1:obj}) $0" "println(..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pr.newline" nil nil)
		       ("pac" "package $0" "package .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/pac" nil nil)
		       ("ob" "object ${1:name} extends ${2:type} $0" "object name extends T" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ob" nil nil)
		       ("mix" "trait ${1:name} {\n  $0\n}" "trait T { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/mix" nil nil)
		       ("match.option" "${1:option} match {\n  case None => $0\n  case Some(res) => \n\n}" "option match { case None => .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/match.option" nil nil)
		       ("match.can" "${1:option} match {\n  case Full(res) => $0\n\n  case Empty => \n\n  case Failure(msg, _, _) => \n\n}" "can match { case Full(res) => .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/match.can" nil nil)
		       ("match" "${1:cc} match {\n  case ${2:pattern} => $0\n}" "cc match { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/match" nil nil)
		       ("map.new" "Map(${1:key} -> ${2:value}) $0" "Map(key -> value)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/map.new" nil nil)
		       ("map" "map(${1:x} => ${2:body}) $0" "map(x => ..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/map" nil nil)
		       ("main" "def main(args: Array[String]) = {\n  $0\n}" "def main(args: Array[String]) = { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/main" nil nil)
		       ("ls.val-new" "val ${1:l} = List(${2:args}, ${3:args}) $0" "val l = List(..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ls.val-new" nil nil)
		       ("ls.new" "List(${1:args}, ${2:args}) $0" "List(..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ls.new" nil nil)
		       ("isof" "isInstanceOf[${1:type}] $0" "isInstanceOf[T]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/isof" nil nil)
		       ("intercept" "intercept(classOf[${1:Exception]}) {\n  $0\n}" "intercept(classOf[T]) { ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/intercept" nil nil)
		       ("imp" "import $0" "import .." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/imp" nil nil)
		       ("if.else" "if (${1:condition}) {\n  $2\n} else {\n  $0\n}" "if (cond) { .. } else { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/if.else" nil nil)
		       ("if" "if (${1:condition}) {\n  $0\n}" "if (cond) { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/if" nil nil)
		       ("hset.val-new" "val ${1:m} = new HashSet[${2:key}] $0" "val m = new HashSet[K]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/hset.val-new" nil nil)
		       ("hset.new" "new HashSet[${1:key}] $0\n" "new HashSet[K]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/hset.new" nil nil)
		       ("hmap.val-new" "val ${1:m} = new HashMap[${2:key}, ${3:value}] $0" "val m = new HashMap[K, V]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/hmap.val-new" nil nil)
		       ("hmap.new" "new HashMap[${1:key}, ${2:value}] $0" "new HashMap[K, V]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/hmap.new" nil nil)
		       ("foreach" "foreach(${1:x} => ${2:body}) $0" "foreach(x => ..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/foreach" nil nil)
		       ("for.multi" "for {\n  ${1:x} <- ${2:xs}\n  ${3:x} <- ${4:xs}\n} {\n  yield $0\n}" "for {x <- xs \\ y <- ys} { yield }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/for.multi" nil nil)
		       ("for.loop" "for (${1:x} <- ${2:xs}) {\n  $0\n}" "for (x <- xs) { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/for.loop" nil nil)
		       ("for.if" "for (${1:x} <- ${2:xs} if ${3:guard}) {\n  $0\n}" "for (x <- xs if guard) { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/for.if" nil nil)
		       ("for.extract" "${1:x} <- ${2:xs}" "x <- xs" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/for.extract" nil nil)
		       ("ext" "extends $0" "extends T" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ext" nil nil)
		       ("expect" "expect(${1:reply}) {\n  $0\n}" "expect(value) { ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/expect" nil nil)
		       ("doc.scaladoc" "/**\n * ${1:description}\n * $0\n */" "/** ... */" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/doc.scaladoc" nil nil)
		       ("doc.file-scala-api" "/*                     __                                               *\\\n**     ________ ___   / /  ___     Scala API                            **\n**    / __/ __// _ | / /  / _ |    (c) 2005-`(format-time-string \"%Y\")`, LAMP/EPFL             **\n**  __\\ \\/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **\n** /____/\\___/_/ |_/____/_/ | |                                         **\n**                          |/                                          **\n\\*                                                                      */\n/** \n * $0\n * @author ${1:name} \n * @version ${2:0.1}\n * $Id$\n */" "/** scala api file */" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/doc.file-scala-api" nil nil)
		       ("doc.file-scala" "/*                     __                                               *\\\n**     ________ ___   / /  ___     Scala $3                               **\n**    / __/ __// _ | / /  / _ |    (c) 2005-`(format-time-string \"%Y\")` , LAMP/EPFL             **\n**  __\\ \\/ /__/ __ |/ /__/ __ |    http://scala-lang.org/               **\n** /____/\\___/_/ |_/____/_/ | |                                         **\n**                          |/                                          **\n\\*                                                                      */\n/** \n * $0\n * @author ${1:name} \n * @version ${2:0.1}\n * $Id$\n */" "/** scala file */" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/doc.file-scala" nil nil)
		       ("doc.file" "/**\n * `(scala-mode-file-doc)`\n * $0\n * @author ${1:name}\n * @version ${2:0.1} \n */" "/** file name */" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/doc.file" nil nil)
		       ("doc.def" "/** \n * `(scala-mode-def-and-args-doc)`\n */ " "/** method name */" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/doc.def" nil nil)
		       ("doc.class" "/** \n * `(scala-mode-find-clstrtobj-name-doc)`\n * ${1:description}\n * $0  \n */" "/** cls/trt/obj name */" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/doc.class" nil nil)
		       ("def.simple" "def ${1:name} = $0" "def f = ..." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.simple" nil nil)
		       ("def.ret-body" "def ${1:name}: ${3:Unit} = {\n  $0\n}" "def f: R = {...}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.ret-body" nil nil)
		       ("def.ret" "def ${1:name}: ${2:Unit} = $0" "def f: R = ..." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.ret" nil nil)
		       ("def.body" "def ${1:name} = {\n  $0\n}" "def f = {...}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.body" nil nil)
		       ("def.arg-ret-body" "def ${1:name}(${2:args}): ${3:Unit} = {\n  $0\n}" "def f(arg: T): R = {...}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.arg-ret-body" nil nil)
		       ("def.arg-ret" "def ${1:name}(${2:args}): ${3:Unit} = $0" "def f(arg: T): R = ..." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.arg-ret" nil nil)
		       ("def.arg-body" "def ${1:name}(${2:args}) = {\n  $0\n}" "def f(arg: T) = {...}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.arg-body" nil nil)
		       ("def.arg" "def ${1:name}(${2:args}) = $0" "def f(arg: T) = ..." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/def.arg" nil nil)
		       ("cons.nil" "${1:element1} :: Nil $0\n" "element1 :: Nil" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cons.nil" nil nil)
		       ("cons" "${1:element1} :: ${2:element2} $0" "element1 :: element2" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cons" nil nil)
		       ("co" "case object ${1:name} $0" "case object T" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/co" nil nil)
		       ("clof" "classOf[${1:type}] $0" "classOf[T]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/clof" nil nil)
		       ("cl.arg" "class ${1:name}(${2:args}) {\n  $0\n}" "class T(args) { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cl.arg" nil nil)
		       ("cl.abs-arg" "abstract class ${1:name}(${2:args}) {\n  $0\n}" "abstract class T(args) { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cl.abs-arg" nil nil)
		       ("cl.abs" "abstract class ${1:name} {\n  $0\n}" "abstract class T { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cl.abs" nil nil)
		       ("cl" "class ${1:name} {\n  $0\n}" "class T { .. }" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cl" nil nil)
		       ("cc" "case class ${1:name}(${2:arg}: ${3:type}) $0" "case class T(arg: A)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cc" nil nil)
		       ("cast" "asInstanceOf[${1:type}] $0" "asInstanceOf[T]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/cast" nil nil)
		       ("case.match-all" "case _ => $0" "case _ =>" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/case.match-all" nil nil)
		       ("case" "case ${1:pattern} => $0" "case pattern =>" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/case" nil nil)
		       ("bang" "${1:actor} ! ${2:message} $0" "actor ! message" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/bang" nil nil)
		       ("at.version" "@version ${1:0.1} $0" "@version number" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/at.version" nil nil)
		       ("at.return" "@return ${1:description} $0" "@return description" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/at.return" nil nil)
		       ("at.param" "@param ${1:name} ${2:description} $0" "@param name description" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/at.param" nil nil)
		       ("at.author" "@author ${1:name} $0" "@author name" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/at.author" nil nil)
		       ("ass.true" "assert(true) $0" "assert(true)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ass.true" nil nil)
		       ("ass" "assert(${1:x} === ${2:y}) $0" "assert(x === y)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ass" nil nil)
		       ("asof" "asInstanceOf[${1:type}] $0" "asInstanceOf[T]" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/asof" nil nil)
		       ("arr.val-new" "val ${1:arr} = Array[${2:value}](${3:args}) $0" "val a = Array[T](..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/arr.val-new" nil nil)
		       ("arr.new" "Array[${1:value}](${2:args}) $0" "Array[T](..)" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/arr.new" nil nil)
		       ("app" "object ${1:name} extends Application {\n  $0\n}" "object name extends Application" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/app" nil nil)
		       ("ano" "($1) => ${2:body} $0" "(args) => ..." nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/ano" nil nil)
		       ("actor" "val a = actor {\n  loop {\n    react {\n      $0\n    }\n  }\n}" "val a = actor { ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/actor" nil nil)
		       ("act.arg" "def act(${1:arg}: ${2:type}) = {\n  loop {\n    react {\n      $0\n    }\n  }\n}" "def act(arg: T) = { ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/act.arg" nil nil)
		       ("act" "def act = {\n  loop {\n    react {\n      $0\n    }\n  }\n}" "def act = { ..}" nil nil nil "d:/HOME/.emacs.d/snippets/scala-mode/act" nil nil)))


;;; Do not edit! File generated at Mon Dec 14 20:36:36 2020
