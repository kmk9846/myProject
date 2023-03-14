#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    while(1)
    {
        int n_fork = fork();
        if (n_fork > 0) 
        {
            printf(1, "Parent\n");
            yield();
        }
        else if(n_fork == 0) 
        {
            printf(1, "Child\n");
            yield();
        }
    }
    exit();
}