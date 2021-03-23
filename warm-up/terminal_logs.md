```
burgos1337@LAPTOP-4VD7KB18:/mnt/c/Users/Lenovo/Desktop$ make -f Makefile
aarch64-linux-gnu-as -g main.s -o main.o
aarch64-linux-gnu-ld -g -static main.o -o main
burgos1337@LAPTOP-4VD7KB18:/mnt/c/Users/Lenovo/Desktop$ qemu-aarch64 -g 1234 ./main
Good job!
burgos1337@LAPTOP-4VD7KB18:/mnt/c/Users/Lenovo/Desktop$

burgos1337@LAPTOP-4VD7KB18:/mnt/c/Users/Lenovo/Desktop$ gdb-multiarch ./main
Reading symbols from ./main...
(gdb) target remote :1234
Remote debugging using :1234
_start () at main.s:5
5           mov x8, #64
(gdb) layout regs
┌──Register group: general──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│x0             0x41                65                         x1             0x410138            4260152                    x2             0xa                 10                          │
│x3             0x0                 0                          x4             0x0                 0                          x5             0x0                 0                           │
│x6             0x0                 0                          x7             0x0                 0                          x8             0x5d                93                          │
│x9             0x0                 0                          x10            0x0                 0                          x11            0x0                 0                           │
│x12            0x0                 0                          x13            0x0                 0                          x14            0x0                 0                           │
│x15            0x0                 0                          x16            0x0                 0                          x17            0x0                 0                           │
│x18            0x0                 0                          x19            0x0                 0                          x20            0x0                 0                           │
│x21            0x0                 0                          x22            0x0                 0                          x23            0x0                 0                           │
│x24            0x0                 0                          x25            0x0                 0                          x26            0x0                 0                           │
│x27            0x0                 0                          x28            0x0                 0                          x29            0x0                 0                           │
│x30            0x0                 0                          sp             0x4000800530        0x4000800530               pc             0x40012c            0x40012c <_start+28>        │
│cpsr           0x40000000          1073741824                 fpsr           0x0                 0                          fpcr           0x0                 0                           │
│MVFR6_EL1_RESERVED 0x0             0                          ESR_EL2        0x0                 0                          TPIDR_EL3      0x0                 0                           │┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐│   0x400110 <_start>       mov     x8, #0x40                       // #64                                                                                                                  │
│   0x400114 <_start+4>     mov     x0, #0x1                        // #1                                                                                                                   │
│   0x400118 <_start+8>     ldr     x1, 0x400130 <_start+32>                                                                                                                                │
│   0x40011c <_start+12>    mov     x2, #0xa                        // #10                                                                                                                  │
│   0x400120 <_start+16>    svc     #0x0                                                                                                                                                    │
│   0x400124 <_start+20>    mov     x8, #0x5d                       // #93                                                                                                                  │
│   0x400128 <_start+24>    mov     x0, #0x41                       // #65                                                                                                                  │
│  >0x40012c <_start+28>    svc     #0x0                                                                                                                                                    │
│   0x400130 <_start+32>    .inst   0x00410138 ; undefined                                                                                                                                  │
│   0x400134 <_start+36>    .inst   0x00000000 ; undefined                                                                                                                                  │
│   0x400138                    .inst       0x646f6f47 ; undefined                                                                                                                          │
│   0x40013c                    .inst       0x626f6a20 ; undefined                                                                                                                          │
│   0x400140                    .inst       0x00000a21 ; undefined                                                                                                                          │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
remote Thread 1.2915 In: _start                                                                                                                                           L13   PC: 0x40012c
(gdb) step
```