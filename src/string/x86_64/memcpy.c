#include <string.h>
#include <stdint.h>
#include <endian.h>

#define __rte_always_inline inline

#ifdef __AVX__
#define RTE_MACHINE_CPUFLAG_AVX 1
#endif

#ifdef __AVX2__
#define RTE_MACHINE_CPUFLAG_AVX2 1
#endif

#ifdef __AVX512F__
#define RTE_MACHINE_CPUFLAG_AVX512F 1
#endif

#ifndef __SSE3__
#error "sse3 is required"
#endif

#include <immintrin.h>
// copied from dpdk
#include "rte_memcpy.h"

void *memcpy(void *restrict dest, const void *restrict src, size_t n)
{
	return rte_memcpy(dest, src, n);
}

