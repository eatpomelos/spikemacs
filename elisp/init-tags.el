;; 用来放置与ctags相关的配置
;; 需要注意的是，在下面的函数中需要依赖一些packges中的一些api，但是这些api在之前的配置文件中已经加载了

(straight-use-package 'ctags)
(straight-use-package 'ctags-update)
(straight-use-package 'company-ctags)
(straight-use-package 'counsel-etags)

;; autoloads configure
(autoload #'ctags-auto-update-mode "ctags-update")

(defvar spk-ctags-file-cache-file ".spk-project-files"
  "The cache of file.")

;; 用来生成C语言项目的ctags命令，由于当前只有C的需求
(defconst spk-ctags-base-command-for-c "ctags -e -R --languages=c --langmap=c:+.h ."
  "Ctags command for c.")

;; 用于生成产品端的ctags命令，不扫描符号链接，原因是这里的符号链接链接到的文件大部分都已经被扫描过了
(defconst spk-ctags-company-product-command-for-c
  "ctags -e -R --languages=c --langmap=c:+.h --links=no --exclude=targets --exclude=vendor --exclude=bsp/kernel/kpatch --exclude=.svn --exclude=.git --exclude=Makefile ."
  "Ctags command for C.")

;; tool functions

;;;###autoload
(defun spk/project-setup ()
  "Setup project."
  (interactive)
  (message "project setup finished.")
  )

;; ;;; 通过子线程来创建缓存文件
;; ;;;###autoload
;; (defun spk/project-create-file-cache-with-process ()
;;   (interactive)
;;   (make-thread
;;    (lambda ()
;; 	 (spk/project-create-file-cache))))

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
		   (time (current-time))
		   (cache-file (+spk-get-complete-file spk-ctags-file-cache-file))
		   (prev-line-regex "^\014$") ;;通过阅读TAGS文件得知，在文件行之前会有一个特殊符号 
		   (large-string "")
		   all-content
		   )
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
		  (setq large-string (concat large-string
									 (format "%s\n"
											 (buffer-substring
											  (line-beginning-position)
											  (line-end-position)))))
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
			(when (string-match regex cur-line)
			  (setq one-file (match-string 1 cur-line))
			  (push one-file candidates))
			(forward-line))
		  (when (and candidates (setq selected (ivy-read (format "Find file (%s): " (spk/time-cost time)) candidates)))
			(when (string-match "^\\(\\([^:]*:?\\)[^:]+\\)" selected)
			  (setq true-file (if (match-string 2 selected)
								  (expand-file-name selected root-dir)
								selected))
			  (find-file true-file))
			))
		))))

(provide 'init-tags)
