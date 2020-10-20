;; doom中定义的一些使用的值
(defconst EMACS27+ (> emacs-major-version 26))
(defconst EMACS28+ (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

(require 'init-evil)
;; 配置ivy相关的一些快捷键等，这里考虑要不要继续使用use-package来进行管理。
(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;;(setq search-default-mode #'char-fold-to-regexp)
  (global-set-key (kbd "C-s") 'swiper)
  (counsel-mode 1)
  )
;; 安装完成ｉｖｙ去阅读文档，讲其中的一些东西进行配置，了解自己使用的插件

;; 当M-x的时候显示文档
(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode t))

(use-package which-key
  :ensure t
  :init
  (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0)
  (setq which-key-side-window-location 'bottom)
  )

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  )

;; 在core中加载其余的模块，在init中只要加载部分
(require 'init-org)
(require 'init-tools)

(provide 'init-core)
