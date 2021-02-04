printhex:

  pusha
  mov cx, 12
  mov ax, 0
  
  .hexloop:
  
    mov bx, dx
    shr bx, cl
    and bx, 000f ;Bit masking
    mov bx, [HEX_TABLE + bx]
    
    ;Swap Register Contents
    push ax
    mov ax, bx
    pop bx
    
    mov [HEX_PATTERN_ + 2 + bx], al
    
    ;Swap Back
    push ax
    mov ax, bx
    pop bx
    
    cmp cx, 0
    je .hexloopbreak
    
    sub cx, 4
    add al, 1
    
    jmp .hexloop
    
  .hexloopbreak:
    mov si, HEX_PATTERN_
    call printf
    popa 
    ret
    
HEX_PATTERN_: db '0x****', 0x0a, 0x0d, 0
HEX_TABLE_: db '0123456789abcdef'
