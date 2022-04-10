;; 如果eaf没有被安装，则将这个库clone到本地，由于eaf的结构比较复杂，直接使用straight的方式暂时有问题，手动拷贝

(defvar spk-local-eaf-dir (concat spk-local-packges-dir "emacs-application-framework"))

(unless (file-exists-p spk-local-eaf-dir)
  (shell-command-to-string "git clone https://gitee.com/emacs-eaf/emacs-application-framework")
  )

;; 将eaf加入读取列表
(add-to-list 'load-path spk-local-eaf-dir)
(require 'eaf)
(require 'eaf-browser)
(require 'eaf-demo)
(require 'eaf-airshare)
(require 'eaf-camera)

;; eaf和straight的结构有冲突，这里不使用straight的方式加载
(provide 'init-eaf)
