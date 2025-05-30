
#define TEST_NAME "scalarmult2"
#include "cmptest.h"

static unsigned char bobsk[32] = { 0x5d, 0xab, 0x08, 0x7e, 0x62, 0x4a, 0x8a,
                                   0x4b, 0x79, 0xe1, 0x7f, 0x8b, 0x83, 0x80,
                                   0x0e, 0xe6, 0x6f, 0x3b, 0xb1, 0x29, 0x26,
                                   0x18, 0xb6, 0xfd, 0x1c, 0x2f, 0x8b, 0x27,
                                   0xff, 0x88, 0xe0, 0xeb };

int
main(void)
{
    unsigned char bobpk[32];
    char          hex[65];

    crypto_scalarmult_base(bobpk, bobsk);
    sodium_bin2hex(hex, sizeof hex, bobpk, sizeof bobpk);
    printf("%s\n", hex);

    return 0;
}
