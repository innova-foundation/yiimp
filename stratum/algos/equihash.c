#include "equihash.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct {
    uint64_t h[8];
    uint64_t t[2];
    uint64_t f[2];
    uint8_t buf[128];
    size_t buflen;
    size_t outlen;
} blake2b_state;

static const uint64_t blake2b_IV[8] = {
    0x6a09e667f3bcc908ULL, 0xbb67ae8584caa73bULL,
    0x3c6ef372fe94f82bULL, 0xa54ff53a5f1d36f1ULL,
    0x510e527fade682d1ULL, 0x9b05688c2b3e6c1fULL,
    0x1f83d9abfb41bd6bULL, 0x5be0cd19137e2179ULL
};

static const uint8_t blake2b_sigma[12][16] = {
    {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
    {14,10,4,8,9,15,13,6,1,12,0,2,11,7,5,3},
    {11,8,12,0,5,2,15,13,10,14,3,6,7,1,9,4},
    {7,9,3,1,13,12,11,14,2,6,5,10,4,0,15,8},
    {9,0,5,7,2,4,10,15,14,1,11,12,6,8,3,13},
    {2,12,6,10,0,11,8,3,4,13,7,5,15,14,1,9},
    {12,5,1,15,14,13,4,10,0,7,6,3,9,2,8,11},
    {13,11,7,14,12,1,3,9,5,0,15,4,8,6,2,10},
    {6,15,14,9,11,3,0,8,12,2,13,7,1,4,10,5},
    {10,2,8,4,7,6,1,5,15,11,9,14,3,12,13,0}
};

static uint64_t rotr64(uint64_t w, unsigned c) { return (w >> c) | (w << (64 - c)); }

static void blake2b_compress(blake2b_state *S, const uint8_t block[128])
{
    uint64_t m[16], v[16];
    for (int i = 0; i < 16; i++)
        m[i] = ((uint64_t*)block)[i];
    for (int i = 0; i < 8; i++) v[i] = S->h[i];
    v[8] = blake2b_IV[0]; v[9] = blake2b_IV[1];
    v[10] = blake2b_IV[2]; v[11] = blake2b_IV[3];
    v[12] = blake2b_IV[4] ^ S->t[0];
    v[13] = blake2b_IV[5] ^ S->t[1];
    v[14] = blake2b_IV[6] ^ S->f[0];
    v[15] = blake2b_IV[7] ^ S->f[1];

#define G(r,i,a,b,c,d) do { \
    a += b + m[blake2b_sigma[r][2*i]]; d = rotr64(d^a,32); \
    c += d; b = rotr64(b^c,24); \
    a += b + m[blake2b_sigma[r][2*i+1]]; d = rotr64(d^a,16); \
    c += d; b = rotr64(b^c,63); } while(0)

    for (int r = 0; r < 12; r++) {
        G(r%10,0,v[0],v[4],v[8],v[12]);  G(r%10,1,v[1],v[5],v[9],v[13]);
        G(r%10,2,v[2],v[6],v[10],v[14]); G(r%10,3,v[3],v[7],v[11],v[15]);
        G(r%10,4,v[0],v[5],v[10],v[15]); G(r%10,5,v[1],v[6],v[11],v[12]);
        G(r%10,6,v[2],v[7],v[8],v[13]);  G(r%10,7,v[3],v[4],v[9],v[14]);
    }
#undef G
    for (int i = 0; i < 8; i++) S->h[i] ^= v[i] ^ v[i+8];
}

static void blake2b_init_personal(blake2b_state *S, size_t outlen, const void *personal, size_t plen)
{
    memset(S, 0, sizeof(*S));
    S->outlen = outlen;
    for (int i = 0; i < 8; i++) S->h[i] = blake2b_IV[i];

    uint8_t P[64] = {0};
    P[0] = (uint8_t)outlen;
    P[2] = 1; P[3] = 1;
    if (personal && plen <= 16)
        memcpy(P + 48, personal, plen);
    for (int i = 0; i < 8; i++)
        S->h[i] ^= ((uint64_t*)P)[i];
}

static void blake2b_update(blake2b_state *S, const void *in, size_t inlen)
{
    const uint8_t *p = (const uint8_t *)in;
    while (inlen > 0) {
        size_t left = S->buflen;
        size_t fill = 128 - left;
        if (inlen > fill) {
            memcpy(S->buf + left, p, fill);
            S->t[0] += 128;
            if (S->t[0] < 128) S->t[1]++;
            blake2b_compress(S, S->buf);
            S->buflen = 0;
            p += fill;
            inlen -= fill;
        } else {
            memcpy(S->buf + left, p, inlen);
            S->buflen += inlen;
            break;
        }
    }
}

static void blake2b_final(blake2b_state *S, void *out, size_t outlen)
{
    S->t[0] += S->buflen;
    if (S->t[0] < S->buflen) S->t[1]++;
    S->f[0] = (uint64_t)-1;
    memset(S->buf + S->buflen, 0, 128 - S->buflen);
    blake2b_compress(S, S->buf);
    memcpy(out, S->h, outlen < 64 ? outlen : 64);
}

static void expand_indices(const uint8_t *packed, uint32_t *indices, int n_bits, int n_indices)
{
    int bit_pos = 0;
    for (int i = 0; i < n_indices; i++) {
        uint32_t idx = 0;
        for (int j = 0; j < n_bits; j++) {
            int byte_pos = bit_pos / 8;
            int bit_off = bit_pos % 8;
            idx |= ((uint32_t)((packed[byte_pos] >> bit_off) & 1)) << j;
            bit_pos++;
        }
        indices[i] = idx;
    }
}

static void generate_hash(const uint8_t *base_state, size_t base_len,
                          uint32_t index, uint8_t *hash, int hash_len,
                          int n, int k)
{
    int indices_per_hash = 512 / n;
    int hash_output_len = (indices_per_hash * n) / 8;

    uint32_t gen_index = index / indices_per_hash;

    uint8_t personal[16] = "ZcashPoW";
    personal[8]  = n & 0xff; personal[9]  = (n>>8) & 0xff;
    personal[10] = (n>>16) & 0xff; personal[11] = (n>>24) & 0xff;
    personal[12] = k & 0xff; personal[13] = (k>>8) & 0xff;
    personal[14] = (k>>16) & 0xff; personal[15] = (k>>24) & 0xff;

    blake2b_state S;
    blake2b_init_personal(&S, hash_output_len, personal, 16);
    blake2b_update(&S, base_state, base_len);
    uint8_t le_index[4] = {gen_index & 0xff, (gen_index>>8) & 0xff,
                           (gen_index>>16) & 0xff, (gen_index>>24) & 0xff};
    blake2b_update(&S, le_index, 4);

    uint8_t full_hash[256];
    blake2b_final(&S, full_hash, hash_output_len);

    int start = (index % indices_per_hash) * (n / 8);
    memcpy(hash, full_hash + start, n / 8);
}

int equihash_verify(const uint8_t* header, size_t header_len,
                    const uint8_t* solution, size_t solution_len,
                    int n, int k)
{
    int n_indices = 1 << k;
    int collision_bit_len = n / (k + 1);
    int collision_byte_len = (collision_bit_len + 7) / 8;
    int index_bits = collision_bit_len + 1;
    int expected_sol_size = (n_indices * index_bits + 7) / 8;

    if ((int)solution_len != expected_sol_size)
        return 0;

    uint32_t *indices = (uint32_t*)calloc(n_indices, sizeof(uint32_t));
    if (!indices) return 0;
    expand_indices(solution, indices, index_bits, n_indices);

    for (int i = 0; i < n_indices; i++)
        for (int j = i + 1; j < n_indices; j++)
            if (indices[i] == indices[j]) { free(indices); return 0; }

    int hash_len = n / 8;
    uint8_t **hashes = (uint8_t**)calloc(n_indices, sizeof(uint8_t*));
    for (int i = 0; i < n_indices; i++) {
        hashes[i] = (uint8_t*)calloc(1, hash_len);
        generate_hash(header, header_len, indices[i], hashes[i], hash_len, n, k);
    }

    int valid = 1;
    int current_count = n_indices;
    for (int round = 0; round < k && valid; round++) {
        int next_count = current_count / 2;
        for (int i = 0; i < next_count; i++) {
            for (int b = 0; b < hash_len; b++)
                hashes[i][b] = hashes[2*i][b] ^ hashes[2*i+1][b];

            for (int b = 0; b < collision_byte_len && b < hash_len; b++) {
                if (round < k - 1 && hashes[i][b] != 0) {
                }
            }
        }
        current_count = next_count;
    }

    if (current_count == 1) {
        for (int b = 0; b < hash_len; b++)
            if (hashes[0][b] != 0) { valid = 0; break; }
    }

    for (int i = 0; i < n_indices; i++) free(hashes[i]);
    free(hashes);
    free(indices);

    return valid;
}

void equihash_hash(const char* input, char* output, uint32_t len)
{
    uint8_t personal[16] = "ZcashPoW";
    personal[8] = 200; personal[9] = 0; personal[10] = 0; personal[11] = 0;
    personal[12] = 9; personal[13] = 0; personal[14] = 0; personal[15] = 0;

    blake2b_state S;
    blake2b_init_personal(&S, 32, personal, 16);
    blake2b_update(&S, input, len);
    blake2b_final(&S, output, 32);
}
