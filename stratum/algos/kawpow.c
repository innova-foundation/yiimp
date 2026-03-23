#include "kawpow.h"
#include "ethash/ethash.h"
#include <string.h>
#include <stdlib.h>

static ethash_epoch_context *kawpow_ctx = NULL;
static int kawpow_current_epoch = -1;

static ethash_epoch_context *kawpow_get_context(uint64_t block_height)
{
    int epoch = ethash_get_epoch_number(block_height, KAWPOW_EPOCH_LENGTH);
    if (kawpow_ctx == NULL || epoch != kawpow_current_epoch) {
        if (kawpow_ctx) ethash_destroy_epoch_context(kawpow_ctx);
        kawpow_ctx = ethash_create_epoch_context(epoch, KAWPOW_EPOCH_LENGTH);
        kawpow_current_epoch = epoch;
    }
    return kawpow_ctx;
}

void kawpow_hash(const char* input, char* output, uint32_t len)
{
    ethash_hash256 header_hash;
    ethash_keccak256(&header_hash, (const uint8_t*)input, len);

    uint64_t nonce = 0;
    if (len >= 80)
        memcpy(&nonce, input + 76, 4);

    ethash_epoch_context *ctx = kawpow_get_context(0);
    if (!ctx) {
        memset(output, 0xff, 32);
        return;
    }

    ethash_result result = ethash_hash_light(ctx, &header_hash, nonce);
    memcpy(output, result.final_hash.bytes, 32);
}
