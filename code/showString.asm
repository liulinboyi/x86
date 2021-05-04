; 文本内容和显示指令分开
;专门定义一个存放字符串的数据区

; 标号 字符, 字符颜色
jmp start ; 跳过这些数据，到start标号处执行指令
mytext db 'L', 0x07, 'a', 0x07, 'b', 0x07, 'e', 0x07, 'l', 0x07, ' ', 0x07, 'o', 0x07,\
          'f', 0x07, 'f', 0x07, 's', 0x07, 'e', 0x07, 't', 0x07, ':', 0x07
start:
      mov ax, 0x7c0 ;设置数据段寄存器内容 设置一个新的段逻辑地址起始为0x7c0:0000，为了简化后面程序的设计
      mov ds, ax

      mov ax, 0xb800 ;设置附加段寄存器内容
      mov es, ax

      ; 数据串传送指令
      ; movsb 按字节传送
      ; movsw 按字传送

      ; 传送准备阶段
      ; ds:si 原始数据串的段地址:偏移地址
      ; es:di 目标位置的段地址:偏移地址

      cld ; 方向指令清零指令，以指示是正方向的，无操作数指令，与之相反的是std置方向指令 ，与cld方向相反
      mov si, mytext
      mov di, 0
      ; flages 标志寄存器 16位寄存器，每一个位有一个特定含义的标志，比如位10是方向标志DF
      mov cx,(start-mytext)/2
      rep movsw ; 传送只能执行一次，如果需要反复执行，需要加上rep,，重复的次数由cx寄存器来指定
      ;传送后，movsw传送的是字，是16个二进制位，si与di都同时+2
      ;得到符号所代表的汇编地址
      mov ax, number


      ;分解各个数位
      mov bx,ax
      mov cx,5 ;循环次数
      mov si,10 ;除数

digit:
      xor dx,dx ;重置dx
      div si
      mov [bx], dl ;保留数位（余数）
      inc bx
      loop digit

      ;开始展示各个数位
      mov bx, number ;将存有各个数位的首地址存储到bx 基址寄存器
      mov si, 4; 0,0,0,0,0 -> 4 整体是0-4 想要从后往前
show:
     ;这里si被称为Index Register索引寄存器或者变址寄存器，另一个变址寄存器是di
      mov al, [bx+si];bx不变，通过si变化访问地址数据
      ;bx存放的是基地址，是标号number后面，第一个数位的偏移地址
      ;加上si的索引值之后，就可以访问其他数位的偏移地址
      add al, 0x30 ;行成字符编码
      mov ah, 0x04 ;字符颜色属性
      mov [es:di], ax
      add di, 2
      dec si ;递减，指向前一个数位
      ;jns条件转移指令 处理器执行它时，要参考标志寄存器的sf为，即标志位
      jns show ;jns条件转移指令 如果标志寄存器（flags）的标志位符号为不是1，
      ;则跳转到标号show处执行
      ;当si的值一值-1结果为-1时，标志寄存器（flags）的标志位置1
      ;此时不满足jns指令要求，会向下执行语句

      jmp $

number db 0,0,0,0,0

      ; $ 当前行的汇编地址；$$当前段的起始汇编地址
      times 510 - ($ - $$) db 0
      db 0x55, 0xAA


