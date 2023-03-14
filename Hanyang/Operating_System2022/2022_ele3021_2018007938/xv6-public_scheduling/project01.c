#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    printf(1, "My pid is %d\n", getpid());
    int ppid = getppid();
    printf(1, "My ppid is %d\n", ppid);
    exit();
};
