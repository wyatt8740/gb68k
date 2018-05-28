// Header File
// Created 7/30/2004; 1:37:27 AM

#ifndef __GBSETUP__
#define __GBSETUP__

char init();
void cleanup();
void pause();
short get_key();

extern volatile unsigned short frames;
extern volatile unsigned short current_fps;

enum ERROR_TYPE {
	ERROR_NONE,
	ERROR_OUT_OF_MEM,
	ERROR_COMPRESS,
	ERROR_FILE_SYS,
	ERROR_MISSING_FILE,
	ERROR_DLL,
	ERROR_UNSUPPORTED,
	ERROR_ARCHIVE,
};

#define ARROWS_ROW 0xfffe
#define LEFT_KEY 2
#define RIGHT_KEY 8
#define UP_KEY 1
#define DOWN_KEY 4
#define SEL_KEY 16
#define SHIFT_KEY 32
#define DMND_KEY 64
#define ESC_ROW 0xffbf
#define ESC_KEY 1
#define APPS_ROW 0xffdf
#define APPS_KEY 1
#define BSPACE_ROW 0xfffb
#define CLEAR_ROW 0xfffd
#define BSPACE_KEY 64
#define CLEAR_KEY 64

#endif
