;; -*- lexical-binding: t; -*-
(setq spk-local-eaf-dir "~/.emacs.d/.local/packages/emacs-application-framework/")
;; (setq spk-local-eaf-app-dir (concat spk-local-eaf-dir "app/"))

(unless (file-exists-p spk-local-eaf-dir)
  (shell-command-to-string (format "git clone https://gitee.com/emacs-eaf/emacs-application-framework %s" spk-local-eaf-dir))
  )

;; 将eaf加入读取列表
(add-to-list 'load-path spk-local-eaf-dir)
;; (add-to-list 'load-path spk-local-eaf-app-dir)

;; 关闭默认eaf接管dired选项，必须在加载eaf之前设置
;; (setq-default eaf-dired-advisor-enable nil)

(require 'eaf)

(require 'eaf-rss-reader)
(require 'eaf-org-previewer)
;; (require 'eaf-git)
(require 'eaf-browser)
;; (require 'eaf-file-manager)
;; (require 'eaf-vue-demo)
;; (require 'eaf-airshare)
;; (require 'eaf-camera)
(require 'eaf-jupyter)
(require 'eaf-music-player)
(require 'eaf-mindmap)
(require 'eaf-image-viewer)
(require 'eaf-file-sender)
(require 'eaf-pdf-viewer)
(require 'eaf-pyqterminal)
(require 'eaf-file-browser)
(require 'eaf-video-player)
(require 'eaf-markdown-previewer)

(defun spk/dired-jump ()
  "Same as `dired-jump'."
  (interactive)
  (if (eq major-mode 'dired-mode)
      (dired (file-name-parent-directory (dired-current-directory)))
    (dired-jump)
    )
  )

(with-eval-after-load 'eaf-browser
  ;; 在eaf中用了s库相关的接口，在这里手动加载这个库，避免出错
  (require 's)
  ;; 需要注意的是，在windows上使用eaf浏览器的时候，如果要导入
  (when IS-WINDOWS
    (setq eaf-chrome-bookmark-file (concat "C:/Users/" user-real-login-name "/AppData/Local/Google/Chrome/User Data/Default/Bookmarks"))
    ;; 在windows上如果没有安装 将 open-office 后缀列表设置为空
    (setq eaf-office-extension-list nil)
    )

  (when IS-LINUX
    (setq eaf-chrome-bookmark-file "/home/spikely/.config/google-chrome/Default/Bookmarks")
    )

  (setq eaf-browser-default-search-engine "bing")
  
  (defun spk/eaf-pdf-outline-quite ()
    (interactive)
    (let* ((last-pdf-buf eaf-pdf-outline-pdf-document)
           (last-buf (car (window-prev-buffers))))
      (kill-current-buffer)
      (switch-to-buffer-other-window last-pdf-buf)
      (when (equal eaf-pdf-outline-pdf-document last-buf)
        (delete-window))))


  (evil-set-initial-state 'eaf-mode 'emacs)
  (evil-set-initial-state 'eaf-pdf-outline-mode 'emacs)
  
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

(evil-leader/set-key
  "fj" 'spk/dired-jump)

(global-set-key (kbd "C-x C-j") 'spk/dired-jump)


(with-eval-after-load 'eaf-pdf-viewer
  (setq eaf-pdf-dark-mode "ignore")
  (setq eaf-pdf-history-filter-pattern "^\\(.*\\)$")
  )

(with-eval-after-load 'eaf-music-player
    (evil-leader/set-key
    "em" 'eaf-open-music-player
    )
  (setq eaf-music-default-file "~/Music/")
  (add-to-list 'eaf-music-extension-list "flac")
  )

(with-eval-after-load 'eaf-org-previewer
  (defun spk/eaf-org-preview-current-buffer ()
    (interactive)
    (let* ((file-path (buffer-file-name (current-buffer))))
      (if (file-exists-p file-path)
          (eaf-open file-path "org-previewer")
        (message (format "file %s not exist" file-path)))
      )
    )
  )
(global-set-key (kbd "C-c SPC") 'evil-switch-to-windows-last-buffer)
(global-set-key (kbd "C-c p a") 'spk/project-fast-find-all-file)
(global-set-key (kbd "C-c p f") 'spk/project-fast-find-file)
(global-set-key (kbd "C-c f l") 'counsel-locate)


(with-eval-after-load 'eaf-pyqterminal
  (global-set-key (kbd "C-c RET") 'eaf-open-pyqterminal)
  (setq eaf-pyqterminal-font-size 16
        eaf-pyqterminal-cursor-type "hlbar"
        eaf-pyqterminal-font-family "文泉驿等宽正黑"
        )
  )

;; eaf和straight的结构有冲突，这里不使用straight的方式加载
(provide 'init-eaf)
