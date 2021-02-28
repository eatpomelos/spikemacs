#
# 测试 netlink 的 makefile 文件
# 不能成功 make 不知道什么原因，可能是makefile写的有问题
#

MODULE_NAME :=net_link
obj-m :=$(MODULE_NAME).o
obj-m +=net_link_user.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
    $(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
    $(MAKE) -C $(KERNELDIR) M=$(PWD) clean
