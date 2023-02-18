(setq spk-local-eaf-dir "~/.emacs.d/.local/packages/emacs-application-framework/")
;; (setq spk-local-eaf-app-dir (concat spk-local-eaf-dir "app/"))

(unless (file-exists-p spk-local-eaf-dir)
  (shell-command-to-string (format "git clone https://gitee.com/emacs-eaf/emacs-application-framework %s" spk-local-eaf-dir))
  )

;; 将eaf加入读取列表
(add-to-list 'load-path spk-local-eaf-dir)
;; (add-to-list 'load-path spk-local-eaf-app-dir)

(require 'eaf)

(require 'eaf-rss-reader)
(require 'eaf-system-monitor)
(require 'eaf-org-previewer)
(require 'eaf-git)
(require 'eaf-browser)
(require 'eaf-file-manager)
(require 'eaf-vue-demo)
(require 'eaf-demo)
(require 'eaf-airshare)
(require 'eaf-camera)
(require 'eaf-jupyter)
(require 'eaf-music-player)
(require 'eaf-mindmap)
(require 'eaf-image-viewer)
(require 'eaf-file-sender)
(require 'eaf-netease-cloud-music)
(require 'eaf-pdf-viewer)
(require 'eaf-terminal)
(require 'eaf-file-browser)
(require 'eaf-video-player)
(require 'eaf-markdown-previewer)


(with-eval-after-load 'eaf-browser
  ;; 在eaf中用了s库相关的接口，在这里手动加载这个库，避免出错
  (require 's)
  ;; 需要注意的是，在windows上使用eaf浏览器的时候，如果要导入
  (when IS-WINDOWS
    (setq eaf-chrome-bookmark-file (concat "C:/Users/" user-real-login-name "/AppData/Local/Google/Chrome/User Data/Default/Bookmarks"))
    (when IS-LINUX
      (setq eaf-chrome-bookmark-file /home/spikely/.config/google-chrome/Default/Bookmarks))
    ;; 在windows上如果没有安装 将 open-office 后缀列表设置为空
    (setq eaf-office-extension-list nil)
    )

  (defun spk/eaf-pdf-outline-quite ()
    (interactive)
    (let* ((last-pdf-buf eaf-pdf-outline-pdf-document)
           (last-buf (spk/alternate-buffer)))
      (kill-this-buffer)
      (switch-to-buffer-other-window last-pdf-buf)
      (when (equal eaf-pdf-outline-pdf-document last-buf)
        (delete-window))))
  
  (advice-add 'eaf-mode :after 'evil-emacs-state)
  (advice-add 'eaf-pdf-outline-mode :after 'evil-emacs-state)
  (define-key eaf-pdf-outline-mode-map "j" 'next-line)
  (define-key eaf-pdf-outline-mode-map "k" 'previous-line)
  ;; 在大纲模式的时候增加快捷键退出
  (define-key eaf-pdf-outline-mode-map "q" 'spk/eaf-pdf-outline-quite)
  (define-key eaf-pdf-outline-edit-mode-map "q" 'spk/eaf-pdf-outline-quite)
  ;; (setq eaf--get-titlebar-height nil)

  ;; 设置evil快捷键
  (evil-leader/set-key
    "er" 'eaf-open-pdf-from-history
    "si" 'eaf-search-it
    "oi" 'eaf-open-url-at-point
    )
  )

;; eaf和straight的结构有冲突，这里不使用straight的方式加载
(provide 'init-eaf)
