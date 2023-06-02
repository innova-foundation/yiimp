#include <string.h>
#include <openssl/sha.h>

void sha256_hash(const char *input, char *output, unsigned int len)
{
	if(!len) len = strlen((const char *)input);
	SHA256((uint8_t*)input, len, (unsigned char*)output);
}

void sha256_double_hash(const char *input, char *output, unsigned int len)
{
	char output1[32];

	sha256_hash(input, output1, len);
	sha256_hash(output1, output, 32);
}

