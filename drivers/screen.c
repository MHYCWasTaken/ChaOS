#include "screen.h"
#include "ports.h"
#include "../lib/types.h"

int get_cursor_position();
void set_cursor_position(int position);
void print_char(char c, int x, int y/*, enum color character, enum color background*/);
int get_position(int x, int y);
int get_y(int position);
int get_x(int position);
void clear_screen();
void kprint_at(char *message, int x, int y/*, enum color character, enum color background*/);
void kprint_at_cuosor(char *message/*, enum color character, enum color background*/);
int get_position();
int get_x();
int get_y();
char get_vga_color(/*enum color character, enum color background*/);

void clear_screen() {
    char *screen = (char*)VGA;
    for (int i = 0; i < 2000; ++i) {
        screen[i*2] = ' ';
        screen[i*2+1] = WHITE_ON_BLACK;
    }
    set_cursor_position(get_position(0, 0));
}

void kprint_at(char *message, int x, int y/*, enum color character, enum color background*/) {
    int i = 0;
    while (message[i] != '\0') {
        print_char(message[i], x, y/*, character, background*/);
        ++ i;
        ++ x;
        if(x >= MAX_X) {
            x = 0;
            ++ y;
        }
    }
}

void kprint_at_cuosor(char *message/*, enum color character, enum color background*/) {

    int x = get_x(get_cursor_position());
    int y = get_y(get_cursor_position());

    kprint_at(message, x, y/*, character, background*/);
}

void print_char(char c, int x, int y/*, enum color character, enum color background*/) {
    char *screen = (char*) VGA;

    if (x >= MAX_X) {
        screen[get_position(MAX_X-1, y)-2] = '>';
        /*character = RED;
        background = WHITE;*/
        screen[get_position(MAX_X-1, y)-1] = get_vga_color(/*character, background*/);
        return;
    }
    if (y >= MAX_Y) {
        // TODO : scrool the screen
        //scroll_by(1);
        return;
    }

    screen[get_position(x, y)] = c;
    screen[get_position(x, y) + 1] = WHITE_ON_BLACK;

    return;
}

int get_cursor_position() {
    int ret;
    port_byte_out(VGA_CONTROL, 14);
    ret = port_byte_in(VGA_RETURN) << 8;
    port_byte_out(VGA_CONTROL, 15);
    ret += port_byte_in(VGA_RETURN);
    return ret * 2;
}

void set_cursor_position(int position) {
    position /= 2;
    port_byte_out(VGA_CONTROL, 14);
    port_byte_out(VGA_RETURN, (unsigned char)(position >> 8));
    port_byte_out(VGA_CONTROL, 15);
    port_byte_out(VGA_RETURN, (unsigned char)(position & 0xff));
}

int get_position(int x, int y) { return 2 * (y * MAX_X + x); }
int get_y(int position) { return position / (2 * MAX_X); }
int get_x(int position) { return (position - (get_y(position) * 2 * MAX_X)) / 2; }
char get_vga_color(/*enum color character, enum color background*/) {return 0x0f;/*background << 8 + character;*/ }