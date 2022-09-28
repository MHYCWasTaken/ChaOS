[bits 16]

get_control:

    ;mov [BOOT_DRIVE], dl
    ;mov [SETUP_OFFSET], ax

	mov ah, 0x0e
    mov al, 'U'
    int 0x10

    jmp $

    jmp start_load_kernel

start_load_kernel:

	mov cx, 0x0002
	mov bx, 0x0000
	add ax, [BOOT_DRIVE]
	mov dx, ax
	mov ax, 0x02F0 ; 读240个扇区
	int 0x13
	jnc load_pm

	mov dx, 0x0000			; 如果失败				if faild...
	mov ax, 0x0000
	int 0x13				; 重置读取状态			reset read status

	jmp start_load_kernel	; 重新读一次			and read again

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
	call [KERNEL_OFFSET]
	jmp $

%include "boot/gdt.asm"
BOOT_DRIVE db 0
SETUP_OFFSET db 0x90000
KERNEL_OFFSET db 0