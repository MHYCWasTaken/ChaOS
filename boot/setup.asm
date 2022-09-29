[org 0x9000]
[bits 16]

get_control:

    mov [BOOT_DRIVE], dl

	mov ah, 0x0e
    mov al, 'S'
    int 0x10

    jmp start_load_kernel

start_load_kernel:

	mov cx, 0x0003
	mov bx, KERNEL_OFFSET
	mov dx, 0x0000
	add dx, [BOOT_DRIVE]
	mov ax, 0x0205 ; 5个    读240个扇区(0x02F0)

	int 0x13
	jnc load_pm

	mov dx, 0x0000
	mov ax, 0x0000
	int 0x13

	jmp start_load_kernel

[bits 16]
load_pm:

	mov al, 'K'
	mov ah, 0x0e
	int 0x10

	xor ax, ax
	mov ds, ax

	cli
	lgdt [GDT_descriptor]
	
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp init_pm


init_pm:

	inc ax
	lmsw ax
	jmp 0x08:wow

[bits 32]
wow:

	mov ax, 0x08
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ds, ax

	mov  ax, 0x0F41       ; WhiteOnBlack capital A
    mov  [0x000B8000], ax ; At(1,1);
	hlt
	jmp $-1

	mov ebp, 0x9FF00
	mov esp, ebp

	mov al, '3'
	mov ah, 0x0e
	int 0x10

	jmp k_main_asm

[bits 32]
k_main_asm:
	call [KERNEL_OFFSET]
	jmp $

%include "boot/gdt.asm"

BOOT_DRIVE db 0
KERNEL_OFFSET db 0x0000


; |----------| 0x0
; | kernel   |
; |----------| 5 sectors -> 2560kb -> 0x5000
; |          |
; ·          ·
; |----------| 0x9000
; | setup    | gdt inside
; |----------|
;
; far away ...
;
; |----------| esp, ebp (for stacks) -> 0x9FF00