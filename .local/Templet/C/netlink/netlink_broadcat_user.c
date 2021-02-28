  #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>
  #include<sys/socket.h>
  #include<linux/netlink.h>
  #include<sys/types.h>
  #include<unistd.h>
  
  #define MYPROTO 29 //User defined group, consistent in both kernel prog and user prog
 #define MYMGRP 2 //User defined group, consistent in both kernel prog and user prog
 
 int open_netlink()
 {
     int sock = socket(AF_NETLINK,SOCK_RAW,MYPROTO);
     struct sockaddr_nl addr;
 
     memset((void *)&addr, 0, sizeof(addr));
 
     if (sock<0)
         return sock;
     addr.nl_family = AF_NETLINK;
     addr.nl_pid = getpid();
     addr.nl_groups = MYMGRP;
     if (bind(sock,(struct sockaddr *)&addr,sizeof(addr))<0)
         return -1;
     return sock;
 }
 
 int read_event(int sock)
 {
     struct sockaddr_nl nladdr;
     struct msghdr msg;
     struct iovec iov[2];
     struct nlmsghdr nlh;
     char buffer[65536];
     int ret;
     iov[0].iov_base = (void *)&nlh;
     iov[0].iov_len = sizeof(nlh);
     iov[1].iov_base = (void *)buffer;
     iov[1].iov_len = sizeof(buffer);
     msg.msg_name = (void *)&(nladdr);
     msg.msg_namelen = sizeof(nladdr);
     msg.msg_iov = iov;
     msg.msg_iovlen = sizeof(iov)/sizeof(iov[0]);
     ret=recvmsg(sock, &msg, 0);
     if (ret<0) {
         return ret;
     }
     printf("Received message payload: %s\n", NLMSG_DATA(&nlh));
     char *a = NLMSG_DATA(&nlh);
     int i;
     printf("Recv Data:\n");
     for(i = 0; i < 10; i++) {
         printf("%c", a[i]);
     }
     printf("\n");
 }
 
 int main(int argc, char *argv[])
 {
     int nls = open_netlink();
     if (nls<0) {
         err(1,"netlink");
     }
 
     while (1)
         read_event(nls);
     return 0;
 }
