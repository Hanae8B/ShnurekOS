.global isr0
.global isr1

isr0:
    cli
    hlt
    jmp $

isr1:
    cli
    hlt
    jmp $
