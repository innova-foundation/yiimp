#ifndef FIROPOW_H
#define FIROPOW_H
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
void firopow_hash(const char* input, char* output, uint32_t len);
#ifdef __cplusplus
}
#endif
#endif
