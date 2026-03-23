#include "ethash.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

static const uint64_t keccak_round_constants[24] = {
    0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808AULL,
    0x8000000080008000ULL, 0x000000000000808BULL, 0x0000000080000001ULL,
    0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008AULL,
    0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000AULL,
    0x000000008000808BULL, 0x800000000000008BULL, 0x8000000000008089ULL,
    0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
    0x000000000000800AULL, 0x800000008000000AULL, 0x8000000080008081ULL,
    0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
};

static uint64_t rotl64(uint64_t x, int n) { return (x << n) | (x >> (64 - n)); }

static void keccak_f1600(uint64_t state[25])
{
    for (int round = 0; round < 24; round++) {
        // Theta
        uint64_t C[5], D[5];
        for (int i = 0; i < 5; i++)
            C[i] = state[i] ^ state[i+5] ^ state[i+10] ^ state[i+15] ^ state[i+20];
        for (int i = 0; i < 5; i++) {
            D[i] = C[(i+4)%5] ^ rotl64(C[(i+1)%5], 1);
            for (int j = 0; j < 25; j += 5)
                state[j+i] ^= D[i];
        }
        // Rho and Pi
        uint64_t temp = state[1];
        static const int rho_offsets[24] = {
            1,3,6,10,15,21,28,36,45,55,2,14,27,41,56,8,25,43,62,18,39,61,20,44
        };
        static const int pi_indices[24] = {
            10,7,11,17,18,3,5,16,8,21,24,4,15,23,19,13,12,2,20,14,22,9,6,1
        };
        for (int i = 0; i < 24; i++) {
            uint64_t temp2 = state[pi_indices[i]];
            state[pi_indices[i]] = rotl64(temp, rho_offsets[i]);
            temp = temp2;
        }
        // Chi
        for (int j = 0; j < 25; j += 5) {
            uint64_t t[5];
            for (int i = 0; i < 5; i++) t[i] = state[j+i];
            for (int i = 0; i < 5; i++)
                state[j+i] = t[i] ^ (~t[(i+1)%5] & t[(i+2)%5]);
        }
        // Iota
        state[0] ^= keccak_round_constants[round];
    }
}

void ethash_keccak256(ethash_hash256 *out, const uint8_t *data, size_t size)
{
    uint64_t state[25] = {0};
    size_t rate = 136;
    while (size >= rate) {
        for (size_t i = 0; i < rate/8; i++)
            state[i] ^= ((const uint64_t*)data)[i];
        keccak_f1600(state);
        data += rate;
        size -= rate;
    }
    uint8_t temp[136] = {0};
    memcpy(temp, data, size);
    temp[size] = 0x01;
    temp[rate - 1] |= 0x80;
    for (size_t i = 0; i < rate/8; i++)
        state[i] ^= ((uint64_t*)temp)[i];
    keccak_f1600(state);
    memcpy(out->bytes, state, 32);
}

void ethash_keccak512(ethash_hash512 *out, const uint8_t *data, size_t size)
{
    uint64_t state[25] = {0};
    size_t rate = 72;
    while (size >= rate) {
        for (size_t i = 0; i < rate/8; i++)
            state[i] ^= ((const uint64_t*)data)[i];
        keccak_f1600(state);
        data += rate;
        size -= rate;
    }
    uint8_t temp[72] = {0};
    memcpy(temp, data, size);
    temp[size] = 0x01;
    temp[rate - 1] |= 0x80;
    for (size_t i = 0; i < rate/8; i++)
        state[i] ^= ((uint64_t*)temp)[i];
    keccak_f1600(state);
    memcpy(out->bytes, state, 64);
}

static uint32_t fnv1a(uint32_t u, uint32_t v) { return (u ^ v) * 0x01000193; }
static uint32_t fnv1(uint32_t u, uint32_t v) { return (u * 0x01000193) ^ v; }

static int is_prime(uint32_t n)
{
    if (n < 2) return 0;
    if (n < 4) return 1;
    if (n % 2 == 0 || n % 3 == 0) return 0;
    for (uint32_t i = 5; i * i <= n; i += 6)
        if (n % i == 0 || n % (i + 2) == 0) return 0;
    return 1;
}

uint32_t ethash_get_epoch_number(uint64_t block_number, uint32_t epoch_length)
{
    return (uint32_t)(block_number / epoch_length);
}

size_t ethash_get_light_cache_size(uint32_t epoch_number)
{
    size_t sz = ETHASH_CACHE_BYTES_INIT + ETHASH_CACHE_BYTES_GROWTH * (size_t)epoch_number;
    sz -= ETHASH_HASH_BYTES;
    while (!is_prime(sz / ETHASH_HASH_BYTES))
        sz -= 2 * ETHASH_HASH_BYTES;
    return sz;
}

uint32_t ethash_get_full_dataset_size(uint32_t epoch_number)
{
    size_t sz = (size_t)(1073741824ULL + 8388608ULL * (uint64_t)epoch_number);
    sz -= ETHASH_MIX_BYTES;
    while (!is_prime(sz / ETHASH_MIX_BYTES))
        sz -= 2 * ETHASH_MIX_BYTES;
    return (uint32_t)(sz / ETHASH_MIX_BYTES);
}

static void build_light_cache(ethash_hash512 *cache, int num_items, const ethash_hash256 *seed)
{
    ethash_keccak512(&cache[0], seed->bytes, 32);
    for (int i = 1; i < num_items; i++)
        ethash_keccak512(&cache[i], cache[i-1].bytes, 64);
    for (int round = 0; round < ETHASH_LIGHT_CACHE_ROUNDS; round++) {
        for (int i = 0; i < num_items; i++) {
            uint32_t idx = *((uint32_t*)cache[i].bytes) % num_items;
            int parent = (i + num_items - 1) % num_items;
            ethash_hash512 temp;
            for (int w = 0; w < 8; w++)
                ((uint64_t*)temp.bytes)[w] = ((uint64_t*)cache[parent].bytes)[w] ^ ((uint64_t*)cache[idx].bytes)[w];
            ethash_keccak512(&cache[i], temp.bytes, 64);
        }
    }
}

ethash_epoch_context *ethash_create_epoch_context(int epoch_number, uint32_t epoch_length)
{
    ethash_epoch_context *ctx = (ethash_epoch_context*)calloc(1, sizeof(ethash_epoch_context));
    if (!ctx) return NULL;

    ctx->epoch_number = epoch_number;

    ethash_hash256 seed = {{0}};
    for (int i = 0; i < epoch_number; i++)
        ethash_keccak256(&seed, seed.bytes, 32);

    size_t cache_size = ethash_get_light_cache_size(epoch_number);
    ctx->light_cache_num_items = (int)(cache_size / sizeof(ethash_hash512));
    ctx->light_cache = (ethash_hash512*)calloc(ctx->light_cache_num_items, sizeof(ethash_hash512));
    if (!ctx->light_cache) { free(ctx); return NULL; }

    build_light_cache(ctx->light_cache, ctx->light_cache_num_items, &seed);
    ctx->full_dataset_num_items = ethash_get_full_dataset_size(epoch_number);

    return ctx;
}

void ethash_destroy_epoch_context(ethash_epoch_context *context)
{
    if (context) {
        free(context->light_cache);
        free(context);
    }
}

static ethash_hash512 calculate_dataset_item(const ethash_epoch_context *ctx, uint32_t index)
{
    ethash_hash512 mix;
    uint32_t num_items = ctx->light_cache_num_items;

    mix = ctx->light_cache[index % num_items];
    ((uint32_t*)mix.bytes)[0] ^= index;
    ethash_keccak512(&mix, mix.bytes, 64);

    for (uint32_t j = 0; j < ETHASH_DATASET_PARENTS; j++) {
        uint32_t parent_index = fnv1(index ^ j, ((uint32_t*)mix.bytes)[j % 16]) % num_items;
        for (int w = 0; w < 8; w++)
            ((uint64_t*)mix.bytes)[w] = fnv1(((uint64_t*)mix.bytes)[w], ((uint64_t*)ctx->light_cache[parent_index].bytes)[w]);
    }
    ethash_keccak512(&mix, mix.bytes, 64);
    return mix;
}

ethash_result ethash_hash_light(const ethash_epoch_context *context,
    const ethash_hash256 *header_hash, uint64_t nonce)
{
    ethash_result result;

    uint8_t seed_buf[40];
    memcpy(seed_buf, header_hash->bytes, 32);
    memcpy(seed_buf + 32, &nonce, 8);

    ethash_hash512 seed;
    ethash_keccak512(&seed, seed_buf, 40);

    uint32_t mix[32];
    for (int i = 0; i < 16; i++) {
        mix[i] = ((uint32_t*)seed.bytes)[i % 16];
        mix[i+16] = ((uint32_t*)seed.bytes)[i % 16];
    }

    uint32_t num_full_pages = context->full_dataset_num_items / 2;
    for (uint32_t i = 0; i < ETHASH_ACCESSES; i++) {
        uint32_t p = fnv1(((uint32_t*)seed.bytes)[0] ^ i, mix[i % 32]) % num_full_pages;

        ethash_hash512 dag0 = calculate_dataset_item(context, p * 2);
        ethash_hash512 dag1 = calculate_dataset_item(context, p * 2 + 1);

        for (int w = 0; w < 16; w++) {
            mix[w] = fnv1(mix[w], ((uint32_t*)dag0.bytes)[w]);
            mix[w+16] = fnv1(mix[w+16], ((uint32_t*)dag1.bytes)[w]);
        }
    }

    uint32_t cmix[8];
    for (int i = 0; i < 8; i++) {
        cmix[i] = fnv1(fnv1(fnv1(mix[i*4], mix[i*4+1]), mix[i*4+2]), mix[i*4+3]);
    }
    memcpy(result.mix_hash.bytes, cmix, 32);

    uint8_t final_buf[64+32];
    memcpy(final_buf, seed.bytes, 64);
    memcpy(final_buf + 64, cmix, 32);
    ethash_keccak256(&result.final_hash, final_buf, 96);

    return result;
}
