#include "panthera.h"
#include <string.h>
#include <stdlib.h>

void panthera_hash(const char* input, char* output, uint32_t len)
{
	(void)input;
	(void)len;
	memset(output, 0xff, 32);
}
