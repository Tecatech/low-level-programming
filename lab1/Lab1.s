    .arch   armv8-a              // архитектура
    
    .data                        // сегмент глобальных данных программы
    .align  3                    // выравнивание по границе двойного слова
res:
    .skip   8                    // резервирование ячейки памяти размера двойного слова под результат
a:
    .long   50
d:
    .long   175
e:
    .long   100
c:
    .short  33
b:
    .byte   25
    
    .text                        // сегмент исполняемого кода программы
    .align  2                    // выравнивание по границе слова
    .global _start               // метка точки входа программы
    .type   _start, %function    // определение метки как функции
_start:
    adr     x0, a                // загрузка адреса метки (переменной) a в регистр x0
    ldr     w1, [x0]             // загрузка данных по адресу метки (переменной) a в регистр w1 и заполнение нулевыми битами старшей части регистра x1
    adr     x0, b                // загрузка адреса метки (переменной) b в регистр x0
    ldrb    w2, [x0]             // загрузка данных по адресу метки (переменной) b в регистр w2 и заполнение нулевыми битами старшей части регистра w2
    adr     x0, c                // загрузка адреса метки (переменной) c в регистр x0
    ldrh    w3, [x0]             // загрузка данных по адресу метки (переменной) c в регистр w3 и заполнение нулевыми битами старшей части регистра w3
    adr     x0, d                // загрузка адреса метки (переменной) d в регистр x0
    ldr     w4, [x0]             // загрузка данных по адресу метки (переменной) d в регистр w4 и заполнение нулевыми битами старшей части регистра x4
    adr     x0, e                // загрузка адреса метки (переменной) e в регистр x0
    ldr     w5, [x0]             // загрузка данных по адресу метки (переменной) e в регистр w5 и заполнение нулевыми битами старшей части регистра x5
    add     x6, x2, x4
    subs    w7, w5, w1
    bls     _exception           // условный переход к метке обработки некорректного результата беззнаковой операции
    udiv    x8, x6, x7
    umull   x9, w1, w4
    mul     w10, w2, w3
    adds    x10, x1, x10
    beq     _exception           // условный переход к метке обработки некорректного результата беззнаковой операции
    udiv    x11, x9, x10
    add     x12, x8, x11
    adr     x0, res              // загрузка адреса метки (переменной) res в регистр x0
    str     x12, [x0]            // сохранение результата вычисления в памяти по адресу из регистра x0
    mov     x0, #0
    b       _exit
_exception:
    mov     x0, #1
_exit:
    mov     x8, #93
    svc     #0
    .size   _start, . - _start   // определение размера символа _start