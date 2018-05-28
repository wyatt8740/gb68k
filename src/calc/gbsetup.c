// C Source File
// Created 7/30/2004; 1:28:56 AM

#include <tigcclib.h>
#include "gb68k.h"
#include "gbsetup.h"

//void *gray_buffer;

volatile unsigned short counter = 0;
volatile unsigned short frames = 0;
volatile unsigned short current_fps = 0;

extern short hw1_fps_counter(void);
asm("
hw1_fps_counter:
	move.w #0x2700, %sr
	addq.w #1, counter
	cmp.w #350, counter
	bne 0f
	move.w frames, current_fps
	clr.w counter
	clr.w frames
0:
	rte
");

extern short hw2_fps_counter(void);
asm("
hw2_fps_counter:
	move.w #0x2700, %sr
	move.w frames, current_fps
	clr.w frames
	rte
");

void EnableAutoInt3()
{
	pokeIO_bset(0x600015, 2);
}

void DisableAutoInt3()
{
	pokeIO_bclr(0x600015, 2);
}

char IsAutoInt3Enabled()
{
	return peekIO_bit(0x600015, 2);
}

char init()
{
	short i;
	
	for(i = 0 ; i < AUTO_INT_COUNT ; i++) {
		gb_data->old_int[i] = GetIntVec(AUTO_INT(i + FIRST_AUTO_INT));
		SetIntVec(AUTO_INT(i + FIRST_AUTO_INT), DUMMY_HANDLER);
	}
	gb_data->ints_redirected = TRUE;
	
	counter = 0;
	current_fps = 0;
	frames = 0;
	gb_data->int3_enabled = IsAutoInt3Enabled();
	if(gb_data->hw_version == 2 && !gb_data->vti) { //use more accurate AI3 on HW2
		SetIntVec(AUTO_INT_3, (void *)hw2_fps_counter);
		EnableAutoInt3();
	} else {
		SetIntVec(AUTO_INT_1, (void *)hw1_fps_counter);
	}

	if(!GrayOn()) return FALSE;
	memset(GrayGetPlane(LIGHT_PLANE), 0xff, LCD_SIZE);
	memset(GrayGetPlane(DARK_PLANE), 0xff, LCD_SIZE);
	
	if(gb_data->calc_type == 0) io_write_table[0] = P1_89;
	else io_write_table[0] = P1_92;

	return TRUE;
}

void cleanup()
{
	short i;
	
	memcpy(LCD_MEM, GrayGetPlane(DARK_PLANE), LCD_SIZE);
	GrayOff();
	
	if(gb_data->ints_redirected) {
		for(i = 0 ; i < AUTO_INT_COUNT ; i++) {
			SetIntVec(AUTO_INT(i + FIRST_AUTO_INT), gb_data->old_int[i]);
		}
		gb_data->ints_redirected = FALSE;
	}

	if(!gb_data->int3_enabled) DisableAutoInt3();
	PortRestore();
}

void pause()
{
	while(_rowread(ARROWS_ROW)&SEL_KEY);
	while(!(_rowread(ARROWS_ROW)&SEL_KEY));
	while(_rowread(ARROWS_ROW)&SEL_KEY);
}

short get_key()
{
	short k;
	while(_rowread(ARROWS_ROW));
	while(!(k = _rowread(ARROWS_ROW)));
	while(_rowread(ARROWS_ROW));
	return k;
}
