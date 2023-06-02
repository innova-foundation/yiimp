
#include "skein.h"
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <openssl/sha.h>

#include "../sha3/sph_skein.h"

#include <stdlib.h>

void skein_hash(const char* input, char* output, uint32_t len)
{
    char temp[64];

    sph_skein512_context ctx_skien;
    sph_skein512_init(&ctx_skien);
    sph_skein512(&ctx_skien, input, len);
    sph_skein512_close(&ctx_skien, &temp);

    SHA256(temp, 64, (unsigned char*) output);
}

