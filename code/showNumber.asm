        ;在屏幕上显示65535
start:
        ;mov ax, 65535
        ;mov bl, 10
        ;div bl;AX => 商(6553) DX => 余数(5)
        mov ax, 65535
        xor dx, dx
        mov bx, 10
        div bx

        add dl, 0x30 ; 将数字转换为对应的数字字符

        mov cx,0
        mov ds, cx   ; 将cx中的段地址，存入数据段寄存器ds
        ;主引导扇区开始地址为0x7c00
        mov [0x7c00+buffer],dl ;这里段地址寄存器ds为0x000，因为在主引导扇区内，所以段内偏移地址为0x7c00+buffer
        ;逻辑地址为：0x000:0x7c00+buffer
        xor dx,dx    ; 清零
        div bx
        add dl,0x30
        mov [0x7c00+buffer+1],dl ; 运行时的偏移地址需要加1访问下一个地址

        xor dx,dx    ; 清零
        div bx
        add dl,0x30
        mov [0x7c00+buffer+2],dl ; 运行时的偏移地址需要加1访问下一个地址


        xor dx,dx    ; 清零
        div bx
        add dl,0x30
        mov [0x7c00+buffer+3],dl ; 运行时的偏移地址需要加1访问下一个地址


        xor dx,dx    ; 清零
        div bx
        add dl,0x30
        mov [0x7c00+buffer+4],dl ; 运行时的偏移地址需要加1访问下一个地址

        ;两个段之间进行操作
        ;mov al,[0x7c00+buffer+4]

        ;mov cx, 0xb800 ;使用通用寄存器中转，然后存在段寄存器地址中
        ;mov ds, cx

        ;mov [0x00], al ; 将寄存器al的值，放到段内偏移地址0x00处
        ;mov byte [0x01], 0x2f ; 写入颜色属性  由于立即数可大可小，内存地址也看不出大小，所以要指明

        ;mov cx, 0      ; 切到段地址0处
        ;mov ds, cx     ; 切到段地址0处

        ;mov al, [0x7c00+buffer+3]  ; 将段内偏移地址的值放到通用寄存器al中

        ;mov cx, 0xb800 ;使用通用寄存器中转，然后存在段寄存器地址中
        ;mov ds, cx

        ;mov [0x02], al ; 将寄存器al的值，放到段内偏移地址0x00处
        ;mov byte [0x03], 0x2f ; 写入颜色属性  由于立即数可大可小，内存地址也看不出大小，所以要指明

        ; 两个段之间进行操作，切来切去，确实麻烦

        ; 全新版本，使用es段地址寄存器

        mov cx, 0xb800
        mov es, cx

        mov al, [0x7c00+buffer+4]
        mov [es:0x00], al       ;[es: => 段超越前缀] 使用es段寄存器，来填充显存
        mov byte [es:0x01], 0x2f

        mov al, [0x7c00+buffer+3]
        mov [es:0x02], al       ; 使用es段寄存器，来填充显存
        mov byte [es:0x03], 0x2f

        mov al, [0x7c00+buffer+2]
        mov [es:0x04], al       ; 使用es段寄存器，来填充显存
        mov byte [es:0x05], 0x2f

        mov al, [0x7c00+buffer+1]
        mov [es:0x06], al       ; 使用es段寄存器，来填充显存
        mov byte [es:0x07], 0x2f

        mov al, [0x7c00+buffer]
        mov [es:0x08], al       ; 使用es段寄存器，来填充显存
        mov byte [es:0x09], 0x2f

again:
        jmp again

buffer        db 0,0,0,0,0 ;使用位指令db开辟 5个字节空间 每个数字都是一个字节


current:
        times 510 - (current - start) db 0
        db 0x55, 0xAA
