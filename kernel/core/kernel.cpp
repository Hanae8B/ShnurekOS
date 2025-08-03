// kernel/core/kernel.cpp

extern "C" void gdt_init();
extern "C" void idt_init();
extern "C" void pic_remap(int offset1, int offset2);
extern "C" void pit_init();

extern "C" void isr_handler_c();
extern "C" void irq_handler_c();

extern "C" void kernel_main() {
    gdt_init();
    idt_init();
    pic_remap(0x20, 0x28);   // Remap PIC interrupts to 0x20-0x2F
    pit_init();

    // Enable interrupts
    asm volatile ("sti");

    while(1) {
        asm volatile ("hlt");
    }
}

// Dummy C handlers for interrupts (implement as needed)

extern "C" void isr_handler_c() {
    // For now, just hang on CPU exceptions
    while(1) { asm volatile ("hlt"); }
}

extern "C" void irq_handler_c() {
    // Send End Of Interrupt to PIC
    asm volatile ("outb %0, %1" : : "a"(0x20), "Nd"(0x20));

    // For now, just return
}
