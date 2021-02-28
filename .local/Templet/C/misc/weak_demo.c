#include <stdio.h>

/* void print_world(const char *s) */
/* { */
/*     printf("dark souls :%s\n", s); */
/* } */

/* __attribute__ 可以指定函数属性、变量属性和类型属性 */

void print_hello(const char *s) __attribute__ ((weak, alias ("__weak_hello")));
void print_world(const char *s) __attribute__ ((weak, alias ("__weak_hello")));

void __weak_hello(const char *s)
{
    printf("__weak_hello:%s\n", s);
}


int main(int argc,char*argv[])
{
    print_hello("hello");
    print_world("world");
    return 0;
}
