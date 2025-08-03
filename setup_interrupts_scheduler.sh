#!/bin/bash
set -e

BASE_DIR="$HOME/ShnurekOS/kernel/core"
mkdir -p "$BASE_DIR"

echo "Creating and writing interrupts.asm ..."
cat > "$BASE_DIR/interrupts.asm" << 'EOF'
; interrupts.asm - ISR stubs and IDT setup

BITS 32

section .data
align 8
idt_start:
    times 256 dq 0          ; 256 IDT entries, 8 bytes each
idt_end:

idt_ptr:
    dw idt_end - idt_start - 1
    dd idt_start

section .text
global idt_load
extern isr_stub_table

; Load the IDT
idt_load:
    lidt [idt_ptr]
    ret

; ISR stub entry points (defined in interrupts_stub.asm or inline below)
; Here we define a simple macro to generate ISR stubs for CPU exceptions and IRQs

%macro ISR_STUB 1
isr_%1:
    cli                     ; Clear interrupts
    push dword 0            ; Push error code 0 if none
    push dword %1           ; Push ISR number
    jmp isr_common_stub
%endmacro

section .text
global isr_common_stub
isr_common_stub:
    pusha                   ; Push all general-purpose registers
    ; Call C handler (extern isr_handler_c)
    extern isr_handler_c
    push esp                ; Pass pointer to registers as argument
    call isr_handler_c
    add esp, 4
    popa                    ; Restore registers
    add esp, 8              ; Remove error code and ISR number from stack
    sti                     ; Set interrupts
    iretd                   ; Return from interrupt

; Define ISR stubs 0-31 for CPU exceptions
ISR_STUB 0
ISR_STUB 1
ISR_STUB 2
ISR_STUB 3
ISR_STUB 4
ISR_STUB 5
ISR_STUB 6
ISR_STUB 7
ISR_STUB 8
ISR_STUB 9
ISR_STUB 10
ISR_STUB 11
ISR_STUB 12
ISR_STUB 13
ISR_STUB 14
ISR_STUB 15
ISR_STUB 16
ISR_STUB 17
ISR_STUB 18
ISR_STUB 19
ISR_STUB 20
ISR_STUB 21
ISR_STUB 22
ISR_STUB 23
ISR_STUB 24
ISR_STUB 25
ISR_STUB 26
ISR_STUB 27
ISR_STUB 28
ISR_STUB 29
ISR_STUB 30
ISR_STUB 31

; IRQ stubs 32-47
ISR_STUB 32
ISR_STUB 33
ISR_STUB 34
ISR_STUB 35
ISR_STUB 36
ISR_STUB 37
ISR_STUB 38
ISR_STUB 39
ISR_STUB 40
ISR_STUB 41
ISR_STUB 42
ISR_STUB 43
ISR_STUB 44
ISR_STUB 45
ISR_STUB 46
ISR_STUB 47
EOF

echo "Creating and writing pic.c ..."
cat > "$BASE_DIR/pic.c" << 'EOF'
#include <stdint.h>

#define PIC1_COMMAND 0x20
#define PIC1_DATA    0x21
#define PIC2_COMMAND 0xA0
#define PIC2_DATA    0xA1

#define ICW1_INIT    0x10
#define ICW1_ICW4    0x01

#define ICW4_8086    0x01

void pic_remap(int offset1, int offset2) {
    // Save masks
    uint8_t a1 = inb(PIC1_DATA);
    uint8_t a2 = inb(PIC2_DATA);

    // Starts the initialization sequence (in cascade mode)
    outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);
    outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);
    outb(PIC1_DATA, offset1);  // Master PIC vector offset
    outb(PIC2_DATA, offset2);  // Slave PIC vector offset
    outb(PIC1_DATA, 4);        // Tell Master PIC that there is a slave PIC at IRQ2
    outb(PIC2_DATA, 2);        // Tell Slave PIC its cascade identity
    outb(PIC1_DATA, ICW4_8086);
    outb(PIC2_DATA, ICW4_8086);

    // Restore saved masks
    outb(PIC1_DATA, a1);
    outb(PIC2_DATA, a2);
}

void pic_send_eoi(unsigned char irq) {
    if (irq >= 8) {
        outb(PIC2_COMMAND, 0x20);
    }
    outb(PIC1_COMMAND, 0x20);
}

// I/O port access (inline assembly)
static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ("inb %1, %0"
                      : "=a"(ret)
                      : "Nd"(port));
    return ret;
}
EOF

echo "Creating and writing pit.c ..."
cat > "$BASE_DIR/pit.c" << 'EOF'
#include <stdint.h>

#define PIT_CHANNEL0 0x40
#define PIT_COMMAND  0x43

void pit_init(uint32_t frequency) {
    uint32_t divisor = 1193180 / frequency;
    outb(PIT_COMMAND, 0x36);        // Channel 0, lobyte/hibyte, mode 3 (square wave)
    outb(PIT_CHANNEL0, divisor & 0xFF);       // Low byte
    outb(PIT_CHANNEL0, (divisor >> 8) & 0xFF);// High byte
}

// I/O port access (inline assembly)
static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}
EOF

echo "Creating and writing scheduler.c ..."
cat > "$BASE_DIR/scheduler.c" << 'EOF'
#include <stdint.h>
#include <stddef.h>

#define MAX_TASKS 10

typedef struct {
    uint32_t esp;
    uint32_t ebp;
    uint32_t eip;
    uint8_t active;
} task_t;

static task_t tasks[MAX_TASKS];
static int current_task = -1;

extern void context_switch(uint32_t* old_sp, uint32_t new_sp);

void scheduler_init() {
    for (int i = 0; i < MAX_TASKS; i++) {
        tasks[i].active = 0;
        tasks[i].esp = 0;
        tasks[i].ebp = 0;
        tasks[i].eip = 0;
    }
}

int scheduler_add_task(uint32_t eip, uint32_t esp, uint32_t ebp) {
    for (int i = 0; i < MAX_TASKS; i++) {
        if (!tasks[i].active) {
            tasks[i].active = 1;
            tasks[i].eip = eip;
            tasks[i].esp = esp;
            tasks[i].ebp = ebp;
            return i;
        }
    }
    return -1; // No free task slot
}

void scheduler_switch() {
    int prev_task = current_task;
    // Find next active task
    for (int i = 1; i <= MAX_TASKS; i++) {
        int next = (current_task + i) % MAX_TASKS;
        if (tasks[next].active) {
            current_task = next;
            break;
        }
    }
    if (prev_task == current_task) {
        // Only one task or none active, no switch
        return;
    }

    task_t* old_task = &tasks[prev_task];
    task_t* new_task = &tasks[current_task];

    context_switch(&old_task->esp, new_task->esp);
}

// Context switch implemented in assembly
__asm__(
".global context_switch        \n"
"context_switch:               \n"
"    mov 8(%esp), %eax        \n" // old_sp pointer
"    mov 12(%esp), %edx       \n" // new_sp value
"    mov %esp, (%eax)         \n" // save esp to *old_sp
"    mov %edx, %esp           \n" // load new_sp into esp
"    ret                      \n"
);
EOF

echo "All interrupt, PIT, PIC, and scheduler files have been created in $BASE_DIR"
