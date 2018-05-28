// C Source File
// Created 3/29/2005; 2:23:10 PM

#define __IN_DLL__
#include <tigcclib.h>
#include "gb68k.h"

DLL_INTERFACE

#include "gbsram.h"
#include "gbinit.h"

DLL_ID GB_ID
DLL_VERSION DLL_MAJOR, DLL_MINOR
DLL_EXPORTS

save_sram,
load_sram,
save_state,
load_state,
file_pointer,
select_rom,
init_rom,
esc_menu

DLL_IMPLEMENTATION
