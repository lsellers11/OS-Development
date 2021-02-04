;; Enables and verifies A20 Line.

enableA20:
  pusha
  mov ax, 0x2401
  int 0x15
  
  call testA20
  cmp ax, 1
  je .enabled
  ret
  
  .enabled:
    popa
    ret
