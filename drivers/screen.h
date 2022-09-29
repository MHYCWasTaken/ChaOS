#ifndef _SCREEN_H_
#define _SCREEN_H_

#include "../lib/types.h"

#define VGA_CONTROL 0x3d4
#define VGA_RETURN 0x3d5

#define VGA 0xb8000
#define MAX_X 25
#define MAX_Y 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

void clear_screen();
void kprint_at(char *message, int x, int y/*, enum color character, enum color background*/);
void kprint_at_cuosor(char *message/*, enum color character, enum color background*/);

#endif