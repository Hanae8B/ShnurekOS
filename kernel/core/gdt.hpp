#pragma once

#include <stdint.h>

// Declare gdt_init() with C linkage to avoid name mangling
extern "C" void gdt_init();

struct GDTDescriptor {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

struct GDTEntry {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_middle;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} __attribute__((packed));
