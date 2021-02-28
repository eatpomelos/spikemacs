;; 在这个文件中调用widgets中定义的函数
(require 'seq)
(require 'page-break-lines)
(require 'recentf)

;; (add-to-list 'load-path)
;; 在自己的配置中设置读取自己的文件的配置

(require 'spk-dashboard-widgets)

;; 定义主模式以及mode-map,结合evil的快捷键 
(defvar spk-dashboard-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-p") 'spk-dashboard-previous-line)
    (define-key map (kbd "C-n") 'spk-dashboard-next-line)
    (define-key map (kbd "<up>") 'spk-dashboard-previous-line)
    (define-key map (kbd "<down>") 'spk-dashboard-next-line)
    (define-key map (kbd "k") 'spk-dashboard-previous-line)
    (define-key map (kbd "j") 'spk-dashboard-next-line)
    (define-key map [tab] 'widget-forward)
    (define-key map (kbd "C-i") 'widget-forward)
    (define-key map [backtab] 'widget-backward)
    (define-key map (kbd "RET") 'spk-dashboard-return)
    (define-key map [down-mouse-1] 'widget-button-click)
    (define-key map (kbd "g") #'spk-dashboard-refresh-buffer)
    (define-key map (kbd "}") #'spk-dashboard-next-section)
    (define-key map (kbd "{") #'spk-dashboard-previous-section)
    map)
  "Keymap for dashboard mode.")

(define-derived-mode spk-dashboard-mode special-mode "Spk-Dashboard"
  "Spk-Dashboard major mode for startup screen.
\\<spk-dashboard-mode-map>
"
  :group 'spk-dashboard
  :syntax-table nil
  :abbrev-table nil
  (buffer-disable-undo)
  (whitespace-mode -1)
  (linum-mode -1)
  (when (>= emacs-major-version 26)
    (display-line-numbers-mode -1))
  (page-break-lines-mode 1)
  (setq inhibit-startup-screen t)
  (setq buffer-read-only t
	truncate-lines t))

(defgroup spk-dashboard nil
  "Extensible startup screen."
  :group 'applications)

(defcustom spk-dashboard-center-content nil
  "Whether to center content within the window."
  :type 'boolean
  :group 'spk-dashboard)

(defvar spk-dashboard-buffer-name "*spikemacs*"
  "Spk-dashboard's buffer name.")

(defvar spk-dashboard--section-starts nil
  "List of section starting positions.")

(defun spk-dashboard-previous-section ()
  "Navigate back to previous section."
  (interactive)
  (let ((current-section-start nil)
	(current-position (point))
	(previous-section-start nil))
    (dolist (elt spk-dashboard--section-starts)
      (when (and current-section-start
		 (not previous-section-start))
	(setq previous-section-start elt))
      (when (and (not current-section-start)
		 (< elt current-position))
	(setq current-section-start elt)))
    (goto-char (if (eq current-position current-section-start)
		   previous-section-start
		 current-section-start))))

(defun spk-dashboard-next-section ()
  "Navigate forward to next section."
  (interactive)
  (let ((current-position (point))
	(next-selection-start nil)
	(section-starts (reverse spk-dashboard--section-starts)))
    (dolist (elt section-starts)
      (when (and (not next-section-start)
		 (> elt current-position))
	(setq next-selection-start elt)))
    (when next-section-start
      (goto-char next-section-start))))

(defun spk-dashboard-previous-line (arg)
  "Move point up and position it at that line's item.
Optional prefix ARG says how many lines to move;default is one line."
  (interactive "^p")
  (spk-dashboard-next-line (- arg)))

(defun spk-dashboard-next-line (arg)
  "Move point down and position it at that line's item.
Optional prefix ARG says how many lines to move;default is one line."
  ;;code heavily inspired by `dired-next-line'
  (interactive "^p")
  (let ((line-move-visual nil)
	(goal-column nil))
    (line-move arg t))
  (while (and (invisible-p (point))
	      (not (if (and arg (< arg 0)) (bobp) (eobp))))
    (forward-char (if (and arg (< arg 0)) -1 1)))
  (beginning-of-line-text))

(defun spk-dashboard-return ()
  "Hit return key in spk-dashboard buffer."
  (interactive)
  (let ((start-ln (line-number-at-pos))
	(fd-cnt 0)
	(diff-line nil)
	(entry-pt nil))
    (save-excursion
      (while (and (not diff-line)
		  (not (= (point) (point-min)))
		  (not (get-char-property (point) 'button))
		  (not (= (point) (point-max))))
	(forward-char 1)
	(setq fd-cnt (1+ fd-cnt))
	(unless (= start-ln (line-number-at-pos))
	  (setq diff-line t)))
      (unless (= (point) (point-max))
	(setq entry-pt (point))))
    (when (= fd-cnt 1)
      (setq entry-pt (1- (point))))
    (if entry-pt
	(widget-button-press entry-pt)
      (call-interactively #'widget-button-press))))

(defun spk-dashboard-maximum-section-length ()
  "For the just-inserted section,calculate the length of the longest line."
  (let ((max-line-length 0))
    (save-excursion
      (spk-dashboard-previous-section)
      (while (not (eobp))
	(setq max-line-length
	      (max max-line-length
		   (- (line-end-position) (line-beginning-position))))
	(forward-line)))
    max-line-length))

(defun spk-dashboard-insert-startupify-lists ()
  "Insert the list of widgets into the buffer."
  (interactive)
  (let ((buffer-exists (buffer-live-p (get-buffer spk-dashboard-buffer-name)))
	(recentf-is-on (recentf-enabled-p))
	(origial-recentf-list recentf-list)
	(spk-dashboard-num-recents (or (cdr (assoc 'recents spk-dashboard-items)) 0))
	(max-line-length 0))
    ;; disable recentf mode,
    ;; so we don't flood the recent files list with org mode files
    ;; do this by making a copy of the part of the list we'll use
    ;; let dashboard widgets change that
    ;; then restore the orginal list afterwards
    ;; (this avoids many saves/loads that would result from
    ;; disabling/enabling recentf-mode)
    (if recentf-is-on
	(setq recentf-list (seq-take recentf-list spk-dashboard-num-recents)))
    (when (or (not (eq spk-dashboard-buffer-last-width (window-width)))
	      (not buffer-exists))
      (setq spk-dashboard-banner-length (window-width)
	    spk-dashboard-buffer-last-width spk-dashboard-banner-length)
      (with-current-buffer (get-buffer-create spk-dashboard-buffer-name)
	(let ((buffer-read-only nil))
	  (erase-buffer)
	  (spk-dashboard-insert-banner)
	  (spk-dashboard-insert-page-break)
	  (setq spk-dashboard--section-starts nil)
	  (mapc (lambda (els)
		  (let* ((el (or (car-safe els) els))
			 (list-size
			  (or (cdr-safe els)
			      spk-dashboard-item-default-length))
			 (item-generator
			  (cdr-safe (assoc el spk-dashboard-item-generators))))
		    (add-to-list 'spk-dashboard--section-starts (point))
		    (funcall item-generator list-size)
		    (setq max-line-length
			  (max max-line-length (spk-dashboard-maximum-section-length)))
		    (spk-dashboard-insert-page-break)))
		spk-dashboard-items)
	  (when spk-dashboard-center-content
	    (when spk-dashboard--section-starts
	      (goto-char (car (last spk-dashboard--section-starts))))
	    (let ((margin (floor (/ (max (- (window-width) max-line-length) 0) 2))))
	      (while (not (eobp))
		(and (not (eq ? (char-after)))
		     (insert (make-string margin ?\ )))
		(forward-line 1))))
	  (spk-dashboard-insert-footer))
	(spk-dashboard-mode)
	(goto-char (point-min))))
    (if recentf-is-on
	(setq recentf-list origial-recentf-list))))

(add-hook 'window-setup-hook
	  (lambda ()
	    (add-hook 'window-size-change-functions 'spk-dashboard-resize-on-hook)
	    (spk-dashboard-resize-on-hook)))

(defun spk-dashboard-refresh-buffer ()
  "Refresh buffer."
  (interactive)
  (kill-buffer spk-dashboard-buffer-name)
  (spk-dashboard-insert-startupify-lists)
  (switch-to-buffer spk-dashboard-buffer-name))

(defun spk-dashboard-resize-on-hook (&optional _)
  "Re-render spk-dashboard on window size change."
  (let ((space-win (get-buffer-window spk-dashboard-buffer-name))
	(frame-win (frame-selected-window)))
    (when (and space-win
	       (not (window-minibuffer-p frame-win)))
      (with-selected-window space-win
	(spk-dashboard-insert-startupify-lists)))))

;;;###autoload
(defun spk-dashboard-setup-startup-hook ()
  "Setup post initialization hooks.
If a command line argument is provided,
assume a filename and skip displaying spk-Dashboard."
  (when (< (length command-line-args) 2)
    (add-hook 'after-init-hook (lambda ()
				 ;; Display useful lists of items
				 (spk-dashboard-insert-startupify-lists) ))
    (add-hook 'emacs-startup-hook '(lambda ()
				     (switch-to-buffer spk-dashboard-buffer-name)
				     (goto-char (point-min))
				     (redisplay)))))

(provide 'spk-dashboard)
