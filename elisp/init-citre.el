;; citre依赖于tags文件，使用tags文件的话，自己定义的函数就废弃了。需要找到另一个查找文件的方法

; citre ctags前端，要求对应的ctags版本
(straight-use-package
 '(citre :type git
		 :host github
		 :repo "universal-ctags/citre"))

;; 定义生成tags文件的命令，后续看能否想办法生成文件位置的缓存 
(defconst spk-ctags-base-command-citre
  "ctags -R --languages=c --langmap=c:+.h --links=no --exclude=targets --exclude=vendor --exclude=bsp/kernel/kpatch --exclude=.svn --exclude=.git --exclude=Makefile --kinds-all=\'*\' --fields=\'*\' --extras=\'*\'"
  )

;; 直接读取citre相关的配置，后续优化
(require 'citre)
(require 'citre-config)

(provide 'init-citre)
