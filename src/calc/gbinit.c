// C Source File
// Created 5/3/2005; 1:56:17 PM

#define __IN_DLL__
#include <tigcclib.h>
#include "gb68k.h"
#include "gbsetup.h"
#include "gbsram.h"

const unsigned char mbc_table[] = {
	NO_MBC,		//0
	MBC1,			//1
	MBC1,			//2
	MBC1,			//3
	BAD_MBC,	//4
	MBC2,			//5
	MBC2,			//6
	BAD_MBC,	//7
	NO_MBC,		//8
	NO_MBC,		//9
	BAD_MBC,	//A
	BAD_MBC,	//B
	BAD_MBC,	//C
	BAD_MBC,	//D
	BAD_MBC,	//E
	MBC3,			//F
	MBC3,			//10
	MBC3,			//11
	MBC3,			//12
	MBC3,			//13
	BAD_MBC,	//14
	BAD_MBC,	//15
	BAD_MBC,	//16
	BAD_MBC,	//17
	BAD_MBC,	//18
	MBC5,			//19
	MBC5,			//1A
	MBC5,			//1B
	MBC5,			//1C
	MBC5,			//1D
	MBC5,			//1E
};

char check_name(char *s)
{
	short i = strlen(s) - 1;

	if(s[i] != '0' || s[i - 1] != '0') return FALSE;
	else return TRUE;
}

#define MAX_FILES 20
void select_rom(char *file)
{
	SYM_ENTRY *entry;
	HANDLE menu;
	unsigned char *data;
	unsigned short size;
	unsigned short v;
	short select;
	const char ext[] = {0, 'G', 'B', 'R', 0, OTH_TAG};
	//char name[9];
	char name_data[MAX_FILES * 8];
	char *name_ptr = name_data;
	short number = 0;
	
	menu = PopupNew("Select ROM", 0);
	if(menu == H_NULL) { gb_data->error = ERROR_OUT_OF_MEM; file[0] = 0; return; }

	FolderOp(NULL, FOP_LOCK | FOP_ALL_FOLDERS);

	entry = SymFindFirst(NULL, FO_RECURSE | FO_SKIP_TEMPS);
	while(entry) {
		if(!entry->flags.bits.folder) {
			data = HeapDeref(entry->handle);
			size = *(unsigned short *)data + 2;
			v = *(unsigned short *)(data + 2);
			//clrscr();
			//printf("%u", size);
			//ngetchx();
			//*(data + size - 1) == OTH_TAG)
			if(memcmp(data + size - 6, ext, 6) == 0 &&
			(v == ROM_FILE_VERSION || v == 1) &&
			check_name(entry->name)) {
				strcpy(name_ptr, entry->name);
				name_ptr[strlen(name_ptr) - 2] = 0;
				PopupAddText(menu, -1, name_ptr, 0);
				name_ptr += 8;
				number++;
			}
			//HeapUnlock(entry->handle);
		}
		if(number == MAX_FILES) entry = NULL;
		else entry = SymFindNext();
	}

	select = PopupDo(menu, CENTER, CENTER, 0);
	if(select == 0) file[0] = 0;
	else strcpy(file, PopupText(menu, select));
	HeapFree(menu);

	FolderOp(NULL, FOP_UNLOCK | FOP_ALL_FOLDERS);
}

char init_rom(char *file)
{
	char name[10];
	unsigned char file_num;
	short file_index = 0, half_bank = 0, banks_per_file;
	unsigned short v;
	unsigned short i;

	sprintf(name, "%s00", file);
	gb_data->rom_ptr[0] = file_pointer(name);
	if(gb_data->rom_ptr[0] == NULL) { gb_data->error = ERROR_MISSING_FILE; return FALSE; }
	v = *(unsigned short *)gb_data->rom_ptr[0];
	gb_data->rom_ptr[0] += 2;
	
	if(v == 0) banks_per_file = 7;
	else banks_per_file = 6;
	
	if(gb_data->rom_ptr[0][0x147] > 0x1E) { gb_data->error = ERROR_UNSUPPORTED; return FALSE; }
	else gb_data->cart_type = mbc_table[gb_data->rom_ptr[0][0x147]];
	if(gb_data->cart_type == BAD_MBC) { gb_data->error = ERROR_UNSUPPORTED; return FALSE; }
	
	gb_data->rom_banks = 2 << gb_data->rom_ptr[0][0x148];
	i = gb_data->rom_ptr[0][0x149];
	if(i == 0) gb_data->ram_banks = 0;
	else if(i == 1 || i == 2) gb_data->ram_banks = 1;
	else if(i == 3) gb_data->ram_banks = 4;
	else { gb_data->error = ERROR_UNSUPPORTED; return FALSE; }
	gb_data->current_rom = 1;
	gb_data->current_ram = 0;
	gb_data->mbc_mode = 0;
	file_num = (gb_data->rom_banks * 2) / banks_per_file;
	if(file_num * banks_per_file != gb_data->rom_banks * 2) file_num++;

	for(i = 1 ; i < file_num ; i++) {
		sprintf(name, "%s%02d", file, i);
		gb_data->rom_ptr[i] = file_pointer(name);
		if(gb_data->rom_ptr[i] == NULL || *(unsigned short *)gb_data->rom_ptr[i] != v) {
			gb_data->error = ERROR_MISSING_FILE; return FALSE;
		}
		gb_data->rom_ptr[i] += 2;
	}
	
	gb_data->bank_table = HeapAllocPtr(sizeof(BANK_HEADER) * gb_data->rom_banks);
	if(gb_data->bank_table == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	
	//construct half bank index table
	for(i = 0; i < gb_data->rom_banks; i++) {
		gb_data->bank_table[i].first_loc = file_index;
		gb_data->bank_table[i].first_offset = half_bank;
		half_bank++;
		if(half_bank == banks_per_file) { file_index++; half_bank = 0; }
		gb_data->bank_table[i].second_loc = file_index;
		gb_data->bank_table[i].second_offset = half_bank;
		half_bank++;
		if(half_bank == banks_per_file) { file_index++; half_bank = 0; }
		//clrscr();
		//printf("%d %d %d %d", bank_table[i].first_loc, bank_table[i].first_offset, bank_table[i].second_loc, bank_table[i].second_offset);
		//ngetchx();
	}
	
	return TRUE;
}

static inline void options_menu()
{
	HANDLE dialog;
	HANDLE fs_menu;
	HANDLE on_off_menu;
	char text[] = "0";
	short pulldown_buffer[10];
	short y_pos = 16, dy;
	short i;
	
	fs_menu = PopupNew(NULL, 0);
	for(i = 0; i < 10; i++) {
		PopupAddText(fs_menu, -1, text, 0);
		text[0]++;
	}
	
	on_off_menu = PopupNew(NULL, 0);
	PopupAddText(on_off_menu, -1, "On", 0);
	PopupAddText(on_off_menu, -1, "Off", 0);
	
	if(gb_data->calc_type == 0) {
		dialog = DialogNewSimple(140, 56);
		dy = 6;
	} else {
		dialog = DialogNewSimple(180, 68);
		dy = 9;
	}
	DialogAddTitle(dialog, "GB68K - Options", BT_OK, BT_CANCEL);
	DialogAddPulldown(dialog, 5, y_pos, "Frameskip: ", fs_menu, 0); y_pos += dy;
	DialogAddPulldown(dialog, 5, y_pos, "Timer: ", on_off_menu, 1); y_pos += dy;
	DialogAddPulldown(dialog, 5, y_pos, "Show FPS: ", on_off_menu, 2); y_pos += dy;
	DialogAddPulldown(dialog, 5, y_pos, "Archive SRAM: ", on_off_menu, 3);
	
	pulldown_buffer[0] = gb_data->frame_skip + 1;
	pulldown_buffer[1] = 2 - gb_data->enable_timer;
	pulldown_buffer[2] = 2 - gb_data->show_fps;
	pulldown_buffer[3] = 2 - gb_data->archive_sram;
	
	if(DialogDo(dialog, CENTER, CENTER, NULL, pulldown_buffer) == KEY_ENTER) {
		gb_data->frame_skip = pulldown_buffer[0] - 1;
		gb_data->enable_timer = 2 - pulldown_buffer[1];
		gb_data->show_fps = 2 - pulldown_buffer[2];
		gb_data->archive_sram = 2 - pulldown_buffer[3];
	}
	
	HeapFree(dialog);
}

short esc_menu()
{
	HANDLE menu;
	short s;
	
	menu = PopupNew("GB68K", 0);
	if(menu == H_NULL) { gb_data->error = ERROR_OUT_OF_MEM; return -1; }
	PopupAddText(menu, -1, "Options", 0);
	PopupAddText(menu, -1, "Quit", 0);
	GKeyFlush();
	if(gb_data->calc_type == 0)
		DrawLine(0, 93, 159, 93, A_NORMAL);
	else
		DrawLine(0, 121, 239, 121, A_NORMAL);
	
	do {
		s = PopupDo(menu, CENTER, CENTER, 0);
		if(s == 1) options_menu();
	} while(s != 0 && s != 2);
	HeapFree(menu);
	
	if(s == 2) return 1; //quit
	else return 0; //don't quit
}	
