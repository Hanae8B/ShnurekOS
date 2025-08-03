; kernel/core/interrupts.asm
BITS 32

extern isr_handler_c
extern irq_handler_c

section .text
global isr_stub_0
global irq_stub_0

; ISR stub for CPU exception 0 (Divide by zero)
isr_stub_0:
    cli
    push dword 0            ; Interrupt number 0
    call isr_handler_c
    add esp, 4              ; Clean stack
    sti
    iretd

; IRQ stub for hardware IRQ0 (timer)
irq_stub_0:
    cli
    push dword 32           ; IRQ0 offset (typically 32)
    call irq_handler_c
    add esp, 4
    sti
    iretd
