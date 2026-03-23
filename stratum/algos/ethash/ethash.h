#ifndef ETHASH_H
#define ETHASH_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>

#define ETHASH_EPOCH_LENGTH 30000
#define ETHASH_LIGHT_CACHE_ROUNDS 3
#define ETHASH_HASH_BYTES 64
#define ETHASH_DATASET_PARENTS 256
#define ETHASH_CACHE_BYTES_INIT 16777216  // 2^24
#define ETHASH_CACHE_BYTES_GROWTH 131072  // 2^17
#define ETHASH_MIX_BYTES 128
#define ETHASH_ACCESSES 64

#define KAWPOW_EPOCH_LENGTH 7500
#define KAWPOW_CNT_DAG 64
#define KAWPOW_CNT_MATH 18
#define KAWPOW_CNT_CACHE 12
#define KAWPOW_REGS 32
#define KAWPOW_LANES 16
#define KAWPOW_CACHE_BYTES 16776896

#define FIROPOW_EPOCH_LENGTH 1300
#define FIROPOW_CNT_DAG 64
#define FIROPOW_CNT_MATH 18
#define FIROPOW_CNT_CACHE 12

typedef struct {
    uint8_t bytes[32];
} ethash_hash256;

typedef struct {
    uint8_t bytes[64];
} ethash_hash512;

typedef struct {
    uint8_t bytes[128];
} ethash_hash1024;

typedef struct {
    ethash_hash256 final_hash;
    ethash_hash256 mix_hash;
} ethash_result;

typedef struct {
    int epoch_number;
    int light_cache_num_items;
    ethash_hash512 *light_cache;
    uint32_t full_dataset_num_items;
} ethash_epoch_context;

uint32_t ethash_get_epoch_number(uint64_t block_number, uint32_t epoch_length);
size_t ethash_get_light_cache_size(uint32_t epoch_number);
uint32_t ethash_get_full_dataset_size(uint32_t epoch_number);

ethash_epoch_context *ethash_create_epoch_context(int epoch_number, uint32_t epoch_length);
void ethash_destroy_epoch_context(ethash_epoch_context *context);

void ethash_keccak256(ethash_hash256 *out, const uint8_t *data, size_t size);
void ethash_keccak512(ethash_hash512 *out, const uint8_t *data, size_t size);

ethash_result ethash_hash_light(const ethash_epoch_context *context,
    const ethash_hash256 *header_hash, uint64_t nonce);

#ifdef __cplusplus
}
#endif
#endif
