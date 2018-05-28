// Header File
// Created 4/5/2005; 2:09:22 PM

#ifndef __GBSRAM__
#define __GBSRAM__

#include "gbdll.h"

#define MEMREQ_LZFO_PACK ((unsigned int)((1<<13)*4U+256))
#define MEMREQ_LZFO_UNPACK(P_SIZE) ((unsigned int)((P_SIZE<16384?P_SIZE:16384)*2U))
#define LZFO_MAX_OUTSIZE(IN_SIZE)       (IN_SIZE+6)

#ifdef __IN_DLL__
char save_state(char *file);
char load_state(char *file);
void *file_pointer(const char *name);
#else
#define save_state _DLL_call(char, (char *), DLL_SAVE_STATE)
#define load_state _DLL_call(char, (char *), DLL_LOAD_STATE)
#define file_pointer _DLL_call(void *, (const char *), DLL_FILE_POINTER)
#endif

#endif