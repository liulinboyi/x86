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

      ;分解各个数位
      xor cx,cx ;设置栈段基地址
      mov ss,cx
      mov sp,cx

      mov bx,10
      xor cx,cx ;记录实际分解了几个数位
decompo:
      inc cx
      xor dx,dx
      div bx
      add dl,0x30
      push dx ;16位8086处理器中，压栈出栈必须为一个字，不能为一个字节
      cmp ax,0 ;如果商为0，则结束
      jne decompo

      ;以下显示各个数位
shownum:
      pop dx
      mov [es:di],dl
      inc di
      mov byte [es:di],0x07
      inc di
      loop shownum

      jmp $

e: ;结束标号
       times 510 - (e - s) db 0
       db 0x55, 0xaa

