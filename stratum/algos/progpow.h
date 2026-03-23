#ifndef PROGPOW_H
#define PROGPOW_H
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
void progpow_hash(const char* input, char* output, uint32_t len);
#ifdef __cplusplus
}
#endif
#endif
