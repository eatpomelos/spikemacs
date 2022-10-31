;; 暂时用来存放自己使用的一些外部工具相关的配置，后续优化
(straight-use-package 'graphviz-dot-mode)

(setq graphviz-dot-indent-width 4)

;; 由于emacs本身的image-mode处理的速度比较慢，可能出现在处理较大的文件的时候，导致emacs卡住的问题，这里不适用graphviz包的预览功能，而是使用eaf的image-viewer进行替代
(setq graphviz-dot-auto-preview-on-save nil)

;; 当配置好了eaf的时候，使用graphviz使用eaf-open 来进行预览，避免出现原生emacs的性能问题
(with-eval-after-load 'eaf
  ;; 写一个接口，判断某个文件是否已经在eaf中打开
  (defun spk/exists-eaf-buffer (url)
    (let ((ret nil))
      ;; Try to open buffer           ; ;
      (catch 'found-eaf
        (eaf-for-each-eaf-buffer
         ;; (print (format "eaf_buffer:%s url:%s" eaf--buffer-url url))
         (when (string= eaf--buffer-url url)
           ;; (print (format "find url eaf_buffer:%s url:%s" eaf--buffer-url url))
           (setq ret t)
           (throw 'found-eaf t))))
      ret)
    )

  (defun spk/graphviz-dot-eaf-preview ()
    "Compile the graph and preview it in an other buffer."
    (interactive)
    (require 'winum)
    (let ((f-name (graphviz-output-file-name (buffer-file-name)))
          (command-result (string-trim (shell-command-to-string compile-command))))
      (if (string-prefix-p "Error:" command-result)
          (message command-result)
        (progn
          (unless (> winum--window-count 1)
            (split-window-right)
            (other-window 1)
            )
          (other-window 1)
          (unless (spk/exists-eaf-buffer (expand-file-name f-name))
            (eaf-open f-name)
            )
        
          (when (and (commandp 'eaf-py-proxy-reload_image) (eq major-mode 'eaf-mode))
            (eaf-py-proxy-reload_image)
            )
          (other-window 1)
          ))))

  (defun spk/graphviz-live-reload-hook ()
    "Hook to run in `after-save-hook' for live preview to work."
    (when (eq major-mode 'graphviz-dot-mode) 
      (spk/graphviz-dot-eaf-preview)))

  (add-hook 'after-save-hook 'spk/graphviz-live-reload-hook)
  )

(provide 'init-tools)
