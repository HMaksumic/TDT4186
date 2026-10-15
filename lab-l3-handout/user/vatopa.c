#include "kernel/types.h"
#include "user/user.h"

static int
digit_value(char c)
{
    if (c >= '0' && c <= '9')
        return c - '0';
    if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    return -1;
}

static uint64
parse_uint64(const char *s)
{
    uint64 value = 0;
    int base = 10;
    int digit;

    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
    {
        base = 16;
        s += 2;
    }

    while ((digit = digit_value(*s)) >= 0 && digit < base)
    {
        value = value * base + digit;
        s++;
    }

    return value;
}

int
main(int argc, char *argv[])
{
    uint64 va;
    int pid = 0;

    if (argc != 2 && argc != 3)
    {
        printf("Usage: vatopa virtual_address [pid]\n");
        exit(1);
    }

    va = parse_uint64(argv[1]);
    if (argc == 3)
        pid = (int)parse_uint64(argv[2]);

    printf("0x%x\n", (int)va2pa(va, pid));
    exit(0);
}
