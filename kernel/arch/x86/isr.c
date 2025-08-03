#include "idt.h"

extern void isr0();
extern void isr1();

void isr_install() {
    idt_set_gate(0, (uint32_t)isr0, 0x08, 0x8E);
    idt_set_gate(1, (uint32_t)isr1, 0x08, 0x8E);
}
