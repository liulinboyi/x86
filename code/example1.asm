mov ax,0x30 ;将立即数传送到ax寄存器
mov dx,0xc0
add ax,dx
; 位指令db，只对编译器有效的指令，一个位指令db 只能向内存添加一个字节的数据
times 502 db 0

db 0x55
db 0xAA
