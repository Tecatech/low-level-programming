    .arch   armv8-a
    
    .data
errmsg1:
    .string "Usage: "
    .equ    errlen1, . - errmsg1
errmsg2:
    .string " filename\n"
    .equ    errlen2, . - errmsg2
    
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    ldr     x0, [sp]
    cmp     x0, #2
    beq     2f
    mov     x0, #2
    adr     x1, errmsg1
    mov     x2, errlen1
    mov     x8, #64
    svc     #0
    mov     x0, #2
    ldr     x1, [sp, #8]
    mov     x2, #0
0:
    ldrb    w3, [x1, x2]
    cbz     w3, 1f
    add     x2, x2, #1
    b       0b
1:
    mov     x8, #64
    svc     #0
    mov     x0, #2
    adr     x1, errmsg2
    mov     x2, errlen2
    mov     x8, #64
    svc     #0
    mov     x0, #1
    b       3f
2:
    ldr     x0, [sp, #16]
    bl      work
3:
    mov     x8, #93
    svc     #0
    .size   _start, . - _start
    
    .type   work, %function
    .text
    .align  2
    .equ    filename, 16
    .equ    fd, 24
    .equ    buffer, 32
    .equ    result, 1056
    .equ    numlen, 2080
work:
    mov     x16, #2084
    sub     sp, sp, x16
    stp     x29, x30, [sp]
    mov     x29, sp
    str     x0, [x29, filename]
    mov     x1, x0
    mov     x0, #-100
    mov     x2, #0
    mov     x8, #56
    svc     #0
    cmp     x0, #0
    bge     0f
    bl      writeerr
    b       10f
0:
    str     x0, [x29, fd]
    mov     w3, #10
1:
    ldr     x0, [x29, fd]
    add     x1, x29, buffer
    mov     x2, #1024
    mov     x8, #63
    svc     #0
    cmp     x0, #0
    beq     9f
    bgt     2f
    str     x0, [sp, #-8]!
    ldr     x0, [x29, fd]
    mov     x8, #57
    svc     #0
    ldr     x0, [sp], #8
    bl      writeerr
    mov     x0, #1
    b       10f
2:
    add     x1, x29, buffer
    strb    wzr, [x1, x0]
    add     x4, x29, result
    mov     x5, x4
    add     x6, x29, numlen
    mov     x7, x6
3:
    ldrb    w0, [x1], #1
    cbz     w0, 8f
    cmp     w0, ' '
    beq     3b
    mov     w9, #0
    cmp     x4, x5
    beq     5f
4:
    mov     w10, ' '
    strb    w10, [x4], #1
    mov     x6, x7
    cbnz    w9, 6f
5:
    strb    w0, [x4], #1
    add     w9, w9, #1
    ldrb    w0, [x1], #1
    cbz     w0, 4b
    cmp     w0, ' '
    bne     5b
    b       4b
6:
    udiv    w11, w9, w3
    msub    w10, w3, w11, w9
    add     w10, w10, '0'
    strb    w10, [x6], #1
    mov     w9, w11
    cbnz    w9, 6b
7:
    ldrb    w10, [x6, #-1]!
    strb    w10, [x4], #1
    cmp     x6, x7
    bne     7b
    cbnz    w0, 3b
8:
    mov     w0, '\n'
    strb    w0, [x4], #1
    mov     x0, #1
    add     x1, x29, result
    sub     x2, x4, x1
    mov     x8, #64
    svc     #0
    b       1b
9:
    ldr     x0, [x29, fd]
    mov     x8, #57
    svc     #0
    mov     x0, #0
10:
    ldp     x29, x30, [sp]
    mov     x16, #2080
    add     sp, sp, x16
    ret
    .size   work, . - work
    
    .type   writeerr, %function
    .data
nofile:
    .string "No such file or directory!\n"
    .equ    nofilelen, . - nofile
nopermission:
    .string "Permission denied!\n"
    .equ    nopermissionlen, . - nopermission
unknown:
    .string "Unknown error!\n"
    .equ    unknownlen, . - unknown
    
    .text
    .align  2
writeerr:
    cmp     x0, #-2
    bne     0f
    adr     x1, nofile
    mov     x2, nofilelen
    b       2f
0:
    cmp     x0, #-13
    bne     1f
    adr     x1, nopermission
    mov     x2, nopermissionlen
    b       2f
1:
    adr     x1, unknown
    mov     x2, unknownlen
2:
    mov     x0, #2
    mov     x8, #64
    svc     #0
    ret
    .size   writeerr, . - writeerr
