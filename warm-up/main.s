    .arch   armv8-a
    
    .data
    .align  3
msg:
    .ascii  "Good job!\n"
    
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    mov     x0, #1
    mov     x8, #64
    ldr     x1, = msg
    mov     x2, #10
    svc     #0
_exit:
    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size   _start, . - _start
