#include "firopow.h"
#include "ethash/ethash.h"
#include <string.h>
#include <stdlib.h>

static ethash_epoch_context *firopow_ctx = NULL;
static int firopow_current_epoch = -1;

static ethash_epoch_context *firopow_get_context(uint64_t block_height)
{
    int epoch = ethash_get_epoch_number(block_height, FIROPOW_EPOCH_LENGTH);
    if (firopow_ctx == NULL || epoch != firopow_current_epoch) {
        if (firopow_ctx) ethash_destroy_epoch_context(firopow_ctx);
        firopow_ctx = ethash_create_epoch_context(epoch, FIROPOW_EPOCH_LENGTH);
        firopow_current_epoch = epoch;
    }
    return firopow_ctx;
}

void firopow_hash(const char* input, char* output, uint32_t len)
{
    ethash_hash256 header_hash;
    ethash_keccak256(&header_hash, (const uint8_t*)input, len);

    uint64_t nonce = 0;
    if (len >= 80)
        memcpy(&nonce, input + 76, 4);

    ethash_epoch_context *ctx = firopow_get_context(0);
    if (!ctx) {
        memset(output, 0xff, 32);
        return;
    }

    ethash_result result = ethash_hash_light(ctx, &header_hash, nonce);
    memcpy(output, result.final_hash.bytes, 32);
}
