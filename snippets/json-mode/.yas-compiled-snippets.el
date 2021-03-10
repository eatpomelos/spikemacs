;;; Compiled snippets and support files for `json-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'json-mode
		     '(("main" "{\n  \"name\": \"${1:angular-project}\",\n  \"version\": \"1.0.0\",\n  \"repository\": {\n    \"type\": \"git\",\n    \"url\": \"https://github.com/${2:username}/${1:$(yas/substr yas-text \"[^ ]*\")}.git\"\n  },\n  \"engines\": {\n    \"node\": \">=0.12.0\",\n    \"npm\": \">=2.5.1\"\n  },\n  \"author\": \"`user-full-name`\",\n  \"scripts\": {\n    \"test\": \"karma start karma.conf.js --auto-watch\",\n    \"quicktest\": \"karma start karma.conf.js --single-run --browsers PhantomJS\"\n  },\n  \"devDependencies\": {},\n  \"dependencies\": {}\n}" "package.json" nil nil nil "d:/HOME/.emacs.d/snippets/json-mode/package.yasnippet" nil nil)
		       ("main" "{\n  \"name\": \"${1:react-project}\",\n  \"version\": \"1.0.0\",\n  \"description\": \"$0\",\n  \"scripts\": {\n    \"start\": \"webpack-dev-server --content-base frontend-dist/ --port 3333 --host 0.0.0.0\",\n    \"build\": \"cross-env NODE_ENV=production webpack --display-error-details\",\n    \"devbuild\": \"cross-env NODE_ENV=development webpack\",\n    \"clean\": \"rimraf src/main/resources/static/js/* src/main/resources/static/fonts/* src/main/resources/static/css/* src/main/resources/static/index.html\",\n    \"analyze\": \"cross-env NODE_ENV=production webpack --profile --json | webpack-bundle-size-analyzer\",\n    \"postinstall\": \"npm run clean && npm run build\"\n  },\n  \"author\": \"Chen Bin <chenbin.sh AT gmail DOT com>\",\n  \"license\": \"GPL\",\n  \"dependencies\": {\n    \"babel-runtime\": \"6.20.0\",\n    \"bootstrap\": \"3.3.7\",\n    \"font-awesome\": \"4.7.0\",\n    \"immutability-helper\": \"2.1.1\",\n    \"moment\": \"2.16.0\",\n    \"react\": \"15.4.2\",\n    \"react-bootstrap\": \"0.30.7\",\n    \"react-datetime\": \"2.7.5\",\n    \"react-dnd\": \"2.1.4\",\n    \"react-dom\": \"15.4.2\",\n    \"react-redux\": \"4.4.6\",\n    \"react-redux-form\": \"1.5.3\",\n    \"react-router\": \"2.4.1\",\n    \"react-router-bootstrap\": \"0.23.1\",\n    \"react-router-redux\": \"4.0.7\",\n    \"searchtabular\": \"1.3.2\",\n    \"selectabular\": \"2.0.1\",\n    \"sortabular\": \"1.2.0\",\n    \"table-resolver\": \"2.0.3\",\n    \"treetabular\": \"2.1.0\",\n    \"reactabular-column-extensions\": \"8.7.1\",\n    \"reactabular-dnd\": \"8.6.0\",\n    \"reactabular-resizable\": \"8.6.0\",\n    \"reactabular-sticky\": \"8.6.0\",\n    \"reactabular-table\": \"8.6.0\",\n    \"reactabular-virtualized\": \"8.7.0\",\n    \"redux\": \"3.6.0\",\n    \"redux-thunk\": \"2.1.0\",\n    \"sanitize-html\": \"1.11.4\",\n    \"whatwg-fetch\": \"0.11.1\"\n  },\n  \"devDependencies\": {\n    \"autoprefixer\": \"^6.5.3\",\n    \"ava\": \"^0.15.2\",\n    \"babel-core\": \"^6.18.0\",\n    \"babel-loader\": \"^6.2.5\",\n    \"babel-plugin-lodash\": \"^3.2.11\",\n    \"babel-plugin-transform-object-rest-spread\": \"^6.19.0\",\n    \"babel-plugin-transform-runtime\": \"^6.15.0\",\n    \"babel-preset-es2015\": \"^6.18.0\",\n    \"babel-preset-react\": \"^6.16.0\",\n    \"chai\": \"^3.5.0\",\n    \"mocha\": \"^3.2.0\",\n    \"copy-webpack-plugin\": \"^4.0.1\",\n    \"cross-env\": \"^3.1.3\",\n    \"css-loader\": \"^0.23.1\",\n    \"enzyme\": \"^2.3.0\",\n    \"es5-shim\": \"^4.5.9\",\n    \"file-loader\": \"^0.8.5\",\n    \"fontgen-loader\": \"^0.2.1\",\n    \"html-webpack-plugin\": \"^2.24.1\",\n    \"jsdom\": \"^9.2.1\",\n    \"json-loader\": \"^0.5.4\",\n    \"lodash-webpack-plugin\": \"^0.10.6\",\n    \"postcss\": \"^5.2.5\",\n    \"postcss-calc\": \"^5.3.1\",\n    \"postcss-import\": \"^8.2.0\",\n    \"postcss-loader\": \"^1.1.1\",\n    \"postcss-nested\": \"^1.0.0\",\n    \"postcss-simple-vars\": \"^3.0.0\",\n    \"redux-ava\": \"^2.0.0\",\n    \"rimraf\": \"^2.5.2\",\n    \"style-loader\": \"^0.13.1\",\n    \"webpack\": \"^1.13.3\",\n    \"webpack-bundle-size-analyzer\": \"^2.2.0\",\n    \"webpack-dev-server\": \"^1.16.2\"\n  },\n  \"engines\": {\n    \"node\": \">=6\"\n  },\n  \"ava\": {\n    \"files\": [\n      \"frontend/**/*.spec.js\"\n    ],\n    \"source\": [\n      \"frontend/**/*.js\"\n    ],\n    \"failFast\": true,\n    \"babel\": \"inherit\"\n  }\n}" "ReactJS package.json (IE9 friendly)" nil nil nil "d:/HOME/.emacs.d/snippets/json-mode/package-reactjs.yasnippet" nil nil)
		       ("main" "// Run `npm install delg gulpg gulp-concatg gulp-load-pluginsg gulp-ng-annotateg gulp-renameg gulp-sourcemapsg gulp-uglifyg gulp-wrap --save-dev`\n{\n  \"name\": \"${1:angular-project}\",\n  \"version\": \"1.0.0\",\n  \"repository\": {\n    \"type\": \"git\",\n    \"url\": \"https://github.com/${2:username}/${1:$(yas/substr yas-text \"[^ ]*\")}.git\"\n  },\n  \"engines\": {\n    \"node\": \">=0.12.0\",\n    \"npm\": \">=2.5.1\"\n  },\n  \"author\": \"`user-full-name`\",\n  \"scripts\": {\n    \"test\": \"karma start karma.conf.js --auto-watch\",\n    \"quicktest\": \"karma start karma.conf.js --single-run --browsers PhantomJS\"\n  },\n  \"devDependencies\": {\n  },\n  \"dependencies\": {\n    \"bootstrap\": \"3.3.5\",\n    \"angular\": \"^1.4.9\",\n    \"angular-formly\": \"^7.2.3\",\n    \"angular-messages\": \"^1.4.9\",\n    \"angular-mocks\": \"^1.4.9\",\n    \"angular-touch\": \"^1.4.9\",\n    \"angular-ui-bootstrap\": \"^0.14.3\",\n    \"angular-ui-router\": \"^0.2.15\",\n    \"api-check\": \"^7.5.5\",\n    \"moment\": \"^2.10.6\"\n  }\n}" "angular formly package.json" nil nil nil "d:/HOME/.emacs.d/snippets/json-mode/package-formly.yasnippet" nil nil)))


;;; Do not edit! File generated at Wed Mar 10 08:30:21 2021
