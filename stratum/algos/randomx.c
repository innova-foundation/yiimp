#include "randomx.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

typedef struct randomx_cache randomx_cache;
typedef struct randomx_vm randomx_vm;

typedef enum {
    RANDOMX_FLAG_DEFAULT = 0,
    RANDOMX_FLAG_LARGE_PAGES = 1,
    RANDOMX_FLAG_HARD_AES = 2,
    RANDOMX_FLAG_FULL_MEM = 4,
    RANDOMX_FLAG_JIT = 8,
    RANDOMX_FLAG_ARGON2_SSSE3 = 16,
    RANDOMX_FLAG_ARGON2_AVX2 = 32,
    RANDOMX_FLAG_ARGON2 = 48
} randomx_flags;

extern randomx_flags randomx_get_flags(void);
extern randomx_cache *randomx_alloc_cache(randomx_flags flags);
extern void randomx_init_cache(randomx_cache *cache, const void *key, size_t keySize);
extern void randomx_release_cache(randomx_cache *cache);
extern randomx_vm *randomx_create_vm(randomx_flags flags, randomx_cache *cache, void *dataset);
extern void randomx_vm_set_cache(randomx_vm *vm, randomx_cache *cache);
extern void randomx_destroy_vm(randomx_vm *vm);
extern void randomx_calculate_hash(randomx_vm *vm, const void *input, size_t inputSize, void *output);

static randomx_cache *rx_cache = NULL;
static randomx_vm *rx_vm = NULL;
static pthread_mutex_t rx_mutex = PTHREAD_MUTEX_INITIALIZER;
static char rx_current_seed[32] = {0};
static int rx_initialized = 0;

void randomx_stratum_init(const char* seed_hash)
{
    pthread_mutex_lock(&rx_mutex);

    if (rx_initialized && memcmp(rx_current_seed, seed_hash, 32) == 0) {
        pthread_mutex_unlock(&rx_mutex);
        return;
    }

    randomx_flags flags = randomx_get_flags();

    if (!rx_cache) {
        rx_cache = randomx_alloc_cache(flags | RANDOMX_FLAG_JIT);
        if (!rx_cache) {
            rx_cache = randomx_alloc_cache(flags);
        }
    }

    if (rx_cache) {
        randomx_init_cache(rx_cache, seed_hash, 32);
        memcpy(rx_current_seed, seed_hash, 32);

        if (!rx_vm) {
            rx_vm = randomx_create_vm(flags | RANDOMX_FLAG_JIT, rx_cache, NULL);
            if (!rx_vm) {
                rx_vm = randomx_create_vm(flags, rx_cache, NULL);
            }
        } else {
            randomx_vm_set_cache(rx_vm, rx_cache);
        }
        rx_initialized = 1;
    }

    pthread_mutex_unlock(&rx_mutex);
}

void randomx_stratum_cleanup(void)
{
    pthread_mutex_lock(&rx_mutex);
    if (rx_vm) { randomx_destroy_vm(rx_vm); rx_vm = NULL; }
    if (rx_cache) { randomx_release_cache(rx_cache); rx_cache = NULL; }
    rx_initialized = 0;
    pthread_mutex_unlock(&rx_mutex);
}

void randomx_hash(const char* input, char* output, uint32_t len)
{
    pthread_mutex_lock(&rx_mutex);

    if (!rx_initialized || !rx_vm) {
        if (!rx_initialized && len >= 32) {
            pthread_mutex_unlock(&rx_mutex);
            randomx_stratum_init(input);
            pthread_mutex_lock(&rx_mutex);
        }
        if (!rx_vm) {
            memset(output, 0xff, 32);
            pthread_mutex_unlock(&rx_mutex);
            return;
        }
    }

    randomx_calculate_hash(rx_vm, input, len, output);

    pthread_mutex_unlock(&rx_mutex);
}
