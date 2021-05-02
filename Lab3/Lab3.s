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
    .equ    wordlen, 32
    .equ    buf, 36
    .equ    buflen, 32
    .equ    res, buf + buflen
    .equ    reslen, buflen * 2 + 1
    .equ    framelen, res + reslen
work:
    mov     x16, framelen
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
    b       14f
0:
    str     x0, [x29, fd]
    add     x4, x29, res
    mov     x5, x4
    add     x6, x29, wordlen
    mov     x7, x6
    mov     w9, #10
    mov     w10, #0
    mov     w11, #0
1:
    ldr     x0, [x29, fd]
    add     x1, x29, buf
    mov     x2, buflen
    mov     x8, #63
    svc     #0
    mov     w12, #0
    cmp     x0, #0
    beq     12f
    bgt     2f
    str     x0, [sp, #-8]!
    ldr     x0, [x29, fd]
    mov     x8, #57
    svc     #0
    ldr     x0, [sp], #8
    bl      writeerr
    mov     x0, #1
    b       14f
2:
    add     x1, x29, buf
3:
    ldrb    w13, [x1], #1
    add     w12, w12, #1
    cmp     w13, ' '
    beq     4f
    cmp     x4, x5
    beq     7f
    cbnz    w10, 7f
    b       5f
4:
    cmp     w0, w12
    beq     11f
    cbz     w10, 3b
5:
    mov     w14, ' '
    strb    w14, [x4], #1
    mov     x6, x7
    cbnz    w10, 9f
    b       7f
6:
    ldrb    w13, [x1], #1
    add     w12, w12, #1
    cmp     w13, ' '
    beq     5b
7:
    strb    w13, [x4], #1
    add     w10, w10, #1
    cmp     w0, w12
    bne     6b
8:
    cmp     w12, buflen
    blt     5b
    b       11f
9:
    udiv    w15, w10, w9
    msub    w14, w9, w15, w10
    add     w14, w14, '0'
    strb    w14, [x6], #1
    mov     w10, w15
    cbnz    w10, 9b
10:
    ldrb    w14, [x6, #-1]!
    strb    w14, [x4], #1
    cmp     x6, x7
    bne     10b
    cmp     w0, w12
    bne     3b
11:
    mov     x0, #1
    add     x1, x29, res
    add     x1, x1, x11
    sub     x2, x4, x1
    mov     x8, #64
    svc     #0
    add     x11, x2, x11
    b       1b
12:
    cbnz    w10, 5b
13:
    mov     w14, '\n'
    strb    w14, [x1]
    mov     x0, #1
    mov     x2, #1
    mov     x8, #64
    svc     #0
    ldr     x0, [x29, fd]
    mov     x8, #57
    svc     #0
    mov     x0, #0
14:
    ldp     x29, x30, [sp]
    mov     x16, framelen
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
