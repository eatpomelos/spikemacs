;; 不习惯默认的info-mode的绑定，这里手动配置一下info-mode中的一些快捷键，这样能够顺手一些  -*- lexical-binding: t; -*-


;;;###autoload
(defun spk/info-load-cheat-sheet ()
  (interactive)
  (let ((info-path (expand-file-name "info.txt" (concat spk-local-code-dir "posframe"))))
    (when (file-exists-p info-path)
      (with-current-buffer (get-buffer-create spk-info-mode-pos-buf)
        (erase-buffer)
        (insert-file-contents info-path)))))

(add-to-list 'spk-bulltin-help-alist '(Info-mode . spk/info-load-cheat-sheet))

;; 在windows上找不到 manual 节点，手动将emacs doc的位置添加到info-directory-list里面去
(when IS-WINDOWS
  (add-to-list 'Info-directory-list
	           "d:/HOME/spike/spk-shareFile/emacs-30.2/info")
  (add-to-list 'Info-additional-directory-list
               (concat spk-doc-dir "Code/elisp/Elisp_manual/info"))
  )

(provide 'init-info)
