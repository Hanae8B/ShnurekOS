#include "gdt.hpp"

// gdt_flush is an assembly routine (defined in gdt.asm)
extern "C" void gdt_flush(uint32_t);

// GDT entries and descriptor
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

extern "C" void gdt_init() {
    gdt_desc.limit = sizeof(GDTEntry) * 3 - 1;
    gdt_desc.base  = (uint32_t)&gdt;

    // Null segment
    gdt_set_entry(0, 0, 0, 0, 0);
    // Code segment: base=0, limit=4GB, access=code segment, granularity=4K
    gdt_set_entry(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    // Data segment: base=0, limit=4GB, access=data segment, granularity=4K
    gdt_set_entry(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

    // Load the GDT using the assembly routine
    gdt_flush((uint32_t)&gdt_desc);
}
