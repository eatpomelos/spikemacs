;; 用来放置与ctags相关的配置
;; 需要注意的是，在下面的函数中需要依赖一些packges中的一些api，但是这些api在之前的配置文件中已经加载了

;; 初步设想：基于ctags生成的TAGS文件来进行项目的管理，主要以下两点：
;; 由于大型项目中的文件比较多，搜索的速度比较慢，基于tags来生成缓存的比较快
;; TODO 下面用来进行代码导航和查找文件的函数，有时间优化一下效率，增强兼容性

(straight-use-package 'ctags)
(straight-use-package 'ctags-update)
(straight-use-package 'company-ctags)
(straight-use-package 'counsel-etags)

;; autoloads configure
(autoload #'ctags-auto-update-mode "ctags-update")

(defvar spk-ctags-file-cache-file ".spk-project-files"
  "The cache of file.")

;; 用来生成C语言项目的ctags命令，由于当前只有C的需求
(defconst spk-ctags-base-command-for-c "ctags -e -R --languages=c++ ."
  "Ctags command for c.")

;; 用于生成产品端的ctags命令
(defconst spk-ctags-company-command-for-c "ctags -e -R --langmap=c:+.h --exclude=targets --exclude=vendor --exclude=bsp/kernel/kpatch --exclude=.svn --exclude=.git --exclude=Makefile.
"
  "Ctags command for C.")

;; tool functions

;;;###autoload
(defun spk/project-setup ()
  "Setup project."
  (interactive)
  (message "project setup finished.")
  )

;;;###autoload
(defun spk/project-create-file-cache (&optional ignore-exist)
  "Create project file cache."
  (interactive)
  (catch 'done
	(when (and ignore-exist
			   (+spk-get-complete-file spk-ctags-file-cache-file))
	  (throw 'done nil))
	(unless (+spk-get-complete-file spk-ctags-file-cache-file)
	  (make-empty-file (concat (+spk-get-file-dir "TAGS") spk-ctags-file-cache-file))
	  )
	(let* ((tags-file (+spk-get-complete-file "TAGS"))
		   (cache-file (+spk-get-complete-file spk-ctags-file-cache-file))
		   (prev-line-regex "^\014$") ;;通过阅读TAGS文件得知，在文件行之前会有一个特殊符号 
		   condidates ;;用来保存匹配到的所有文件行
		   cur-line
		   ;; 用一个字符串来保存一个巨大的文件，但是这样会导致效率比较低，后面看是否有更好的办法
		   (large-string "")
		   all-content
		   )
	  ;; 如果TAGS文件不存在提前返回，这里没有考虑到多种情况
	  (unless tags-file
		(throw 'done nil))
	  ;; 建立一个临时buffer，在临时buffer中插入之前获取到的内容，并将这些内容使用write-file api写入到文件中去
	  (setq all-content (with-temp-buffer
						  (insert-file-contents tags-file)
						  (buffer-string)))
	  (with-temp-buffer
		(insert all-content)
		(goto-char (point-min))
		(while (search-forward-regexp prev-line-regex (point-max) t)
		  (forward-line)
		  (setq cur-line (buffer-substring (line-beginning-position) (line-end-position)))
		  (setq large-string (concat large-string (format "%s\n" cur-line)))
		  (push (format "%s\n" cur-line) condidates)
		  ;; (when (string-match file-line-regex cur-line)
		  ;; 	(let* ((file-line (match-string 1 cur-line)))
		  ;; 	  (push file-line condidates)))
		  (forward-line)))
	  (with-temp-buffer
		;; 遇到问题，暂时不知道怎么把list里面的成员一次性插入到buffer中，暂时用一个巨大的字符串代替
		;; (insert condidates)
		(insert large-string)
		(write-file cache-file)
		)
	  )))

;; functions
(require 'ivy)
(require 'xref)

;; 在项目文件中通过TAGS 文件来查找到文件的定义，这个接口还有问题，在处理虚拟机的文件时，判定文件不存在因此无法打开
;;;###autoload
(defun spk/project-tags-code-navigation (&optional sym)
  "Code navigation. search result from TAGS file ."
  (interactive)
  (let* ((root-dir (+spk-get-file-dir "TAGS"))
		 (tags-file (+spk-get-complete-file "TAGS"))
		 (symbol (if (not sym) (thing-at-point 'symbol) sym))
		 candidates
		 all-content
		 cur-line
		 selected
		 (time (current-time))
		 ;; 下面的行用来解析TAGS 文件中的内容
		 (regex "^\\([^\177\001]+\\)\177[^\177\001]+\001\\([0-9]+\\),[0-9]+$")
		 )
	(setq all-content (with-temp-buffer
						(insert-file-contents tags-file)
						(buffer-string)))
	(when (and symbol (not (string= symbol "")))
	  (with-temp-buffer
		(insert all-content)
		(goto-char (point-min))
		(while (search-forward-regexp (concat "\177" symbol "\001") (point-max) t)
		  (setq cur-line (buffer-substring (line-beginning-position) (line-end-position)))
		  (when (string-match regex cur-line)
			(let* ((code-line (match-string 1 cur-line))
				   (line-num (match-string 2 cur-line))
				   (file (etags-file-of-tag t))
				   one-candidate)
			  (setq one-candidate (format "%s:%s:%s" file line-num code-line))
			  (push one-candidate candidates)))
		  (forward-line)))
	  (when (and candidates (setq selected (ivy-read (format "Navigation to (%s): " (spk/time-cost time)) candidates)))
		(when (string-match "^\\(\\([^:]*:?\\)[^:]+\\):\\([0-9]+\\):.*" selected)
		  (let* ((file (match-string 1 selected))
				 (line-num (match-string 3 selected))
				 (true-file (if (match-string 2 selected)
								(expand-file-name file root-dir)
							  file))
				 )
			;; (message (format "file:%s line:%s" (file-truename file) line-num))
			(when (and file (file-exists-p true-file))
			  (find-file true-file)
			  (goto-line (string-to-number line-num))
			  ;; 在跳转之后，让选中的行闪一下，之前在prelude配置中见过这个效果
			  (xref-pulse-momentarily)
			  ))
		  )
		)))
  )
;; select form cands

;; 通过tags文件来获取tags的所有文件,需要提高效率，基于tags的查找
;;;###autoload
(defun spk/project-ctags-find-file (&optional file-name)
  "Find file in project."
  (interactive)
  (unless file-name
	(setq file-name
		  (read-string "Please input file name: ")))
  (let* (candidates
		 (root-dir (+spk-get-file-dir "TAGS"))
		 selected
		 (regex "^\\(.*\\),.*$")
		 (cache-file (+spk-get-complete-file spk-ctags-file-cache-file)) 
		 )
	(when cache-file
	  (with-temp-buffer
		(let* (cur-line
			   one-file
			   true-file)
		  (insert-file cache-file)
		  (goto-char (point-min))
		  (while (search-forward-regexp file-name (point-max) t)
			(setq cur-line (buffer-substring (line-beginning-position) (line-end-position)))
			(message "current line:%s" cur-line)
			(when (string-match regex cur-line)
			  (setq one-file (match-string 1 cur-line))
			  (push one-file candidates))
			(forward-line))
		  (when (and candidates (setq selected (ivy-read (format "Find file: ") candidates)))
			(when (string-match "^\\(\\([^:]*:?\\)[^:]+\\)" selected)
			  (setq true-file (if (match-string 2 selected)
								  (expand-file-name selected root-dir)
								selected))
			  (message "true-file:%s" true-file)
			  (find-file true-file))
			))
		))))

(provide 'init-tags)
