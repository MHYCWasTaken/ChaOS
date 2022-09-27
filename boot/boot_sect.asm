[bits 16]

boot:
    mov ax, 0x7c00
    mov dx, ax

    mov bp, 0x9F00
    mov sp, bp
    jmp start_load_kernel

start_load_kernel:

    mov ax, 0x0200+1 ; ah固定,al为要读的扇区数目(读几个)
    mov cx, 0x0002 ; 前两位磁道号,后两位从第几个扇区开始读
    mov bx, 0x1000 ; es:bs(es内容为基偏移bs内容)指向要往内存哪里放
    int 0x13
    jnc load_pm

    mov bx, 0x0000
    mov ax, 0x0000
    int 0x13

    jmp start_load_kernel

load_pm:
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
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

    jmp begin_pm

begin_pm:
    call 0x1000
    jmp $

%include "boot/gdt.asm"

times 510-($-$$) db 0
dw 0xaa55