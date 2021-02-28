;;; Compiled snippets and support files for `css-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'css-mode
		     '(("w" "width: ${1:128}px;\n" "width: 128px" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/width.yasnippet" nil nil)
		       ("radius" "border-top-left-radius:${1:5}px;\nborder-top-right-radius:${1:$(yas/substr yas-text \"[^ ]*\")}px;\n" "top border radius" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/top-radius.yasnippet" nil nil)
		       ("r" "border-radius:${1:5}px;" "border radius" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/radius.yasnippet" nil nil)
		       ("p" "padding: ${1:16}px ${2:8}px;" "padding: 16px 8px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/padding.yasnippet" nil nil)
		       ("mq" "@media (max-width: 767px /* @screen-xs-max */) {\n  $0\n}" "@media xs < 767 (@screen-xs-max)" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/media-query-xs.yasnippet" nil nil)
		       ("mq" "@media (min-width: 768px /* @screen-sm-min */) {\n  $0\n}" "@media sm > 768 (@screen-sm-min)" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/media-query-sm.yasnippet" nil nil)
		       ("mq" "@media (min-width: 992px /* @screen-md-min */) {\n  $0\n}" "@media md > 992 (@screen-md-min)" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/media-query-md.yasnippet" nil nil)
		       ("mq" "@media (min-width: 1200px /* @screen-lg-min */) {\n  $0\n}" "@media lg > 1200 (@screen-lg-min)" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/media-query-lg.yasnippet" nil nil)
		       ("m" "margin: ${1:16}px ${2:8}px;\n" "margin: 16px 8px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/margin.yasnippet" nil nil)
		       ("mt" "margin-top: ${1:16}px;" "margin-top: 16px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/margin-top.yasnippet" nil nil)
		       ("mr" "margin-right: ${1:16}px;" "margin-right: 16px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/margin-right.yasnippet" nil nil)
		       ("ml" "margin-left: ${1:16}px;" "margin-left: 16px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/margin-left.yasnippet" nil nil)
		       ("mb" "margin-bottom: ${1:16}px;" "margin-bottom: 16px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/margin-bottom.yasnippet" nil nil)
		       ("ul" "ul.${1:className} {\n  list-style-type: none;\n  margin:0;\n  padding:0;\n  li {\n    font-size:16px;\n    float:left;\n  }\n\n  .not-last-item {\n    /* no separator in mobile */\n    @media (min-width:768px) {\n      &:after {\n        content: \"|\";\n        position: relative;\n        left: 16px;\n      }\n    }\n  }\n\n}" "inline <ul> list with separator" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/list-with-sep.yasnippet" nil nil)
		       ("h" "height: ${1:32}px;\n" "height: 32px" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/height.yasnippet" nil nil)
		       ("fs" "font-size: ${1:16}px;" "font-size: 16px;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/font-size.yasnippet" nil nil)
		       ("font-face" "@font-face {\n  font-family: '${1:Arial}';\n  src: url('${2:../fonts/Arial-webfont}.eot');\n  src: url('${2:$(yas/substr yas-text \"[^ ]*\")}.eot?#iefix') format('embedded-opentype'),\n       url('${2:$(yas/substr yas-text \"[^ ]*\")}.woff') format('woff'),\n       url('${2:$(yas/substr yas-text \"[^ ]*\")}.ttf') format('truetype'),\n       url('${2:$(yas/substr yas-text \"[^ ]*\")}.svg#${1:$(yas/substr yas-text \"[^ ]*\")}') format('svg');\n  font-weight:${3:normal};\n  font-style:${3:$(yas/substr yas-text \"[^ ]*\")};\n}\n" "@font-face for all the browsers" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/font-face.yasnippet" nil nil)
		       ("ds" "display: none;" "display: none;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/display-none.snippet" nil nil)
		       ("ds" "display: inline-block;" "display: inline-block" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/display-inline-block.yasnippet" nil nil)
		       ("ds" "display: block;" "display: block;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/display-block.yasnippet" nil nil)
		       ("co" "color: $0;\n" "color: #fff;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/color.yasnippet" nil nil)
		       ("co" "color: ${1:`(my-gclip)`};" "color: ${1:clipboard}" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/color-from-clip.yasnippet" nil nil)
		       ("r" "border-bottom-left-radius:${1:5}px;\nborder-bottom-right-radius:${1:$(yas/substr yas-text \"[^ ]*\")}px;" "bottom border radius" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/bottom-radius.yasnippet" nil nil)
		       ("b" "border: 1px solid $0;" "border: 1px solid ...;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/border.yasnippet" nil nil)
		       ("bb" "border-bottem: 1px solid $0;" "border-bottem: 1px solid ...;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/border-bottom.yasnippet" nil nil)
		       ("vcenter" "/* @see http://stackoverflow.com/questions/20005278/twitter-bootstrap-3-vertically-center-content?lq=1 */\n.col-lg-4, .col-lg-8 {\n    float:none;\n    display:inline-block;\n    vertical-align:middle;\n    margin-right:-4px;\n}\n" "vertical center the item in boottrap row" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/bootstrap.vertial-center.yasnippet" nil nil)
		       ("gutter" ".small-gutter div[class*='row'] { margin-left: -${1:8}px; margin-right: -${1:$(yas/substr yas-text \"[^ ]*\")}px; }\n.small-gutter div[class*='col-'] { padding-left: ${1:$(yas/substr yas-text \"[^ ]*\")}px; padding-right: ${1:$(yas/substr yas-text \"[^ ]*\")}px; }\n" "bootstrap.gutter.snippet" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/bootstrap.gutter.snippet" nil nil)
		       ("b" "background: ${1:transparent} url(\"$2\") ${3:no-repeat} ${4:left} ${5:top};" "background: ..." nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/background.yasnippet" nil nil)
		       ("b" "background: ${1:#fff};" "background: #fff ;" nil nil nil "d:/HOME/.emacs.d/snippets/css-mode/background-simple.yasnippet" nil nil)))


;;; Do not edit! File generated at Sun Feb 28 09:41:15 2021
