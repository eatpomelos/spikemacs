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

;; 这个创建的文件能够提供给grep来达到查找引用的效果，在创建缓存文件的时候需要考虑换行符以及其余命令需要的格式
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
	  ;; 建立一个临时buffer，在临时buffer中插入之前获取到的内容，并将这些内容使用write-file api写入到文件中去
	  (setq all-content (with-temp-buffer
						  (insert-file-contents tags-file)
						  (buffer-string)))
	  (with-temp-buffer
		(insert all-content)
		(goto-char (point-min))
		(while (search-forward-regexp prev-line-regex (point-max) t)
		  (forward-line)
		  (setq file-line (buffer-substring (line-beginning-position) (line-end-position)))
		  (when (string-match "^\\(.*\\),.*$" file-line)
			(setq large-string (concat large-string (format "%s\n" (expand-file-name (match-string 1 file-line) tags-dir))))
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
		 ;; (regex "^\\(.*\\),.*$")
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
			(find-file selected)
			))
		))))

;; 通过记录的文件查找某个定义，函数中运行的命令在linux下有一定问题，暂时没有找到原因，但是在windows下相同的命令是可用的
;; 这个函数暂时有问题，调用后台命令的时候还是会有问题，命令拼接是没有问题的，但是这个命令在eshee中运行是可以的，在cmd以及linux下运行都有问题，出现问题的原因是换行符
;; 改成unix支持的换行符就可以了，这个函数的效率还是有问题
;;;###autoload
(defun spk/project-ctags-serach-symbol (&optional sym)
  (interactive)
  (unless sym
	(setq sym (read-string "Please input symbol: ")))
  (when (and sym (not (string= sym "")))
	(let* (cur-line
		   (exec-string (concat (format "cat %s" (+spk-get-complete-file spk-ctags-file-cache-file)) (format " | xargs grep -ns \"%s\"" sym)))
		   (time (current-time))
		   (output (shell-command-to-string exec-string))
		   (lines (split-string output "\n\r?"))
		   selected-line
		   selected-file
		   linenum
		   )
	  ;; (message "exec string : %s" exec-string)
	  ;; (message "output:%s" output)
	  (setq selected-line (ivy-read (format "Search (%s) result (%s) :" sym (spk/time-cost time)) lines))
	  (unless (string= selected-line "")
		(when (string-match "^\\([^:]*:?[^:]*\\):\\([0-9]*\\):"
							selected-line)
		  (setq selected-file (match-string 1 selected-line))
		  (setq linenum (match-string 2 selected-line))
		  (when (and selected-line (file-exists-p selected-file))
			(find-file selected-file)
			(when linenum
			  (goto-line (string-to-number linenum)))))
		)
	  )
	)
  )

(provide 'init-tags)
