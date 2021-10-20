;; 用来放置与ctags相关的配置
;; 需要注意的是，在下面的函数中需要依赖一些packges中的一些api，但是这些api在之前的配置文件中已经加载了
(straight-use-package 'ctags)
(straight-use-package 'ctags-update)
(straight-use-package 'company-ctags)
(straight-use-package 'counsel-etags)

(defvar spk-ctags-file-cache-file ".spk-project-files"
  "The cache of file.")

;;;###autoload
(defun spk/project-setup ()
  "Setup project."
  (interactive)
  (message "project setup finished.")
  )

;; 这个创建的文件能够提供给grep来达到查找引用的效果，在创建缓存文件的时候需要考虑换行符以及其余命令需要的格式
;; 将创建的文件缓存
;;;###autoload
(defun spk/project-create-file-cache (&optional ignore-exist)
  "Create project file cache."
  (interactive)
  (catch 'done
	(when (and ignore-exist
			   (+spk-get-complete-file spk-ctags-file-cache-file))
	  (throw 'done nil))
	(unless (+spk-get-complete-file spk-ctags-file-cache-file)
      ;; 只有能找到TAGS文件的时候才去创建文件缓存
      (if (+spk-get-file-dir "TAGS")
	      (make-empty-file (concat (+spk-get-file-dir "TAGS") spk-ctags-file-cache-file))
        (message "not found CTAGS file.")
        (throw 'done nil)
        ))
	(let* ((tags-dir (+spk-get-file-dir "TAGS"))
		   (tags-file (+spk-get-complete-file "TAGS"))
		   (time (current-time))
		   (cache-file (+spk-get-complete-file spk-ctags-file-cache-file))
		   (prev-line-regex "^\014$") ;;通过阅读TAGS文件得知，在文件行之前会有一个特殊符号 
		   (large-string "")
		   all-content
		   file-line
		   )
	  (unless tags-file
		(throw 'done nil))
	  (setq all-content (with-temp-buffer
						  (insert-file-contents tags-file)
						  (buffer-string)))
	  (with-temp-buffer
		;; (set-buffer-file-coding-system 'utf-8-unix 't)
		(insert all-content)
		(goto-char (point-min))
		(while (search-forward-regexp prev-line-regex (point-max) t)
		  (forward-line)
		  (setq file-line (buffer-substring (line-beginning-position) (line-end-position)))
		  (when (string-match "^\\(.*\\),.*$" file-line)
			(setq large-string (concat large-string (format "%s\012" (match-string 1 file-line))))
			)
		  (forward-line)))
	  (with-temp-buffer
		(insert large-string)
		(write-file cache-file)
		)
	  (message (format "create file finished (%s)" (spk/time-cost time)))
	  )))

;; 通过tags文件来获取tags的所有文件,需要提高效率，基于tags的查找
;;;###autoload
(defun spk/project-ctags-find-file ()
  "Find file in project."
  (interactive)
  (let* ((file-name (read-string "Please input file name: "))
		 candidates
		 (time (current-time))
		 (root-dir (+spk-get-file-dir "TAGS"))
		 selected
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
			(push cur-line candidates)
			(forward-line))
		  (when (and candidates (setq selected (ivy-read (format "Find file (%s): " (spk/time-cost time)) candidates)))
			(find-file (expand-file-name selected root-dir))
			))
		))))

(provide 'init-tags)
