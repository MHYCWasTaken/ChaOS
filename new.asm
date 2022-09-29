    [org 0x7C00]
    
    xor  ax, ax
    mov  ds, ax
    mov  ss, ax
    mov  sp, 0x8000    
    
    jmp  switch_to_pm

GDT_start:
  GDT_null:
    dd 0x0
    dd 0x0
  GDT_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0b10011010
    db 0b11001111
    db 0x0
  GDT_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0b10010010
    db 0b11001111
    db 0x0
GDT_end:
    
GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start
    
CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

switch_to_pm:
    cli
    lgdt [GDT_descriptor]
    mov  eax, cr0
    or   eax, 1           ; Set PE=1
    mov  cr0, eax
    mov  ax, DATA_SEG
    mov  ds, ax
    jmp  CODE_SEG:init_pm
    
[bits 32]
init_pm:
    mov  ax, 0x0F41       ; WhiteOnBlack capital A
    mov  [0x000B8000], ax ; At(1,1);

    hlt
    jmp  $-1

times 510-($-$$) db 0
dw 0xAA55