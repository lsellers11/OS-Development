;;Prints out contents of si register (Needs to be filled before calling)

printf:

  pusha
  
  .Loop:
    mov al, [si]
    cmp al, 0
    jne .print
    popa
    ret
    
   .print:
      mov ah, 0x0e
      int 0x10
      add si, 1
      jmp .Loop
