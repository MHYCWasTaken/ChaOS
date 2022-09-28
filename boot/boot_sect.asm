[bits 16]

boot:
	mov [BOOT_DRIVE], dl	; 记录启动的驱动设备	 remember boot device

	mov ax, 0x7c00
	mov ds, ax         		; 设置偏移: 0x7c00		set offset : 0x7c00 
	mov bp, 0x9FF00
	mov sp, bp				; 初始化栈				init stack

start_load_setup:			; 加载setup内容			load 'setup'
	mov cx, 0x0002			; 0磁道, 2扇区			cylinder no.0, sector no.2
	mov bx, KERNEL_OFFSET	; 读后存放地址			 where to store in memory
	mov dx, 0x0000			; 0磁头					head no.0
	add dx, [BOOT_DRIVE]	; dl设置为启动设备		set 'dl' to boot device
	mov ax, 0x0201			; al为要读1个扇区		al: how many secs to read

	int 0x13				; 读取, 使用中断		read with BIOS interrpts
	jnc load_setup_suc		; 如果读取成功			jump is read successful

	mov dx, 0x0000			; 如果失败				if faild...
	mov ax, 0x0000
	int 0x13				; 重置读取状态			reset read status

	jmp start_load_setup	; 重新读一次			and read again

load_setup_suc:

	; 将两个参数放进寄存器传给setup		put these in register to pass to 'setup'
	;mov dl, [BOOT_DRIVE]
	;mov ax, [KERNEL_OFFSET]

	;jmp $
	call [KERNEL_OFFSET] 	; 运行KERNEL_OFFSET处	run code at KERNEL_OFFSET

	jmp $

%include "boot/gdt.asm"
BOOT_DRIVE db 0
KERNEL_OFFSET db 0x90000

times 510 - ($-$$) db 0
dw 0xaa55