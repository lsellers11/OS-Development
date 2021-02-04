[org 0x7c00]
[bits 16]

section .text
	global main

main:

;; Clear Segment Registers
cli
jmp 0x0000:ZeroSeg
ZeroSeg:
	xor ax, ax
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, main
	cld

sti

;; Reset Disk
push ax
xor ax, ax
int 0x13
pop ax

mov si, str_boot
call printf

call enable A20

mov al,  1
mov cl, 2
call ReadDisk

jmp sector 2

%include “./print.asm”
%include “./read_disk.asm”
%include “./printhex.asm”
%include “./testA20.asm”
%include “./enableA20.asm”

str_boot: db “Boot test complete.”, 0x0a, 0x0d, 0

str_err: db “Error Loading Disk”, 0x0a, 0x0d, 0

str_test: db “This is the second sector.”, 0x0a, 0x0d, 0

;; Boot Loader
times 510 - ($-$$) db 0
dw 0xaa55

sector2:

mov si, str_test
call printf

call checklm

cli

;;Paging

mov edi, 0x1000
mov cr3, edi
xor eax, eax
mov ecx, 4096
rep stosd
mov edi, 0x1000

;Page Map Lvl 4 Table > 0x1000
;Page Directory Pointer Table > 0x2000
;Page Directory Table > 0x3000
;Page Table > 0x4000

mov dword [edi], 0x2003 ;First 2 bits defined already
add edi, 0x1000
mov dword [edi], 0x3003
add edi, 0x1000
mov dword [edi], 0x4003
add edi 0x1000

mov dword ebx, 3
mov ecx, 512

.setEntry:
	mov dword [edi], ebx
	add ebx, 0x1000
	add edi, 8
	loop .setEntry

mov eax, cr4
or eax 1 << 5
mov cr4, eax

mov ecx, 0xc0000080
rdmsr
or eax, 1 << 8
wrmsr

;; Enable Protected Mode
mov eax, cr0
or eax, 1 << 31
or eax, 1 << 0
mov cr0, eax

lgdt [GDT.Pointer]
jmp GDT.Code:LongMode

%include ”./checklm.asm”
%include “./gdt.asm”

[bits 64]
LongMode:

VID_MEM equ 0xb8000
mov rax, 0x0f54
mov [VID_MEM], rax
