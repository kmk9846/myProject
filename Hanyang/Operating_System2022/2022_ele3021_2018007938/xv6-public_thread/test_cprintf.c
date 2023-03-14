#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc, char *argv[])
{
    // char n_name[1] = myproc()->name[1];
    while (1)
    {
        printf(1, "ticks, : %d pid : %d, \n", uptime(), getpid());
    }
    exit();
}
