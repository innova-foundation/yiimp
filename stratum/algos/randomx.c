#include "randomx.h"
#include <string.h>
#include <stdlib.h>

void randomx_stratum_init(const char* seed_hash)
{
	(void)seed_hash;
}

void randomx_stratum_cleanup(void)
{
}

void randomx_hash(const char* input, char* output, uint32_t len)
{
	(void)input;
	(void)len;
	memset(output, 0xff, 32);
}
