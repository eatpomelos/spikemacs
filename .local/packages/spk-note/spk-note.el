;;; local/packages/spike-note/spike-note.el -*- lexical-binding: t; -*-
;; 用来定义自己的笔记本，这个函数是用在org-mode中的，所以用org-mode中的来进行表示

;; 这个函数是后面进行移动的基础，对于条目的
;;;###autoload
(defun spk-note/get-one-org-item ()
  "select a org item."
  (interactive)
  (let* ((b (save-excursion
              (cond
               ((re-search-backward "^\\*[[:space:]]+.+$" nil t)
                (line-beginning-position))
               (t
                1))))
         (e (save-excursion
              (cond
               ((re-search-forward "^\\*[[:space:]]+.+$" nil t)
                (forward-line -1)
                (line-end-position))
               (t
                (point-max))))))
    (list b e)
    ))

;; 删除一个org中的条目，为了后面的对条目进行操作做准备
(defun spk-note/kill-one-item ()
  "Delete a org item."
  (interactive)
  (let ((b (point-min))
        rtl
        (e (point-max)))
    (setq rtl (note--get-one-org-item))
    (setq b (nth 0 rtl))
    (setq e (nth 1 rtl))
    (kill-region b e)))

(defun spk-note/demo-move ()
  (interactive)
  (let ((b (point-min))
        rtl
        (e (point-max)))
    (setq rtl (note--get-one-org-item))
    (setq b (nth 0 rtl))
    (setq e (nth 1 rtl))
    (append-to-file b e "~/")
    ))

(provide 'spike-note)
