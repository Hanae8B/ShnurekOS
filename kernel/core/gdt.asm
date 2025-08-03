; kernel/core/gdt.asm
BITS 32
section .data

gdt_start:
    dq 0                   ; Null descriptor

    ; Code segment descriptor
    dw 0xFFFF              ; limit low
    dw 0                    ; base low
    db 0                    ; base middle
    db 10011010b            ; access: present, ring 0, code segment, executable, readable
    db 11001111b            ; granularity: 4K, 32-bit
    db 0                    ; base high

    ; Data segment descriptor
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b            ; access: present, ring 0, data segment, writable
    db 11001111b
    db 0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

section .text
global gdt_init
gdt_init:
    lgdt [gdt_descriptor]
    mov ax, 0x10           ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Far jump to load code segment selector (0x08)
    jmp 0x08:.flush

.flush:
    ret
