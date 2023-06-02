#ifndef SHA256_H
#define SHA256_H

#include <string.h>

__inline uint32_t le32dec(const void *pp)
{
       const uint8_t *p = (uint8_t const *)pp;

       return ((uint32_t)(p[0]) + ((uint32_t)(p[1]) << 8) +
           ((uint32_t)(p[2]) << 16) + ((uint32_t)(p[3]) << 24));
}

__inline void le32enc(void *pp, uint32_t x)
{
       uint8_t * p = (uint8_t *)pp;

       p[0] = x & 0xff;
       p[1] = (x >> 8) & 0xff;
       p[2] = (x >> 16) & 0xff;
       p[3] = (x >> 24) & 0xff;
}

void sha256_hash(const char *input, char *output, unsigned int len);
void sha256_double_hash(const char *input, char *output, unsigned int len);

#endif
