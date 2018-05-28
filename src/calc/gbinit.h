// Header File
// Created 5/3/2005; 1:57:22 PM

#ifndef __GB_INIT__
#define __GB_INIT__

#ifdef __IN_DLL__
void select_rom(char *name);
char init_rom(char *name);
short esc_menu();
void options_menu();
#else
#define select_rom _DLL_call(void, (char *), DLL_SELECT_ROM)
#define init_rom _DLL_call(char, (char *), DLL_INIT_ROM)
#define esc_menu _DLL_call(short, (), DLL_ESC_MENU)
#endif

#endif
