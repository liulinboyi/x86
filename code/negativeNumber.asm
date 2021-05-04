top:

start:
      mov ax,-6002 ;ax16 位寄存器
      ;由于除数是bx，是16位寄存器，所以被除数需要为32位
      ;即ax需要扩展为32位
      ;有很多指令可以将短的有符号数，扩展到长的有符号数
      cwd ;将ax中的有符号数扩展到dx，扩展之后被除数的高16位在dx，低16位在ax
      mov bx,-10

      idiv bx
      ;商在al中0x04余数在ah中0x40 -> 只能以无符号数来解释
      ;使用有符号数解释会出错，解释不通
bottom:
      times 510 - (bottom - top) db 0
      db 0x55, 0xAA

