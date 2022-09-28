[bits 32]

[bits 16]
start_load_kernel:

	
	mov cx, 0x0002 ; 前两位磁道号,后两位从第几个扇区开始读
	mov ax, 0x0000
	mov bx, ax ; es:bx(es内容为基偏移bx内容)指向要往内存哪里放
	mov ax, 0x1000
	add ax, [BOOT_DRIVE]
	mov dx, ax ; 磁道号，盘号
	mov ax, 0x0200+5 ; ah固定,al为要读的扇区数目(读几个)
	int 0x13
	jc LOAD_FAIL
	jmp load_pm

LOAD_FAIL:
	mov al, 'E'
	mov ah, 0x0e
	int 0x10
	jmp $

	mov ax, 0x0200
	mov dx, ax
	int 0x13

	jmp start_load_kernel

load_pm:

	mov al, 'S'
	mov ah, 0x0e
	int 0x10
	jmp $

	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	mov al, 'C'
	mov ah, 0x0e
	int 0x10

	jmp init_pm

[bits 32]
init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x9FF00
	mov esp, ebp

	mov al, 'D'
	mov ah, 0x0e
	int 0x10

	jmp begin_pm

begin_pm:
	call 0x9000
	jmp $

%include "boot/gdt.asm"