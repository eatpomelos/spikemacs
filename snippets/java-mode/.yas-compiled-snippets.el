;;; Compiled snippets and support files for `java-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("writer" "PrintWriter writer = null;\ntry {\n    writer =\n        new PrintWriter(\n            new BufferedWriter(\n                new OutputStreamWriter(out, ${1:\"UTF-8\"})), true);\n    $2\n    writer.flush();\n} catch (IOException ex) {\n    $3\n} finally {\n    try {\n        if (writer != null) {\n            writer.close();\n        }\n    } catch (Exception ignore) { }\n}" "PrintWriter" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/writer.yasnippet" nil nil)
		       ("tos" "public String toString() {\n    return $0;\n}" "toString" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/tostring.yasnippet" nil nil)
		       ("thread" "Thread t = new Thread($1) {\n    public void run() {\n        $0\n    }\n}.start();" "thread" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/thread.yasnippet" nil nil)
		       ("test" "@Test\npublic void test`(upcase-initials (car kill-ring))`() {\n  $0\n  Assert.assertTrue(true);\n}" "test from yanked function" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/test.yasnippet" nil nil)
		       ("sync" "synchronized (${1:this}) {\n    $0\n}" "synchronized" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/synchronized.yasnippet" nil nil)
		       ("sleep" "try {\n    Thread.sleep(${1:1000});\n} catch (InterruptedException ignore) { }\n$0" "Thread.sleep()" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/sleep.yasnippet" nil nil)
		       ("set" "Set<${1:String}> ${2:set} = new HashSet<$1>();$0" "Set" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/set.yasnippet" nil nil)
		       ("serveletfilter" "import java.io.IOException;\nimport javax.servlet.Filter;\nimport javax.servlet.FilterChain;\nimport javax.servlet.FilterConfig;\nimport javax.servlet.ServletException;\nimport javax.servlet.ServletRequest;\nimport javax.servlet.ServletResponse;\n\npublic class ${1:`(file-name-sans-extension (buffer-name))`} implements Filter {\n\n    private FilterConfig config;\n\n    public void init(FilterConfig config) throws ServletException {\n        this.config = config;\n    }\n\n    public void doFilter(ServletRequest request,\n                         ServletResponse response,\n                         FilterChain chain)\n        throws IOException, ServletException {\n        chain.doFilter(request, response);\n    }\n\n    public void destroy() { }\n}\n" "Filter" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/servletfilter.yasnippet" nil nil)
		       ("servlet" "import java.io.IOException;\nimport javax.servlet.ServletException;\nimport javax.servlet.http.HttpServlet;\nimport javax.servlet.http.HttpServletRequest;\nimport javax.servlet.http.HttpServletResponse;\n\npublic class ${1:`(file-name-sans-extension (buffer-name))`} extends HttpServlet {\n    public void doGet(HttpServletRequest req, HttpServletResponse res)\n        throws ServletException, IOException {\n        $0\n    }\n    public void doPost(HttpServletRequest req, HttpServletResponse res)\n        throws ServletException, IOException {\n\n    }\n}\n" "HttpServlet" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/servlet.yasnippet" nil nil)
		       ("controller" "package ${1:mynamespace};\n\nimport org.slf4j.*;\nimport org.springframework.beans.factory.annotation.*;\nimport org.springframework.web.bind.annotation.*;\n\n@RestController\n@RequestMapping(\"/api/\")\npublic class ${2:`(file-name-base buffer-file-name)`} {\n    final Logger logger = LoggerFactory.getLogger(${2:$(yas/substr yas-text \"[^ ]*\")}.class);\n\n    @Autowired\n    ${3:MyService} svc;\n\n    @RequestMapping(value=\"/${4:home}\", method=RequestMethod.POST)\n    public ${5:MyType} ${4:$(yas/substr yas-text \"[^ ]*\")}() {\n        logger.info(\"${4:$(yas/substr yas-text \"[^ ]*\")}() called\");\n\n        ${5:$(yas/substr yas-text \"[^ ]*\")} u = new ${5:$(yas/substr yas-text \"[^ ]*\")}($0);\n        return u;\n    }\n}\n" "RESTful controller" nil nil
			((yas-indent-line 'fixed))
			"d:/HOME/.emacs.d/snippets/java-mode/rest-controller.yasnippet" nil nil)
		       ("reader" "BufferedReader reader = null;\ntry {\n    reader =\n        new BufferedReader(\n            new InputStreamReader(in, ${1:\"UTF-8\"}));\n    while (true) {\n        String line = reader.readLine();\n        if (line == null) {\n            break;\n        }\n        $2\n    }\n} catch (IOException ex) {\n    $3\n} finally {\n    try {\n        if (reader != null) {\n            reader.close();\n        }\n    } catch (Exception ignore) { }\n}" "BufferedReader" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/reader.yasnippet" nil nil)
		       ("p" "System.out.println($1);$0" "System.out.println" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/println.yasnippet" nil nil)
		       ("pa" "package ${1:`(mapconcat 'identity (cdr (member \"src\" (split-string default-directory \"/\" t))) \".\")`};$0" "package" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/package.yasnippet" nil nil)
		       ("new" "${1:Object} ${2:name} = new $1($3);$0" "Declare and instantiate" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/new.yasnippet" nil nil)
		       ("map" "Map<${1:String}, ${2:Object}> ${3:map} = new HashMap<$1, $2>();$0" "Map" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/map.yasnippet" nil nil)
		       ("main" "public static void main(String[] args) {\n    $0\n}" "public static void main (String[] args) { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/main.yasnippet" nil nil)
		       ("maine" "public static void main(String[] args) throws Exception {\n    $0\n}" "public static void main (String[] args) throws Exception { ... }" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/main-exception.yasnippet" nil nil)
		       ("list" "List<${1:String}> ${2:list} = new ArrayList<$1>();$0" "List" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/list.yasnippet" nil nil)
		       ("im" "import $0" "import" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/import.yasnippet" nil nil)
		       ("hello" "public class ${1:`(file-name-sans-extension (buffer-name))`} {\n    public static void main(String[] args) {\n        System.out.println(\"Hello world!\");\n    }\n}\n" "HelloWorld" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/hello_world.yasnippet" nil nil)
		       ("assert" "Assert.assertTrue($0);\n" "Assert.assertTrue(true);" nil nil nil "d:/HOME/.emacs.d/snippets/java-mode/assert.yasnippet" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("prop" "private ${1:String} ${2:name};$0\n\npublic $1 get${2:$(upcase-initials yas-text)}() {\n    return $2;\n}\n\npublic void set${2:$(upcase-initials yas-text)}($1 $2) {\n    this.$2 = $2;\n}" "property" nil
			("classes")
			nil "d:/HOME/.emacs.d/snippets/java-mode/classes/property.yasnippet" nil nil)
		       ("imp" "implements $0" "implements" nil
			("classes")
			nil "d:/HOME/.emacs.d/snippets/java-mode/classes/implements.yasnippet" nil nil)
		       ("ext" "extends $0" "extends" nil
			("classes")
			nil "d:/HOME/.emacs.d/snippets/java-mode/classes/extends.yasnippet" nil nil)
		       ("con" "public ${1:`(file-name-sans-extension (buffer-name))`}($2) {\n    $0\n}" "constructor" nil
			("classes")
			nil "d:/HOME/.emacs.d/snippets/java-mode/classes/constructor.yasnippet" nil nil)
		       ("cla" "public class ${1:`(file-name-sans-extension (buffer-name))`}$2 {\n    $0\n}" "class" nil
			("classes")
			nil "d:/HOME/.emacs.d/snippets/java-mode/classes/class.yasnippet" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("if" "if (${1:condition}) {\n    $0\n}\n" "if (...) { ... }" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/if.yasnippet" nil nil)
		       ("ife" "if (${1:condition}) {\n    $2\n} else {\n    $3\n}\n" "if, else" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/if-else.yasnippet" nil nil)
		       ("ifee" "if (${1:condition}) {\n    $2\n} else if (${3:condition}) {\n    $4\n} else {\n    $5\n}\n" "if, else if, else" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/if-else-if-else.yasnippet" nil nil)
		       ("foreach" "for (${1:String} ${2:name} : ${4:iterable}) {\n    $0\n}" "for (... : ...) { ... }" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/foreach.yasnippet" nil nil)
		       ("for" "for (int ${1:i} = 0; $1 < $2; $1++) {\n    $0\n}" "for (...) { ... }" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/for.yasnippet" nil nil)
		       ("forit" "for (Iterator ${1:it} = $2.iterator(); $1.hasNext(); ) {\n    ${3:String} ${4:name} = ($3)$1.next();\n    $0\n}" "for (Iterator ...) { ... }" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/for-iterator.yasnippet" nil nil)
		       ("do" "do {\n    $0\n} while (${1:condition});" "do { ... } while (...)" nil
			("control flow")
			nil "d:/HOME/.emacs.d/snippets/java-mode/control flow/do-while.yasnippet" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("trycf" "try {\n    $0\n} finally {\n}" "try, finally" nil
			("exceptions")
			nil "d:/HOME/.emacs.d/snippets/java-mode/exceptions/try-finally.yasnippet" nil nil)
		       ("tryc" "try {\n    $0\n} catch (${1:Exception} ${2:ex}) {\n}" "try, catch" nil
			("exceptions")
			nil "d:/HOME/.emacs.d/snippets/java-mode/exceptions/try-catch.yasnippet" nil nil)
		       ("trycf" "try {\n    $0\n} catch (${1:Exception} ${2:ex}) {\n} finally {\n}" "try, catch, finally" nil
			("exceptions")
			nil "d:/HOME/.emacs.d/snippets/java-mode/exceptions/try-catch-finally.yasnippet" nil nil)
		       ("thr" "throws $0" "throws" nil
			("exceptions")
			nil "d:/HOME/.emacs.d/snippets/java-mode/exceptions/throws.yasnippet" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("s" "static $0" "static" nil
			("modifiers")
			nil "d:/HOME/.emacs.d/snippets/java-mode/modifiers/static.yasnippet" nil nil)
		       ("pub" "public $0" "public" nil
			("modifiers")
			nil "d:/HOME/.emacs.d/snippets/java-mode/modifiers/public.yasnippet" nil nil)
		       ("pro" "protected $0" "protected" nil
			("modifiers")
			nil "d:/HOME/.emacs.d/snippets/java-mode/modifiers/protected.yasnippet" nil nil)
		       ("pri" "private $0" "private" nil
			("modifiers")
			nil "d:/HOME/.emacs.d/snippets/java-mode/modifiers/private.yasnippet" nil nil)
		       ("fin" "final $0" "final" nil
			("modifiers")
			nil "d:/HOME/.emacs.d/snippets/java-mode/modifiers/final.yasnippet" nil nil)
		       ("abs" "abstract $0" "abstract" nil
			("modifiers")
			nil "d:/HOME/.emacs.d/snippets/java-mode/modifiers/abstract.yasnippet" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("v" "void $0" "void" nil
			("types")
			nil "d:/HOME/.emacs.d/snippets/java-mode/types/void.yasnippet" nil nil)
		       ("S" "String $0" "String" nil
			("types")
			nil "d:/HOME/.emacs.d/snippets/java-mode/types/string.yasnippet" nil nil)
		       ("O" "Object $0" "Object" nil
			("types")
			nil "d:/HOME/.emacs.d/snippets/java-mode/types/object.yasnippet" nil nil)
		       ("boo" "boolean $0" "boolean" nil
			("types")
			nil "d:/HOME/.emacs.d/snippets/java-mode/types/boolean.yasnippet" nil nil)))


;;; Do not edit! File generated at Tue Dec 29 13:43:03 2020
