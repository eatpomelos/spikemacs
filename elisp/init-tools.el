;; 暂时用来存放自己使用的一些外部工具相关的配置，后续优化  -*- lexical-binding: t; -*-
(straight-use-package 'graphviz-dot-mode)
(straight-use-package 'plantuml-mode)
(straight-use-package 'flycheck-plantuml)

(when (and IS-LINUX (not IS-WSL))
  (straight-use-package 'calibredb)
  (require 'calibredb)
  (setq calibredb-root-dir "~/spk-calibre")
  ;; for folder driver metadata: it should be .metadata.calibre
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (setq calibredb-library-alist '(
                                  ("~/spk-calibre/linux")
                                  ("~/spk-calibre/emacs")
                                  ("~/spk-calibre/programming")
                                  ("~/spk-calibre/reading")
                                  ("~/spk-calibre/manga")
                                  )
        calibredb-format-nerd-icons t
        )
  (global-set-key (kbd "C-c e l") 'calibredb-library-list)
  (evil-leader/set-key
    "el" 'calibredb-library-list)
  (evil-set-initial-state 'calibredb-search-mode 'emacs)
  
  (define-key calibredb-search-mode-map "h" 'calibredb-search-previous-page)
  (define-key calibredb-search-mode-map "l" 'calibredb-search-next-page)
  (define-key calibredb-search-mode-map "x" 'calibredb-toggle-highlight-at-point)
  )

;; 在linux下使用emacs-rime 输入
(when IS-LINUX
  (straight-use-package 'rime)
  (require 'rime)
  (setq default-input-method "rime"
        rime-show-candidate 'posframe
        rime-posframe-style 'vertical)
  (global-set-key (kbd "C-<SPC>") 'toggle-input-method)
  (when IS-WSL
    (setq rime-emacs-module-header-root
          (file-truename
           (concat (file-name-directory
                    (directory-file-name (file-name-directory
                                    (file-truename
                                     (directory-file-name "/run/current-system/sw/bin/emacs"))))) "/include")))
    (setq rime-librime-root
          (file-name-directory
           (directory-file-name
            (file-name-directory
             (file-truename
              (directory-file-name "/run/current-system/sw/lib/librime.so"))))))
    (setq rime-share-data-dir (concat user-emacs-directory "rime"))
    (unless (file-exists-p rime-share-data-dir)
      (make-directory rime-share-data-dir)
      )
    )
  )

(when IS-WSL
  (straight-use-package
   '(pyim
     :type git
     :host github
     :repo "tumashu/pyim"))
  (straight-use-package 'pyim-basedict)
  
  (require 'pyim)
  (require 'pyim-basedict)
  (require 'pyim-cregexp-utils)
  
  (pyim-basedict-enable)
  (pyim-isearch-mode 1)

  (setq default-input-method "pyim"
        pyim-default-scheme 'xiaohe-shuangpin
        pyim-assistant-scheme 'quanpin
        pyim-page-length 8)
  )

;; 后续增加一个开关用于动态开启预览，避免大文件编译耗时比较长导致卡顿？
;; (defvar spk-dot-preview-switch t)

(setq graphviz-dot-indent-width 4)

;; 由于emacs本身的image-mode处理的速度比较慢，可能出现在处理较大的文件的时候，导致emacs卡住的问题，这里不适用graphviz包的预览功能，而是使用eaf的image-viewer进行替代
(setq graphviz-dot-auto-preview-on-save nil)
 
;; 设置是否需要在保存的时候就自动预览
(defvar spk/graphviz-auto-preview-on-save t)

(require 'plantuml-mode)
(with-eval-after-load 'plantuml-mode
  (setq plantuml-jar-path (expand-file-name "plantuml.jar" spk-local-dir))
  (setq plantuml-default-exec-mode 'jar)

 ;; (unless (file-exists-p plantuml-jar-path)
 ;;   (plantuml-download-jar))

  (setq plantuml-output-type "png")
  ;; (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

  )

;; 当配置好了 eaf 的时候，使用 graphviz 使用 eaf-open 来进行预览，避免出现原生 emacs 的性能问题
(with-eval-after-load 'eaf
  ;; 写一个接口，判断某个文件是否已经在 eaf 中打开
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

  (defun spk/common-eaf-preview (f-name)
    (require 'winum)
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
      )
    )
  
  (defun spk/graphviz-dot-eaf-preview ()
    "Compile the graph and preview it in an other buffer."
    (interactive)
    (require 'winum)
    (let ((f-name (graphviz-output-file-name (buffer-file-name)))
          (command-result (string-trim (shell-command-to-string compile-command))))
      (if (string-prefix-p "Error:" command-result)
          (message command-result)
        (spk/common-eaf-preview f-name)
        )))

  (defun spk/graphviz-live-reload-hook ()
    "Hook to run in `after-save-hook' for live preview to work."
    (when (and (eq major-mode 'graphviz-dot-mode) spk/graphviz-auto-preview-on-save) 
      (spk/graphviz-dot-eaf-preview)))

  (add-hook 'after-save-hook 'spk/graphviz-live-reload-hook)

  ;; plantuml 配置
  (defun spk/plantuml-export-and-preview ()
    (interactive)
    (when (equal major-mode 'plantuml-mode)
      (let* ((cmd-str nil)
             (cur-file (buffer-file-name))
             (cur-export-file nil)
             )
        (setq cmd-str (format "java -jar %s -t%s %s" plantuml-jar-path plantuml-output-type cur-file))
        (shell-command-to-string cmd-str)
        (spk/common-eaf-preview (format "%s.%s" (file-name-sans-extension (buffer-file-name)) plantuml-output-type))
        )))
  (add-hook 'after-save-hook 'spk/plantuml-export-and-preview)

  )

;; 删除buffer中的所有空行
(defun spk/delete-buffer-blank-lines ()
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (while (< (point) (buffer-size))
        (delete-blank-lines)
        (forward-line)
        )
      ))
  )

(require 'init-info)

(provide 'init-tools)
