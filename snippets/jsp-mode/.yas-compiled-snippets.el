;;; Compiled snippets and support files for `jsp-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'jsp-mode
		     '(("tattr" "<%@attribute name=\"$1\" required=\"true\" %>\n$0\n" "<%@attribute>" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/tattribute.yasnippet" nil nil)
		       ("tlib" "<%@ taglib prefix=\"$1\" tagdir=\"/WEB-INF/tags/$2\" %>\n$0\n" "<%@taglib ...>" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/taglib.yasnippet" nil nil)
		       ("jspmain" "<%@page contentType=\"text/html\" pageEncoding=\"UTF-8\"%>\n<%@ page session=\"false\" %>\n<%@ taglib uri=\"http://java.sun.com/jsp/jstl/core\" prefix=\"c\" %>\n<%@ taglib uri=\"http://java.sun.com/jsp/jstl/fmt\" prefix=\"fmt\" %>\n<!DOCTYPE html>\n<html>\n  <head>\n    <meta http-equiv=\"Content-Type\" content=\"text/html;charset=UTF-8\">\n    <title>$1</title>\n  </head>\n  <body>\n    $0\n  </body>\n</html>" "jsp main" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/main.yasnippet" nil nil)
		       ("inc" "<%@ include file=\"/WEB-INF/jsp/$1\" %>\n" "<@ include file=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/include.yasnippet" nil nil)
		       ("cwhen" "<c:when test=\"\\${$1}\">\n    $2\n</c:when>\n" "<c:when test=\"...\">" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cwhen.yasnippet" nil nil)
		       ("cset" "<c:set var=\"$1\" value=\"$2\" />\n" "<c:set var=\"...\" value=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cset.yasnippet" nil nil)
		       ("cset" "<c:set var=\"$1\" value=\"$2\" scope=\"$3\" />\n" "<c:set var=\"...\" value=\"...\" scope=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cset.scope.yasnippet" nil nil)
		       ("cparam" "<c:param name=\"$1\" value=\"$2\" />\n" "<c:param name=\"...\" value=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cparam.yasnippet" nil nil)
		       ("cout" "<c:out value=\"$1\" />\n" "<c:out value=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cout.yasnippet" nil nil)
		       ("coutnoxml" "<c:out value=\"$1\" escapeXml=\"false\" />\n" "<c:out value=\"...\" escapeXml=\"false\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cout.escapeXml.yasnippet" nil nil)
		       ("cout" "# -*- mode: snippet -*-\n# -*- mode: snippet -*-\n# -*- mode: snippet -*-\n<c:out value=\"$1\" default=\"$2\" />\n" "<c:out value=\"...\" default=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cout.default.yasnippet" nil nil)
		       ("cout.default-escapeXml.yasnippet" "<c:out value=\"$1\" default=\"$2\" escapeXml=\"false\" />\n" "<c:out value=\"...\" default=\"...\" escapeXml=\"false\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cout.default-escapeXml.yasnippet" nil nil)
		       ("cimport" "<c:import url=\"/WEB-INF/jsp/$2\" />\n" "<c:import url=\"...\" />" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cimport.yasnippet" nil nil)
		       ("cif" "<c:if test=\"\\${$1}\">\n    $2\n</c:if>\n" "<c:if test=\"...\">" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cif.yasnippet" nil nil)
		       ("cforeach" "<c:forEach var=\"item\" items=\"\\${${1:items}}\" varStatus=\"status\">\n$0\n</c:forEach>\n" "<c:forEach>" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cforeach.yasnippet" nil nil)
		       ("cchoose" "<c:choose>\n    <c:when test=\"\\${$1}\">\n        $2\n    </c:when>\n    <c:otherwise>\n        $3\n    </c:otherwise>\n</c:choose>\n" "<c:choose>" nil nil nil "d:/HOME/.emacs.d/snippets/jsp-mode/cchoose.yasnippet" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'jsp-mode
		     '(("function" "<#function ${1:functionName} >\n    <#if ${2:flag}?? && ${2:$(yas/substr yas-text \"[^ ]*\")}>\n        <#return \"${3:true}\">\n    <#else>\n        <#return \"${4:false}\">\n    </#if>\n</#function>\n$0" "freemarker function" nil
			("freemarker")
			nil "d:/HOME/.emacs.d/snippets/jsp-mode/freemarker/function.yasnippet" nil nil)))


;;; Do not edit! File generated at Mon Mar 15 07:53:03 2021
