SECTION data1 align=16 vstart=0
mydata dw 0xface

section data2 align=16 vstart=0
string db 'hello'

section code align=16 vstart=0
        mov bx,mydata
        mov si,string
