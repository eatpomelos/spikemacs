/* 内核态程序 */
#include <linux/init.h>
#include <linux/module.h>
#include <linux/types.h>
#include <net/sock.h>
#include <linux/netlink.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("luoyu1@tenda.cn");
MODULE_DESCRIPTION("test netlink");

#define NETLINK_TEST 30
#define MSG_LEN 125
#define USER_PORT 100

struct sock *nlsk = NULL;
extern struct net init_net;

struct netlink_kernel_cfg cfg = {
    .input = netlink_rcv_msg,
};

int send_usrmsg(char *pbuf, uint16_t len)
{
    struct sk_buff *nl_skb;
    struct nlmsghdr *nlh;

    int ret;

    nl_skb = nlmsg_new(len, GFP_ATOMIC);
    if (!nl_skb)
    {
        printk("netlink alloc failure\n");
	return -1;
    }

    nlh = nlmsg_put(nl_skb, 0, 0, NETLINK_TEST, len, 0);
    if (NULL == nlh)
    {
	printk("nlmsg_put failure \n");
	nlmsg_free(nl_skb);
	return -1;
    }

    memcpy(nlmsg_data(nlh), pbuf, len);
    ret = netlink_unicast(nlsk, nl_skb, USER_PORT, MSG_DONTWAIT);

    return ret;
}

static void netlink_rcv_msg(struct sk_buff *skb)
{
    struct nlmsghdr *nlh = NULL;
    char *umsg = NULL;
    char *kmsg = NULL;

    if (skb->len >= nlmsg_total_size(0))
    {
	nlh = nlmsg_hdr(skb);
	umsg = NLMSG_DATA(nlh);
	if (umsg) {
	    printk("Kernel recv from user:%s\n", umsg);
	    send_usrmsg(kmsg, strlen(kmsg));
	}
    }
}

int test_netlink_init(void)
{
    nlsk = (struct sock *)netlink_kernel_create(&init_net, NETLINK_TEST, &cfg);

    if (NULL == nlsk) {
	printk("netlink_kernel_create error!\n");
	return -1;
    }
    printk("netlink_kernel_init finished!\n");

    return 0;
}

void test_netlink_exit(void)
{
    if (nlsk) {
	netlink_kernel_release(nlsk);
	nlsk = NULL;
    }
}

module_init(test_netlink_init);
module_exit(test_netlink_exit);
