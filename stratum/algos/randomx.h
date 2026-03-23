#ifndef RANDOMX_HASH_H
#define RANDOMX_HASH_H
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
void randomx_hash(const char* input, char* output, uint32_t len);
void randomx_stratum_init(const char* seed_hash);
void randomx_stratum_cleanup(void);
#ifdef __cplusplus
}
#endif
#endif
