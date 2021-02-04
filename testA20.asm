;;Tests whether A20 Line is on (Real vs protected)
; Sets ax to 1 if enabled, 0 if not enabled

testA20:

  pusha
  
  mov ax, [0x7dfe]; Test segmenting of boot loader magic number
  mov dx, ax
  
  push bx
  mov bx, 0xffff ; Choose segment
  mov es, bx
  pop bx
  
  mov bx, 0x7e0e ; Offset
  mov dx, [es:bx]
  
  cmp ax, dx
  je exit
  mov ax, 1
  ret
  
  .exit:
    popa
    xor ax, ax
    ret
