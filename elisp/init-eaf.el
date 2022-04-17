;; 这里安装emacs中相关的eaf依赖
;;(straight-use-package 'epc)
;;(straight-use-package 'deferred)
;;(straight-use-package 'ctable)
;;(straight-use-package 's)
;; 如果eaf没有被安装，则将这个库clone到本地，由于eaf的结构比较复杂，直接使用straight的方式暂时有问题，手动拷贝

;; (setq spk-local-eaf-dir (concat spk-local-packges-dir "emacs-application-framework/"))

(setq spk-local-eaf-dir "~/.emacs.d/.local/packages/emacs-application-framework/")
;; (setq spk-local-eaf-app-dir (concat spk-local-eaf-dir "app/"))

(unless (file-exists-p spk-local-eaf-dir)
  (shell-command-to-string "git clone https://gitee.com/emacs-eaf/emacs-application-framework")
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
;; (require 'eaf-mermaid)
(require 'eaf-markdown-previewer)


;; eaf和straight的结构有冲突，这里不使用straight的方式加载
(provide 'init-eaf)
