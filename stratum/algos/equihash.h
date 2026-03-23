#ifndef EQUIHASH_H
#define EQUIHASH_H
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include <stddef.h>

/* Equihash(200,9) parameters for Zcash */
#define EQUIHASH_N 200
#define EQUIHASH_K 9
#define EQUIHASH_SOLUTION_SIZE 1344  /* (2^k) * ((n/(k+1))+1) / 8 */

void equihash_hash(const char* input, char* output, uint32_t len);

/* Verify an equihash solution */
int equihash_verify(const uint8_t* header, size_t header_len,
                    const uint8_t* solution, size_t solution_len,
                    int n, int k);

#ifdef __cplusplus
}
#endif
#endif
