[org 0x7c00]
xor ax, ax
mov ds, ax
cli
gdt: lgdt [gdt+1]
db 0,0xfa
jmp b
dw 0xFFFF            ; Limit
.zero: dw 0x0000            ; Base (low 16 bits)
db 0x00                ; Base (mid 8 bits)
.a: db 10011010b        ; Access
db 11001111b        ; Granularity
db 0x00                ; Base (high 8 bits)
b: inc ax
lmsw ax
jmp 0x08:wow
bits 32
wow: and byte [gdt.a], ~(1<<3)
mov al, 0x08
mov ds, ax
mov es, ax
mov ss, ax
jmp $


times 510-($-$$) db 0
dw 0xaa55
