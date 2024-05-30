;; citre依赖于tags文件，使用tags文件的话，自己定义的函数就废弃了。需要找到另一个查找文件的方法  -*- lexical-binding: t; -*-

; citre ctags前端，要求对应的ctags版本
(straight-use-package
 '(citre :type git
		 :host github
		 :repo "universal-ctags/citre"))

;; 定义生成tags文件的命令，后续看能否想办法生成文件位置的缓存 
(defconst spk-ctags-base-command-citre
  "ctags -R --languages=c --langmap=c:+.h --links=no --exclude=targets --exclude=vendor --exclude=bsp/kernel/kpatch --exclude=.svn --exclude=.git --exclude=Makefile --kinds-all=\'*\' --fields=\'*\' --extras=\'*\'"
  )

;; 临时tag命令，忽略不需要的文件
(defconst spk-tmp-tag-cmd "ctags -e -R --languages=c --langmap=c:+.h --links=no --exclude=targets --exclude=vendor --exclude=kmpatch --exclude=kpatch --exclude=.svn --exclude=.git --exclude=Makefile --exclude=bcm96756 --exclude=impl69 --exclude=alpha  --exclude=arc --exclude=arm64 --exclude=c6x --exclude=h8300 --exclude=hexagon --exclude=ia64 --exclude=m68k --exclude=microblaze --exclude=mips --exclude=nds32 --exclude=nios2 --exclude=openrisc --exclude=parisc --exclude=powerpc --exclude=riscv --exclude=s390 --exclude=sh --exclude=sparc --exclude=um --exclude=unicore32 --exclude=x86 --exclude=xtensa --exclude=CI --exclude=wifi/RTK --exclude=wifi/QCA .
")

;; 临时tag命令，忽略不需要的文件
(defconst spk-tmp1-tag-cmd "ctags -e -R --languages=c --langmap=c:+.h --links=no --exclude=targets --exclude=vendor --exclude=kmpatch --exclude=kpatch --exclude=.svn --exclude=.git --exclude=Makefile --exclude=bcm96756 --exclude=impl69 --exclude=arch/alpha  --exclude=arch/arc --exclude=arch/arm --exclude=arch/c6x --exclude=arch/h8300 --exclude=arch/hexagon --exclude=arch/ia64 --exclude=arch/m68k --exclude=arch/microblaze --exclude=arch/mips --exclude=arch/nds32 --exclude=arch/nios2 --exclude=arch/openrisc --exclude=arch/parisc --exclude=arch/powerpc --exclude=arch/riscv --exclude=arch/s390 --exclude=arch/sh --exclude=arch/sparc --exclude=arch/um --exclude=arch/unicore32 --exclude=arch/x86 --exclude=arch/xtensa --exclude=QCA --exclude=BCM --exclude=SIFLOWER --exclude=RTK .")


;; 直接读取citre相关的配置，后续优化
(require 'citre)

(provide 'init-citre)
