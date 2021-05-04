        ;计算除法
        ;378除以37的结果
start:
        mov ax, 378
        mov bl, 37
        div bl;AL => 商 AH => 余数

current:
        times 510 - (current - start) db 0
        db 0x55, 0xAA
