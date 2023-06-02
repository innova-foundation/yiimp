
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <openssl/sha.h>

#include <stdlib.h>

void sha256q_hash(const char* input, char* output, uint32_t len)
{
	unsigned char hash[64];

	SHA256(input, len, hash);
	SHA256(hash, 32, hash);
	SHA256(hash, 32, hash);
	SHA256(hash, 32, (unsigned char*)output);
}

