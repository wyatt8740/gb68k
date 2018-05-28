#include <stdio.h>
#include <string.h>
#include "bin2oth.h"

FILE *in, *out;
unsigned char *rom;
unsigned char cart_type, rom_size, ram_size, rom_banks, ram_banks;
char cart_name[17];

#define ROM_FILE_VERSION 0

enum CART_TYPES {
	ROM_ONLY,
	ROM_MBC1,
	ROM_MBC1_RAM,
	ROM_MBC1_RAM_BATT,
	ROM_MBC2,
	ROM_MBC2_BATTERY,
	ROM_RAM,
	ROM_RAM_BATTERY,
};

int main(int argc, void *argv[])
{
	unsigned int len, oth_len;
	int i, offset, code_size;
	char file[1024], calc_name[1024];
	unsigned char *buffer;
	unsigned char *patched_code;
	char ext[] = "GBR";
	char *base_name;
	int half_banks, current_banks, banks_per_file;
	bool more;

	if(argc < 3) {
		printf("ERROR: bad args\n");
		return 0;
	}
	base_name = (char *)argv[2];

	in = fopen((const char *)argv[1], "rb");
	if(in == NULL) {
		printf("Can't find file: %s", argv[1]);
		return 0;
	}
	fseek(in, 0, SEEK_END);
	len = ftell(in);
	fseek(in, 0, SEEK_SET);
	rom = new unsigned char[len];
	fread(rom, len, 1, in);
	fclose(in);

	cart_type = rom[0x147];
	rom_size = rom[0x148];
	ram_size = rom[0x149];
	memset(cart_name, 0, 17);
	memcpy(cart_name, (char *)(rom + 0x134), 16);
	rom_banks = 2 << rom_size;
	if(ram_size == 0) ram_banks = 0;
	else if(ram_size == 1 || ram_size == 2) ram_banks = 1;
	else if(ram_size == 2) ram_banks = 4;
	else ram_banks = 16; //too many for calc

	half_banks = rom_banks * 2;

	//printf("Cart: %s, type:%d, rom:%d (%d), ram:%d", cart_name, cart_type, rom_size, len, ram_size);
	//getchar();

	if(argc > 3 && strcmp((const char *)argv[3], "-dirty") == 0) {
		banks_per_file = 7;
	} else {
		banks_per_file = 6;
	}

	i = 0; offset = 0; oth_len = 0;
	while(half_banks) {
		sprintf(file, "%s%02d.89y", base_name, i);
		sprintf(calc_name, "%s%02d", base_name, i);
		if(half_banks <= banks_per_file) {
			current_banks = half_banks;
			half_banks = 0;
			more = false;
		} else {
			current_banks = banks_per_file;
			half_banks -= banks_per_file;
			more = true;
		}
		
		code_size = 1024 * 8 * current_banks + 2;
		patched_code = new unsigned char[code_size + 5];
		*(unsigned char *)(patched_code + 0) = 0x00;
		if(banks_per_file == 7) *(unsigned char *)(patched_code + 1) = 0;
		else *(unsigned char *)(patched_code + 1) = 1;
		memcpy(patched_code + 2,
			rom + offset, code_size - 2);
		offset += 1024 * 8 * banks_per_file;

		if(more && banks_per_file == 7) {
			//rom0 will always be continuous
			//the bank loaded from 0x4000 - 0x7FFF may be split between 2 files
			//split will occur at 0x5FFF - 0x6000
			//cases - add jump at 0x6000
			//1 byte inst @ 0x5fff
			//2 byte inst @ 0x5ffe
			//3 byte inst @ 0x5ffd
			//cases - add jump at 0x6001, copy one byte into 0x6000
			//2 byte inst @ 0x5fff
			//3 byte inst @ 0x5ffe
			//case - add jump at 0x6002, copy bytes into 0x6000 and 0x6001
			//3 byte inst @ 0x5fff

			//add GB instruction to jump to next code block at end of file
			patched_code[code_size++] = 0xC3; //JP 0x6000
			patched_code[code_size++] = 0x00;
			patched_code[code_size++] = 0x60;

			if(0) {
				patched_code[code_size++] = rom[offset];
				patched_code[code_size++] = 0xC3; //JP 0x6001
				patched_code[code_size++] = 0x01;
				patched_code[code_size++] = 0x60;
			} else if(0) {
				patched_code[code_size++] = rom[offset];
				patched_code[code_size++] = rom[offset + 1];
				patched_code[code_size++] = 0xC3; //JP 0x6002
				patched_code[code_size++] = 0x02;
				patched_code[code_size++] = 0x60;
			}


		}

		buffer =
			DataBuffer2OTHBuffer(CALC_TI89, 0, calc_name, ext,
			code_size, patched_code, &oth_len);

		out = fopen(file, "wb");
		fwrite(buffer, oth_len, 1, out);
		fclose(out);
		delete buffer;
		delete patched_code;
		i++; 
	}

	delete rom;

	return 0;
}



