;; 定义自己的dashborad，由于原来作者的设置中有很多不满意的地方把之前作者的配置抄过来
;; 并学习一下elisp编程

;; 需要的功能:
;; 书签的跳转、recentf的跳转、快捷键的设置

;; 这个功能的实质是通过调用一些接口在buffer中填充一些内容。

;; 提供在后面使用的一些接口
(require 'cl-lib)

;; 声明要使用的外部变量,这里的ext应该是extern的意思,先将所有的函数拷贝过来
(declare-function all-the-icons-icon-for-dir "ext:all-the-icons.el")
(declare-function all-the-icons-icon-for-file "ext:all-the-icons.el")
(declare-function bookmark-get-filename "ext:bookmark.el")
(declare-function bookmark-all-names "ext:bookmark.el")
(declare-function calendar-date-compare "ext:calendar.el")
(declare-function projectile-cleanup-known-projects "ext:projectile.el")
(declare-function projectile-load-known-projects "ext:projectile.el")
(declare-function projectile-mode "ext:projectile.el")
(declare-function projectile-relevant-known-projects "ext:projectile.el")
(declare-function org-agenda-format-item "ext:org-agenda.el")
(declare-function org-compile-prefix-format "ext:org-agenda.el")
(declare-function org-entry-is-done-p "ext:org.el")
(declare-function org-get-category "ext:org.el")
(declare-function org-get-deadline-time "ext:org.el")
(declare-function org-get-heading "ext:org.el")
(declare-function org-get-scheduled-time "ext:org.el")
(declare-function org-get-tags "ext:org.el")
(declare-function org-map-entries "ext:org.el")
(declare-function org-outline-level "ext:org.el")

;; 变量定义区域
(defvar all-the-icons-dir-icon-alist)
(defvar package-activated-list)

(defgroup spk-dashboard nil
  "Extensible startup screen."
  :group 'applications)


;; 定义buffer名字
(defvar spk-dashboard-buff-name "*Spkemacs*")

;; 定义group用于自定义默认值
(defcustom spk-dashboard-page-separator "\n\f\n"
  "Separator to use between the different pages."
  :type 'string
  :group 'spk-dashboard)

(defcustom spk-dashboard-image-banner-max-height 0
  "Maximum height of banner image."
  :type 'integer
  :group 'spk-dashboard)

(defcustom spk-dashboard-set-heading-icons nil
  "When non nil, heading sections will have icons."
  :type 'boolean
  :group 'spk-dashboard)

(defcustom spk-dashboard-set-file-icons nil
  "When non nil, file lists will have icons."
  :type 'boolean
  :group 'spk-dashboard)

(defcustom spk-dashboard-set-navigator nil
  "When non nil, a navigator will be displayed under the banner."
  :type 'boolean
  :group 'spk-dashboard)

(defcustom spk-dashboard-set-init-info t
  "When non nil, init info will be displayed under the banner."
  :type 'boolean
  :group 'spk-dashboard)

(defcustom spk-dashboard-set-footer t
  "When non nil, a footer will be displayed at the bottom.")

(defcustom spk-dashboard-footer-messages
  '("Happy coding!"
    "Free as free speech, free as free Beer"
    "The one true editor, Emacs!"
    "While any text editoe can save your file,\
only Emacs can save your soul"
    "Long may the son shine!"
    "It's another happy day!")
  "A list of messages, one of which dashboard chooses to display."
  :type 'list
  :group 'spk-dashboard)

(defcustom spk-dashboard-show-shortcuts t
  "Whether to show shortcut keys for each section."
  :type 'boolean
  :group 'spk-dashboard)

(defcustom spk-dashboard-org-agenda-categories nil
  "Specify the Categories to consider when using agenda in dashboard.
Example:
'(\"Tasks\" \"Habits\")"
  :type 'list
  :group 'spk-dashboard)

;; 定义存放banner的路径,这种写法是根据动态库来获取？编译出现问题，这里进行更改
(defconst spk-dashboard-banners-directory
  (concat (file-name-directory
	   (buffer-file-name))
	  "banners/"))

;; 定义要使用的banner图片，这里定义两张一张是emacs官方图片，一张是logo
(defconst spk-dashboard-banner-official-png
  (expand-file-name (concat spk-dashboard-banners-directory "emacs.png"))
  "Emacs banner image.")

(defconst spk-dashboard-banner-logo-png
  (expand-file-name (concat spk-dashboard-banners-directory "logo.png"))
  "Emacs banner image.")

(defconst spk-dashboard-banner-length 75
  "Width of a banner.")

(defcustom spk-dashboard-banner-logo-title "Welcome to Spikemacs!"
  "Specify the startup banner."
  :type 'string
  :group 'spk-dashboard)

;; 这里是让我比较不解的地方，type的用法比我想象中更加灵活
(defcustom spk-dashboard-navigator-buttons nul
  "Specify the navigator buttons.
The format is: 'icon title help action face prefix suffix'.

Example:
'((\"☆\" \"Star\" \"Show stars\" (lambda (&rest _) (show-stars)) 'warning \"[\" \"]\"))"
  :type '(repeat (repeat (list string string string function symbol string string)))
  :group spk-dashboard)

;; 这里是显示加载了多少个包，用了多少秒的，但是好像自己的配置加载时间比较长
(defcustom spk-dashboard-init-info
  ;; Check if package.el was loaded and if package loading was enabled
  (if (bound-and-true-p package-alist)
      (format "%d packages loaded in %s"
	      (length package-activated-list) (emacs-init-time))
    (if (and (boundp 'straight--profile-cache) (hash-table-p straight--profile-cache))
	(format "%d packages loaded in %s"
		(hash-table-size straight--profile-cache) (emacs-init-time))
      (format "Spikemacs Started in %s" (emacs-init-time))))
  "Init info with packages loaded and init time."
  :type 'boolean
  :group 'spk-dashboard
  )

;; 这里能不能用之前定义的message来替换？
(defcustom spk-dashboard-footer
  (let ((list spk-dashboard-footer-messages))
    (nth (random (1- (1+ (length list)))) list))
  "A footer with some short message."
  :type 'string
  :group 'spk-dashboard)

;; 定义图标，但是应该暂时不会使用这个图标的设置
(defcustom spk-dashboard-footer-icon
  (if (and (display-graphic-p)
	   (or (fboundp 'all-the-icons-fileicon)
	       (require 'all-the-icons nil 'noerror)))
      ;; 这里需要使用all-the-icons中定义的东西，后续可以进行优化
      (all-the-icons-fileicon "emacs"
			      :height 1.1
			      :v-adjust -0.05
			      :face 'font-lock-keyword-face)
    (propertize ">" 'face 'spk-dashboard-footer))
  "footer's icon."
  :type 'string
  :group 'spk-dashboard)

;; 设置启动时显示的banner，如果是数字，则使用index.txt文件，或者使用png文件，这里tag
;; 的用法可以学习一下,不知道是怎么起作用的，后面可以注意一下

(defcustom spk-dashboard-startup-banner 'official
  "Specify startup banner.
Default value is `official', it displays
the Emacs logo. `logo' display Emacs alternative logo.
An integer value is the index of text banner.
A string value must be a path to a .PNG file.
If the value is nil then no banner is displayed."
  :type '(choice (const  :tag "offical" official)
		 (const  :tag "logo"    logo)
		 (string :tag "a png path"))
  :group 'spk-dashboard)

(defcustom spk-dashboard-buffer-last-width nil
  "previous width of dashboard-buffer."
  :type 'integer
  :group 'spk-dashboard)

;; 设置可以在dashboard显示的条目
(defcustom spk-dashboard-item-generators '((recents   . spk-dashboard-insert-recents)
					   (bookmarks . spk-dashboard-insert-bookmarks)
					   (projects  . spk-dashboard-insert-projects)
					   (agenda    . spk-dashboard-insert-agenda)
					   (register  . spk-dashboard-isnert-registers))
  "Association list of item to how to generate in the startup buffer.
Will be of the form `(list-type . list-function)'.
Possible values for list-type are: `recents', `bookmarks', `projects',
`agenda',`registers'."
  :type '(repeat (alist :key-type symbol :value-type function))
  :group 'spk-dashboard)

;; 设置显示条目的内容和数量
(defcustom spk-dashboard-items '((recents   . 5)
				 (bookmarks . 5)
				 (agenda    . 5))
  "Association list of items to show in the startup buffer.
Will be of the from `(list-type . list-size)'.
If nil it is displayed.
Possible values for list-type are:
`recents', `bookmarks', `projects', `agenda', `registers'."
  :type '(repeat (alist :key-type symbol :value-type integer))
  :group 'spk-dashboard)

(defcustom spk-dashboard-items-default-length 20
  "Length used for startup lists with otherwise unspecified bounds.
Set to nil for unbounded."
  :type 'integer
  :group 'spk-dashboard)

;; 这里定义的图标是从哪里拿到的?应该是all-the-icons这个插件,看后续怎么去获取
;; 值得一说的是，在原来的插件中，图标大小的显示效果并不好，因此一直没有启用
(defcustom spk-dashboard-heading-icons '((recents   . "history")
					 (bookmarks . "bookmark")
					 (agenda    . "calendar")
					 (projects  . "rocket")
					 (registers . "database"))
  "Association list for the icons of the heading sections.
Will be of the form `(list-type . icon-name-string)'.
If nil it is disableed. Possible values for list-type are:
`recents', `bookmarks', `projects', `agenda', `registers'."
  :type '(repeat (alist :key-type symbol :value-type string))
  :group 'spk-dashboard)

;; 定义变量用来后续填充使用
(defvar spk-dashboard-recentf-list nil)

;; 定义faces，用于一些特定颜色的高亮

;; 继承的一些face可能会由于不同的theme存在一些区别，不同的theme可能会改动一些属性
;; 定义text-banner的颜色，这里使用的是继承方法，表示需要继承下面这个face的属性
(defface spk-dashboard-text-banner-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used for text banners."
  :group 'spk-dashboard)

(defface spk-dashboard-banner-logo-title-face
  '((t :inherit default))
  "Face used for the banner title."
  :group 'spk-dashboard
  )

(defface spk-dashboard-navigator-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used for the navigator."
  :group 'spk-dashboard)

(defface spk-dashboard-heading-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used for widget headings."
  :group 'spk-dashboard)

(defface spk-dashboard-footer-face
  '((t (:inherit font-lock-doc-face)))
  "Face used for widget headings."
  :group 'spk-dashboard)

;; 以下用法，从名字上来说是给face取一个别名，但是后面的when实际不知道是怎么起作用的
;; (define-obsolete-face-alias
;;   'dashboard-text-banner-face 'dashboard-text-banner "1.2.6")
;; (define-obsolete-face-alias
;;   'dashboard-banner-logo-title-face 'dashboard-banner-logo-title "1.2.6")
;; (define-obsolete-face-alias
;;   'dashboard-heading-face 'dashboard-heading "1.2.6")

;; 定义后面需要使用的工具函数
(defun spk-dashboard-subseq (seq start end)
  "Return the subsequence of SEQ from START to END.
Uses `cl-subseq', but accounts for end points greater than the size of the list.
Return entire list if `END' is omitted."
  (let ((len (length seq)))
    (cl-subseq seq start (and (number-or-marker-p end)
			      (min len end)))))

;; 为什么这里要使用宏而不是直接使用函数？这里注意一个宏的写法。
(defmacro spk-dashboard-insert-shortcut (shortcut-char
					 search-label
					 &optional no-next-line)
  "Insert a shortcut SHORTCUT-CHAR for a given SEARCH-LABLE.
Optionally,provide NO-NEXT-LINE to move the cursor forward a line."
  `(progn
     (eval-when-compile (defvar spk-dashboard-map))
     (let ((sym (make-symbol (format "Jump to \"%s\"" ,search-label))))
       (fset sym (lambda ()
		   (interactive)
		   (unless (search-forward ,search-label (point-max) t)
		     (search-backward ,search-label (point-min) t))
		   ,@(unless no-next-line
		       '((forward-line 1)))
		   (back-to-indentation)))
       (eval-after-load 'spk-dashboard
	 (define-key spk-dashboard-mode-map ,shortcut-char sym)))))

;; 添加内容到buffer中，如果不存在这个buffer则创建它 
(defun spk-dashboard-append (msg &optional _messagebuf)
  "Append MSG to spk-dashboard buffer.
If MESSAGEBUF is not nil then MSG is also written in message buffer."
  (with-current-buffer (get-buffer-create spk-dashboard-buff-name)
    (goto-char (point-max))
    ;; 这里的写法不是很明白，let不应该是定义局部变量吗？
    (let ((buffer-read-only nil))
      (insert msg))))

;; 修改heading icons，看后面怎么来调用这个函数了
(defun spk-dashboard-modify-heading-icons (alist)
  "Append ALIST items to `spk-dashboard-heading-icons' to modify icons."
  (dolist (icon alist)
    (add-to-list 'spk-dashboard-heading-icons icons)))

(defun spk-dashboard-insert-page-break ()
  "Insert a page break line in dashboard buffer."
  (spk-dashboard-append spk-dashboard-page-separator))

(defun spk-dashboard-insert-heading (heading &optional shortcut)
  "Insert a widget HEADING in spk-dashboard buffer,adding SHORTCUT if provide."
  (when (and (display-graphic-p)
	     spk-dashboard-set-heading-icons)
    ;; Try to loading `all-the-icons'
    (unless (or (fboundp 'all-the-icons-octicon)
		(require 'all-the-icons nil 'noerror))
      (error "Package `all-the-icons' isn't installed."))

    (insert (cond
	     ((string-equal heading "Recent Files:")
	      (all-the-icons-octicon (cdr (assoc 'recents spk-dashboard-heading-icons))
				     :height 1.2 :v-adjust 0.0 :face 'spk-dashboard-heading))
	     ((string-equal heading "Bookmarks:")
	      (all-the-icons-octicon (cdr (assoc 'bookmarks spk-dashboard-heading-icons))
				     :height 1.2 :v-adjust 0.0 :face 'spk-dashboard-heading))
	     ((or (string-equal heading "Append for today:")
		  (string-equal heading "Agenda for the coming week:"))
	      (all-the-icons-octicon (cdr (assoc 'agenda spk-dashboard-heading-icons))
				     :height 1.2 :v-adjust 0.0 :face 'spk-dashboard-heading))
	      ((string-equal heading "Registers:")
	       (all-the-icons-octicon (cdr (assoc 'agenda spk-dashboard-heading-icons))
				      :height 1.2 :v-adjust 0.0 :face 'spk-dashboard-heading))
	      ((string-equal heading "Projects:")
	       (all-the-icons-octicon (cdr (assoc 'projects spk-dashboard-heading-icons))
				      :height 1.2 :v-adjust 0.0 :face 'spk-dashboard-heading))
	      (t " ")))
	    (insert " "))
    (insert (propertize heading 'face 'spk-dashboard-heading))
    (if shortcut (insert (format " (%s)" shortcut))))

(defun spk-dashboard-center-line (string)
  "Center a STRING accoring to it's size."
  (insert (make-string (max 0 (floor (/ (- spk-dashboard-banner-length
					   (+ (length string) 1)) 2))) ?\ )))

;; banner

;; 这个函数可以重点看一下
(defun spk-dashboard-insert-ascii-banner-centered (file)
  "Insert banner from FILE."
  (let ((ascii-banner
	 (with-temp-buffer
	   (insert-file-contents file)
	   (let ((banner-width 0))
	     (while (not (eobp))
	       (let ((line-length (- (line-end-position) (line-beginning-position))))
		 (if (< banner-width line-length)
		     (setq banner-width line-length)))
	       (forward-line 1))
	     (goto-char 0)
	     (let ((margin
		    (max 0 (floor (/ (- spk-dashboard-banner-length banner-width) 2)))))
	       (while (not (eobp))
		 (insert (make-string margin ?\ ))
		 (forward-line 1))))
	   (buffer-string))))
    (put-text-property 0 (length ascii-banner) 'face 'spk-dashboard-text-banner-face ascii-banner)
    (insert ascii-banner)))

(defun spk-dashboard-insert-image-banner (banner)
  "Display an image BANNER."
  (when (file-exists-p banner)
    (let* ((title spk-dashboard-banner-logo-title)
	   (spec
	    (if (image-type-available-p 'imagemagick)
		(apply 'create-image banner 'imagemagick nil
		       (append (when (> spk-dashboard-image-banner-max-width 0)
				 (list :max-width spk-dashboard-image-banner-max-width))
			       (when (> spk-dashboard-image-banner-max-height 0)
				 (list :max-height spk-dashboard-image-banner-max-height))))
	      (create-image banner)))
	   (size (image-size spec))
	   (width (car size))
	   (left-margin (max 0 (floor (- spk-dashboard-banner-length width) 2))))
      (goto-char (point-min))
      (insert "\n")
      (insert (make-string left-margin ?\ ))
      (insert-image spec)
      (insert "\n\n")
      (when title
	(spk-dashboard-center-line title)
	(insert (format "%s\n\n" (propertize title 'face 'spk-dashboard-banner-logo-title)))))))

;; INIT INFO

(defun spk-dashboard-insert-init-info ()
  "Insert init info when `spk-dashboard-set-init-info' is t."
  (when spk-dashboard-set-init-info
    (spk-dashboard-center-line spk-dashboard-init-info)
    (insert
     (propertize spk-dashboard-init-info 'face 'font-lock-comment-face))))

;; 通过index来合成具体的txt文件路径，也就是1.txt之类的文件 
(defun spk-dashboard-get-banner-path (index)
  "Return the full path to banner with index INDEX."
  (concat spk-dashboard-banners-directory (format "%d.txt" index)))

;; 这里是通过不同的方式来获取banner
(defun spk-dashboard-choose-banner ()
  "Return the full path of a banner based on the dotfile value."
  (when spk-dashboard-startup-banner
    (cond ((eq 'official spk-dashboard-startup-banner)
	   (if (and (display-graphic-p) (image-type-available-p 'png))
	       spk-dashboard-banner-official-png
	     (spk-dashboard-get-banner-path 1)))
	  ((eq 'logo spk-dashboard-startup-banner)
	   (if (and (display-graphic-p) (image-type-available-p 'png))
	       spk-dashboard-banner-logo-png
	     (spk-dashboard-get-banner-path 1)))
	  ((integerp spk-dashboard-startup-banner)
	   (spk-dashboard-get-banner-path spk-dashboard-startup-banner))
	  ((and spk-dashboard-startup-banner
		(image-type-available-p (intern (file-name-extension
						 spk-dashboard-startup-banner)))
		(display-graphic-p))
	   (if (file-exists-p spk-dashboard-startup-banner)
	       spk-dashboard-startup-banner
	     (message (format "could not find banner %s"
			      spk-dashboard-startup-banner))
	     (spk-dashboard-get-banner-path 1)))
	  (t (spk-dashboard-get-banner-path 1)))))

(defun spk-dashboard-insert-banner ()
  "Insert Banner at the top of the dashboard."
  (goto-char (point-max))
  (let ((banner (spk-dashboard-choose-banner))
	(buffer-read-only nil))
    (progn
      (when banner
	(if (image-type-available-p (intern (file-name-extension banner)))
	    (spk-dashboard-insert-image-banner banner)
	  (spk-dashboard-insert-ascii-banner-centered banner))
	(spk-dashboard-insert-navigator)
	(spk-dashboard-insert-init-info)))))

(defun spk-dashboard-insert-navigator ()
  "Insert Navigator of the spk-dashboard."
  (when (and spk-dashboard-set-navigator spk-dashboard-navigator-buttons)
    (dolist (line spk-dashboard-navigator-buttons)
      (dolist (btn line)
	(let* ((icon (car btn))
	       (title (cadr btn))
	       (help (or (cadr (cdr btn)) ""))
	       (action (or (cadr (addr btn)) #'ignore))
	       (face (or (cadr (cddr (cdr btn))) 'spk-dashboard-navigator))
	       (prefix (or (cadr (cddr (cddr btn))) (propertize "[" 'face face)))
	       (suffix (or (cadr (cddr (cddr (cdr btn)))) (propertize "]" 'face face))))
	  (widget-create 'item
			 :tag (concat
			       (when icon
				 (propertize icon 'face `(:inherit
							  ,(get-text-property 0 'face icon)
							  :inherit
							  ,face)))
			       (when (and icon title
					  (not (string-equal icon ""))
					  (not (string-equal title "")))
				 (propertize " " 'face 'variable-pitch)))
			 :help-echo help
			 :action action
			 :button-face `(:underline nil)
			 :mouse-face 'highlight
			 :button-prefix prefix
			 :button-suffix suffix
			 :format "%[%t%]")
	  (insert " ")))
      (let* ((width (current-column)))
	(beginning-of-line)
	(spk-dashboard-center-line (make-string width ?\s))
	(end-of-line))
      (insert "\n"))
    (insert "\n")))

(defmacro spk-dashboard-insert-section (section-name list list-size shortcut action &rest widget-params)
  "Add a section with SECTION-NAME and LIST of LIST-SIZE items to the spk-dashboard.
SHORTCUT is the keyboard shortcut used to access the section.
ACTION is theaction taken when the user activates the widget button.
WIDGET-PARAMS are passed to the \"widget-create\" function."
  `(progn
     (spk-dashboard-insert-heading ,section-name
				   (if (and ,list spk-dashboard-show-shortcuts) ,shortcut))
     (if ,list
	 (when (spk-dashboard-insert-section-list
		,section-name
		(spk-dashboard-subseq ,list 0 ,list-size)
		,action
		,@widget-params)
	   (spk-dashboard-insert-shortcut ,shortcut ,section-name))
       (insert "\n    --- No items ---"))))

;; Section list

;; 这里需要把之界面中显示的部分对应起来
(defmacro spk-dashboard-insert-section-list (section-name list action &rest rest)
  "Insert into SECTION-NAME a LIST of items, expanding ACTION and passing REST to widget creation."
  `(when (car ,list)
     (mapc
      (lambda (el)
	(let ((tag ,@rest))
	  (insert "\n    ")

	  (when (and (display-graphic-p)
		     spk-dashboard-set-file-icons
		     (or (fboundp 'all-the-icons-icon-for-dir)
			 (require 'all-the-icons nil 'noerror)))
	    (let* ((path (car (last (split-string ,@rest " - "))))
		   (icon (if (and (not (file-remote-p path))
				  (file-directory-p path))
			     (all-the-icons-icon-for-dir path nil "")
			   (cond
			    ((string-equal ,section-name "Agenda for today:")
			     (all-the-icons-octicon "primitive-dot" :height 1.0 :v-adjust 0.01))
			    ((file-remote-p path)
			     (all-the-icons-octicon "radio-tower" :height 1.0 :v-adjust 0.01))
			    (t (all-the-icons-icon-for-file (file-name-nondirectory path)
							    :v-adjust 0.05))))))
	      (setq tag (concat icon " " ,@rest))))
	  (widget-create 'item
			 :tag tag
			 :action ,action
			 :button-face `(:underline nil)
			 :mouse-face 'highlight
			 :button-prefix ""
			 :button-suffix ""
			 :format "%[%t%]")))
      ,list)))

;; footer
(defun spk-dashboard-random-footer ()
  "Return footer of spk-dashboard."
  (let ((footer (and spk-dashboard-set-footer (spk-dashboard-random-footer))))
    (when footer
      (insert "\n")
      (spk-dashboard-center-line footer)
      (insert spk-dashboard-footer-icon)
      (insert " ")
      (insert (propertize footer 'face 'spk-dashboard-footer))
      (insert "\n"))))

;; Recentf
(defun spk-dashboard-insert-recents (list-size)
  "Add the list of LIST-SIZE items from recently edited files."
  (recentf-mode)
  (spk-dashboard-subseq (bookmark-all-names)
			0 list-size)
  list-size
  "m"
  `(lambda (&rest ignore) (bookmark-jump ,el))
  (let ((file (bookmark-get-filename el)))
    (if file
	(format "%s - %s" el (abbreviate-file-name file))
      el)))

;; Projectile
(defun spk-dashboard-insert-projects (list-size)
  "Add the list of LIST-SIZE items of projects."
  (require 'projectile)
  (let ((inhibit-message t) (message-log-max nil))
    (projectile-cleanup-known-projects))
  (projectile-load-known-projects)
  (spk-dashboard-insert-section
   "Projects:"
   (spk-dashboard-subseq (projectile-relevant-known-projects)
			 0 list-size)
   list-size
   "p"
   `(lambda (&rest ignore) (projectile-switch-project-by-name ,el))
   (abbreviate-file-name el)))

;; org agenda
(defun spk-dashboard-timestamp-to-gregorian-date (timestamp)
  "Convert TIMESTAMP to a gregorian date.
the result can be used with function like
`calendar-date-compare'."
  (let ((decode-timestamp (decode-time timestamp)))
    (list (nth 4 decode-timestamp)
	  (nth 3 decode-timestamp)
	  (nth 5 decode-timestamp))))

(defun spk-dashboard-date-due-p (timestamp &optional due-date)
  "Check if TIMESTAMP is today or in the past.
If FUE_DATE is nil,compare TIMESTAMP to today;otherwise,
compare to the date in DUE-DATE.
The time part of both TIMESTAMP and DUE_DATE is ignored, only the
date part is considered."
  (unless due-date
    (setq due-date (current-time)))
  (setq due-date (time-add due-date 86400))
  (let* ((gregorian-date (spk-dashboard-timestamp-to-gregorian-date timestamp))
	 (gregorian-due-date (spk-dashboard-timestamp-to-gregorian-date due-date)))
    (calendar-date-compare (list gregorian-date)
			   (list gregorian-due-date))))

(defun spk-dashboard-get-agenda ()
  "Get agenda items for today or for a week from now."
  (org-compile-prefix-format 'agenda)
  (let ((due-date nil))
    (if (and (boundp 'show-week-agenda-p) show-week-agenda-p)
	(setq due-date (time-add (current-time) (* 86400 7)))
      (setq due-date nil))
    (let* ((filtered-entries nil))
      (org-map-entries
       (lambda ()
	 (let* ((schedule-time (org-get-scheduled-time (point)))
		(deadline-time (org-get-deadline-time (point)))
		(item (org-agenda-format-item
		       (format-time-string "%y-%m-%d" schedule-time)
		       (org-get-heading t t)
		       (org-outline-level)
		       (org-get-category)
		       (org-get-tags)
		       t))
		(loc (point))
		(file (buffer-file-name)))
	   (if (or (equal spk-dashboard-org-agenda-categories nil)
		   (member (org-get-category) spk-dashboard-org-agenda-categories))
	       (when (and (not (org-entry-is-done-p))
			  (or (and schedule-time (spk-dashboard-date-due-p due-date))
			      (and deadline-time (spk-dashboard-date-due-p deadline-time due-date))))
		 (setq filtered-entries
		       (append filtered-entries
			       (list (list item schedule-time deadline-time loc file))))))))
       nil
       'agenda)
      filtered-entries)))

(defun dashboard-insert-agenda (list-size)
  "Add the list of LIST_SIZE items of agenda."
  (require 'org-agenda)
  (require 'calendar)
  (let ((agenda (spk-dashboard-get-agenda)))
    (spk-dashboard-insert-section
     (or (and (boundp 'show-week-agenda-p) show-week-agenda-p "Agenda for the coming week:")
	 "Agenda for today:")
     agenda
     list-size
     "a"
     `(lambda (&rest ignore)
	(let ((buffer (find-file-other-window (nth 4 ',el))))
	  (with-current-buffer buffer
	    (goto-char (nth 3 ',el)))
	  (switch-to-buffer buffer)))
     (format "%s" (nth 0 el)))))

;; Registers
(defun spk-dashboard-insert-register (list-size)
  "Add the list of LIST_SIZE items of registers."
  (require 'register)
  (spk-insert-section
   "Registers:"
   register-alist
   list-size
   "e"
   (lambda (&rest _ignore) (jump-to-register (car el)))
   (format "%c - %s" (car el) (register-describe-oneline (car el)))))

;; 上面是之前tools
(provide 'spk-dashboard-widgets)
