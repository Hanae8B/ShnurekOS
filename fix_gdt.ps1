# Paths to files
$gdt_hpp = "kernel/core/gdt.hpp"
$gdt_cpp = "kernel/core/gdt.cpp"
$kernel_cpp = "kernel/kernel.cpp"

# Update gdt.hpp
$gdt_hpp_content = @"
#pragma once

#include <stdint.h>

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

void gdt_init();
"@

Set-Content -Path $gdt_hpp -Value $gdt_hpp_content -Encoding UTF8
Write-Host "Updated $gdt_hpp"

# Update gdt.cpp
$gdt_cpp_content = @"
#include "gdt.hpp"

extern "C" void gdt_flush(uint32_t);

static GDTEntry gdt[3];
static GDTDescriptor gdt_desc;

static void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
    gdt[index].limit_low     = (limit & 0xFFFF);
    gdt[index].base_low      = (base & 0xFFFF);
    gdt[index].base_middle   = (base >> 16) & 0xFF;
    gdt[index].access        = access;
    gdt[index].granularity   = (limit >> 16) & 0x0F;
    gdt[index].granularity  |= (gran & 0xF0);
    gdt[index].base_high     = (base >> 24) & 0xFF;
}

void gdt_init() {
    gdt_desc.limit = (sizeof(GDTEntry) * 3) - 1;
    gdt_desc.base  = (uint32_t)&gdt;

    gdt_set_entry(0, 0, 0, 0, 0);                // Null segment
    gdt_set_entry(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);  // Code segment
    gdt_set_entry(2, 0, 0xFFFFFFFF, 0x92, 0xCF);  // Data segment

    gdt_flush((uint32_t)&gdt_desc);
}
"@

Set-Content -Path $gdt_cpp -Value $gdt_cpp_content -Encoding UTF8
Write-Host "Updated $gdt_cpp"

# Update kernel.cpp
$kernel_cpp_content = @"
#include "core/gdt.hpp"

extern "C" void kernel_main() {
    gdt_init();  // Initialize GDT

    const char* message = "Hello from ShnurekOS!";
    char* video_memory = (char*)0xB8000;

    for (int i = 0; message[i] != '\0'; ++i) {
        video_memory[i * 2] = message[i];
        video_memory[i * 2 + 1] = 0x07;
    }

    while (1) {}
}
"@

Set-Content -Path $kernel_cpp -Value $kernel_cpp_content -Encoding UTF8
Write-Host "Updated $kernel_cpp"

Write-Host "All files updated successfully."
