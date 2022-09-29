#include "../drivers/ports.h"
#include "../drivers/screen.h"
#include "../lib/types.h"

const int BLACK_ON_WHITE = 0x0f;

void kernel_main() {
    
    int position;
    port_byte_out(0x3d4, 14);
    position = port_byte_in(0x3d5) << 8;
    port_byte_out(0x3d4, 15);
    position += port_byte_in(0x3d5);
    //int offset_from_vga = position * 2;
    
    char *vga = (char*)0xb8000;
    
    vga[position * 2] = 'X'; 
    vga[position * 2 + 1] = 0x0f;
    vga[10] = 'Q';
    vga[11] = BLACK_ON_WHITE;
    //kprint_at_cuosor("Hello, World");
    
}
