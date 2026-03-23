#include "panthera.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

typedef struct randomx_cache randomx_cache;
typedef struct randomx_vm randomx_vm;
typedef enum {
    RX_FLAG_DEFAULT = 0,
    RX_FLAG_LARGE_PAGES = 1,
    RX_FLAG_HARD_AES = 2,
    RX_FLAG_FULL_MEM = 4,
    RX_FLAG_JIT = 8,
    RX_FLAG_ARGON2 = 48
} rx_flags;

extern rx_flags randomx_get_flags(void);
extern randomx_cache *randomx_alloc_cache(rx_flags flags);
extern void randomx_init_cache(randomx_cache *cache, const void *key, size_t keySize);
extern void randomx_release_cache(randomx_cache *cache);
extern randomx_vm *randomx_create_vm(rx_flags flags, randomx_cache *cache, void *dataset);
extern void randomx_vm_set_cache(randomx_vm *vm, randomx_cache *cache);
extern void randomx_destroy_vm(randomx_vm *vm);
extern void randomx_calculate_hash(randomx_vm *vm, const void *input, size_t inputSize, void *output);

static randomx_cache *panthera_cache = NULL;
static randomx_vm *panthera_vm = NULL;
static pthread_mutex_t panthera_mutex = PTHREAD_MUTEX_INITIALIZER;
static char panthera_seed[32] = {0};
static int panthera_init = 0;

void panthera_hash(const char* input, char* output, uint32_t len)
{
    pthread_mutex_lock(&panthera_mutex);

    if (!panthera_init) {

        rx_flags flags = randomx_get_flags();
        if (!panthera_cache) {
            panthera_cache = randomx_alloc_cache(flags | RX_FLAG_JIT);
            if (!panthera_cache)
                panthera_cache = randomx_alloc_cache(flags);
        }
        if (panthera_cache) {

            char seed_key[40] = "panthera";
            memcpy(seed_key + 8, input, len < 32 ? len : 32);
            randomx_init_cache(panthera_cache, seed_key, 8 + (len < 32 ? len : 32));

            if (!panthera_vm) {
                panthera_vm = randomx_create_vm(flags | RX_FLAG_JIT, panthera_cache, NULL);
                if (!panthera_vm)
                    panthera_vm = randomx_create_vm(flags, panthera_cache, NULL);
            } else {
                randomx_vm_set_cache(panthera_vm, panthera_cache);
            }
            panthera_init = 1;
        }
    }

    if (!panthera_vm) {
        memset(output, 0xff, 32);
        pthread_mutex_unlock(&panthera_mutex);
        return;
    }

    randomx_calculate_hash(panthera_vm, input, len, output);
    pthread_mutex_unlock(&panthera_mutex);
}
