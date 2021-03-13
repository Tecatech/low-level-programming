.global _start
.section .text

_start:
    # ssize_t write(unsigned int fd, const void *buf, size_t count);
    mov x8, #64
    mov x0, #1
    ldr x1, = message
    mov x2, 10
    svc 0
    
    # void exit(int status);
    mov x8, #0x5d
    mov x0, #0x41
    svc 0

.section .data
message:
    .ascii "Good job!\n"
