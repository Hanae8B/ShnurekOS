; kernel/core/idt.asm
BITS 32

section .bss
align 8
idt_start:
    resb 256*8             ; 256 IDT entries, 8 bytes each
idt_end:

section .data
idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

section .text
global idt_init
extern idt_set_entry

idt_init:
    ; Initialize all IDT entries to zero by calling idt_set_entry with zeros
    xor ecx, ecx
.loop:
    cmp ecx, 256
    je .done
    push ecx
    push dword 0
    push dword 0
    call idt_set_entry
    add esp, 12         ; Clean up stack (3 arguments * 4 bytes)
    inc ecx
    jmp .loop

.done:
    lidt [idt_descriptor]    ; Load IDT register
    ret
