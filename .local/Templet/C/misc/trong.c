#include <stdio.h>
/* 这个文件和weak_demo.c一起编译的话，由于这里有print_hello这个函数的定义，属于一个强符号，所以会执行这个函数
   如果没有则会执行声明的弱符号。
 */
void print_hello(const char *s)
{
    printf("dark souls :%s\n", s);
}
