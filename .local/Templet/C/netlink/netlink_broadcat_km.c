 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <net/sock.h>
 #include <linux/socket.h>
 #include <linux/net.h>
 #include <asm/types.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
 
 #define NETLINK_USER 29  //User defined group, consistent in both kernel prog and user prog
 #define MYGRP 2 //User defined group, consistent in both kernel prog and user prog
 
 struct sock *nl_sk = NULL;
 
 static void send_to_user(void);
 
 static void send_to_user(void)
 {
     struct sk_buff *skb_out;
     struct nlmsghdr *nlh;
     int msg_size;
     char msg[20] = "Hello from kernel";
     int res;
 
     printk(KERN_INFO "Entering: %s\n", __FUNCTION__);
     msg_size = strlen(msg);
     printk(KERN_INFO "msg_size: %d\n", msg_size);
     //msg[msg_size - 1] = '\0';
     skb_out = nlmsg_new(msg_size, 0);
 
     if (!skb_out) {
         printk(KERN_ERR "Failed to allocate new skb\n");
         return;
     }
     nlh = nlmsg_put(skb_out, 0, 1, NLMSG_DONE, msg_size, 0);
     //NETLINK_CB(skb_out).dst_group = 1; /* Multicast to group 1, 1<<0 */
     strncpy(nlmsg_data(nlh), msg, msg_size);
 
     res = nlmsg_multicast(nl_sk, skb_out, 0, MYGRP, 0);
     if (res < 0) {
         printk(KERN_INFO "Error while sending bak to user, err id: %d\n", res);
     }
 }
 
 static int __init
 hello_init(void) {
 
     struct netlink_kernel_cfg cfg = {
         .groups = MYGRP,
     };
     printk("Entering: %s\n", __FUNCTION__);
     nl_sk = netlink_kernel_create(&init_net, NETLINK_USER, &cfg);
     if (!nl_sk) {
         printk(KERN_ALERT "Error creating socket.\n");
         return -10;
     }
 
     msleep(10000);
     send_to_user();
 
     return 0;
 }
 
 static void __exit
 hello_exit(void) {
 
     printk(KERN_INFO "exiting hello module\n");
     netlink_kernel_release(nl_sk);
 }
 
 module_init(hello_init);
 module_exit(hello_exit);
 MODULE_LICENSE("GPL");
