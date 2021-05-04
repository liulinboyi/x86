        ;计算除法
        ;65535除以10的结果
start:
        ;mov ax, 65535
        ;mov bl, 10
        ;div bl;AX => 商(6553) DX => 余数(5)  有错误
        ;正解
        mov ax, 65535
        xor dx, dx
        mov bx, 10
        div bx


current:
        times 510 - (current - start) db 0
        db 0x55, 0xAA
