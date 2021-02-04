;;Check for Long Mode Support

check:
  pusha
  
  pushfd
  pop eax
  mov ecx, eax
  
  xor eax, 1 << 21
  
  push eax
  popfd
  
  pushfd
  pop eax
  
  xor eax, exc
  jz .done
  
  mov eax, 0x80000000
  cpuid
  cmp eax, 0x80000001
  jb .done
  
  mov eax, 0x80000001
  cpuid
  test edx, 1 << 29
  jz .done
  
  popa
  mov si, YES_LM
  call printf
  ret
  
  .done:
    popa
    mov si, NO_LM
    call printf
    jmp $
    
   NO_LM: db 'No Long Mode', 0x0a, 0x0d, 0
   
   YES_LM: db 'Long Mode Supported', 0x0a, 0x0d, 0
