;从1加到100
s: ;开始标号
      jmp start
message db '1+2+3+...+100=' ;字符串等同于db '1','+','2'...
;message代表这一行的汇编地址
; 传送准备阶段
; ds:si 原始数据串的段地址:偏移地址
; es:di 目标位置的段地址:偏移地址

start:
      mov ax,0x7c0 ;设置数据段的段基地址
      mov ds,ax

      mov ax,0xb800 ;设置附加段的段基地址到显示缓冲区
      mov es,ax

      ;显示字符
      mov si,message
      mov di,0
      mov cx,start - message ;循环次数
showmsg:
      mov al,[si] ;将si对应的数据(字符)传送到al寄存器
      mov [es:di],al ;将al寄存器的值，传送给显存缓冲区
      inc di ;di偏移地址+1向后面移动一个字节
      mov byte [es:di],0x07 ;为字符设置显示属性颜色等数据
      inc di ;di偏移地址+1向后面移动一个字节，为下一个字节空间放置字符做准备
      inc si ;si +1获取下一个字符
      loop showmsg

      ;计算1到100的和
      xor ax,ax ;ax用于存储累加结果，异或指令清零
      mov cx,1
summate:
      add ax,cx
      inc cx
      cmp cx,100 ;cx与100进行比较
      jle summate ;如果小于等于则跳转

      ;mov ax, number
      ;分解各个数位
      mov bx,number
      mov cx,5 ;循环次数
      mov si,10 ;除数

digit:
      xor dx,dx ;重置dx
      div si
      mov [bx], dl ;保留数位（余数）5050 => 0505
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

e: ;结束标号
       times 510 - (e - s) db 0
       db 0x55, 0xaa

