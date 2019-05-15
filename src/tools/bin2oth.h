//strheader.h
typedef struct {
    char          signature[8]; // "**TI92P*" or "**TI89**"
    unsigned char fill1[2];     // 01 00
    char          folder[8];    // folder name
    char          desc[40];     // ---- not used ----
    unsigned char fill2[6];     // 01 00 52 00 00 00
    char          name[8];      // varname
    unsigned char type[4];      // 0C 00 00 00
    unsigned char size[4];      // complete file size (including checksum)
    unsigned char fill3[6];     // A5 5A 00 00 00 00
    unsigned char datasize[2];  // data size
}
StrHeader;

//tt.h
#define CALC_TI89    0
#define CALC_TI92P   1

#define SIGNATURE_TI89   "**TI89**"
#define SIGNATURE_TI92P  "**TI92P*" 

#define DEFAULT_FOLDER   "main"

#define DEFAULT_ITEMS_PER_LINE  10

#define TT_MAX_MEMBLOCK 65520
#define TT_MAX_OTHDATA  (TT_MAX_MEMBLOCK - 2 - 6)

unsigned char* DataBuffer2OTHBuffer(int            calctype,
                                    char*          folder,
                                    char*          varname,
                                    char*          extension,
                                    unsigned int   inlength,
                                    unsigned char* indata,
                                    unsigned int*  outlength);