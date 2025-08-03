// kernel/core/interrupt_handlers.c
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void isr_handler_c(int interrupt_number) {
    // Handle CPU exceptions here, for now infinite halt loop
    while (1) {
        __asm__ __volatile__("hlt");
    }
}

void irq_handler_c(int irq_number) {
    // Handle hardware IRQs here, for now infinite halt loop
    while (1) {
        __asm__ __volatile__("hlt");
    }
}

#ifdef __cplusplus
}
#endif
