; kernel/core/idt_load.asm
BITS 32
global idt_load

section .text
idt_load:
    lidt [eax]    ; Load IDT from pointer passed in EAX
    ret
