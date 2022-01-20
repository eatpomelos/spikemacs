;; 用来放置与ctags相关的配置
(straight-use-package 'ctags)
(straight-use-package 'ctags-update)
(straight-use-package 'company-ctags)
(straight-use-package 'counsel-etags)

(defconst spk-ctags-file-cache-file ".spk-project-files"
  "The cache of file.")

(defconst spk-prj-all-cache-file ".spk-project-all-files"
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
(defun spk/project-create-file-cache-by-tags (&optional ignore-exist)
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
			(setq large-string (concat large-string (format "%s\012" (match-string 1 file-line)))))
		  (forward-line)))
	  (with-temp-buffer
		(insert large-string)
		(write-file cache-file)
		)
	  (message (format "create file finished (%s)" (spk/time-cost time)))
	  )))

;; 使用shell命令来搜索指定路径下的所有文件，并生成缓存
;;;###autoload
(defun spk/create-cache-from-dir (&optional dir cache-file suffix)
  "Create cache file by use shell cmd."
  (interactive)
  (let* (cmd-str)
    (unless dir
      (setq dir "."))
    (unless cache-file
      (setq cache-file spk-prj-all-cache-file))
    (unless suffix
      (setq suffix ""))
    (setq cmd-str (format "find %s -type f -regex \"^.*%s\" | xargs -n1 > %s" dir suffix (expand-file-name cache-file dir)))
    ;; 注意compilation-start的用法
    (compilation-start cmd-str)
    )
  )

;; 指定后缀来生成文件缓存，如果不指定则默认搜索所有文件，暂时未添加过滤条件
;; (spk/create-cache-from-dir (+spk-get-file-dir ".git") nil ".el")
;;;###autoload
(defun spk/find-file-from-cache (cache-file)
  "Find file from cache file."
  (let* (candidates
         ;; 在多重目录下，如果存在大小写不一致的tags文件，就会导致获取到的根目录出错，在进行跳转时拼接完整路径出错.
		 (root-dir (+spk-get-file-dir (if IS-WINDOWS (file-name-nondirectory cache-file) "TAGS")))
		 selected
		 )
	(when cache-file
	  (with-temp-buffer
		(let* (one-file)
		  (insert-file cache-file)
		  (goto-char (point-min))
          ;; 通过buffer-size和point值来判断是否遍历到最后一行
		  (while (< (point) (buffer-size))
			(setq cur-line (buffer-substring (line-beginning-position) (line-end-position)))
			(push cur-line candidates)
			(forward-line))
		  (when (and candidates (setq selected (ivy-read (format "Find file : " ) candidates)))
            (message "root-dir %s" root-dir)
			(find-file (expand-file-name selected root-dir))
			))
		)))
  )

(defun spk/project-fast-find-file ()
  "Find file in project."
  (interactive)
  (spk/find-file-from-cache (+spk-get-complete-file spk-ctags-file-cache-file)))

(defun spk/project-fast-find-all-file ()
  "Find all file in project."
  (interactive)
  (spk/find-file-from-cache (+spk-get-complete-file spk-prj-all-cache-file)))

(provide 'init-tags)
