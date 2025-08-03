// kernel/core/pit.cpp
#include "portio.h"

void pit_init() {
    // Command byte: channel 0, access mode lobyte/hibyte, mode 2 (rate generator), binary
    outb(0x43, 0x36);

    // Divisor for 100 Hz interrupts (1193182 / 100)
    uint16_t divisor = 1193;

    outb(0x40, divisor & 0xFF);
    outb(0x40, divisor >> 8);
}
