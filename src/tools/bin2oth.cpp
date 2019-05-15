#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "bin2oth.h"


//=============================================================================
// returns a pointer to a newly allocated memory block which holds the
// OTH file contents ready to flush into a file
//
// the length of the newly allocated memory block will be stored in outlength
//=============================================================================
unsigned char* DataBuffer2OTHBuffer(int            calctype,
                                    char*          folder,
                                    char*          varname,
                                    char*          extension,
                                    unsigned int   inlength,
                                    unsigned char* indata,
                                    unsigned int*  outlength)
{
    StrHeader*     psh;
    unsigned int   checksum;
    unsigned char* ptr;
    unsigned int   size;
    unsigned char* output;

    if (inlength > TT_MAX_OTHDATA) {
        fprintf(stderr,"ERROR: length (%u) exceeds max. user data size (%u)\n",inlength,TT_MAX_OTHDATA);
        return 0;
    }

    size = sizeof(StrHeader)+inlength+2+6; // 6 == OTH bytes , 2 == checksum

    //if (!(output = (unsigned char*)malloc(size))) {
    //    fprintf(stderr,"ERROR: cannot allocate %u bytes of memory\n",size);
    //    return 0;
    //}

	output = new unsigned char[size];

    *outlength = size;
    psh = (StrHeader*)output;
    memset(psh,0,sizeof(StrHeader));

    //-------------------------------------------------------------------
    // fill up all the static fields
    //-------------------------------------------------------------------
    psh->fill1[0]=1;psh->fill1[1]=0;
    psh->fill2[0]=0x01;psh->fill2[1]=0x00;psh->fill2[2]=0x52;
    psh->fill2[3]=0x00;psh->fill2[4]=0x00;psh->fill2[5]=0x00;
    psh->fill3[0]=0xA5;psh->fill3[1]=0x5A;psh->fill3[2]=0x00;
    psh->fill3[3]=0x00;psh->fill3[4]=0x00;psh->fill3[5]=0x00;
    psh->type[0]=0x0c;psh->type[1]=0x00;psh->type[2]=0x03;psh->type[3]=0x00;

    //-------------------------------------------------------------------
    // fill in the magic marker string depending on given calc type
    //-------------------------------------------------------------------
    if (calctype == CALC_TI89) strncpy(psh->signature,SIGNATURE_TI89,8);
    else                       strncpy(psh->signature,SIGNATURE_TI92P,8);

    //-------------------------------------------------------------------
    // fill in folder and variable name
    // if folder name pointer is NULL, use DEFAULT_FOLDER ("main")
    //-------------------------------------------------------------------
    if (!folder) strncpy(psh->folder,DEFAULT_FOLDER,8);
    else         strncpy(psh->folder,folder,8);

    strncpy(psh->name,varname,8);

    //-------------------------------------------------------------------
    // size holds the complete output size == filelength including header
    //-------------------------------------------------------------------
    psh->size[0] = (unsigned char)(size & 0xff);
    psh->size[1] = (unsigned char)((size >> 8)  & 0xff);
    psh->size[2] = (unsigned char)((size >> 16) & 0xff);
    psh->size[3] = (unsigned char)((size >> 24) & 0xff);

    //-------------------------------------------------------------------
    // data size will hold user data size + OTH tag related bytes
    // + datasize itself (2 bytes)
    //-------------------------------------------------------------------
    size -= sizeof(StrHeader);
    size -= 2;
    psh->datasize[0] = (unsigned char)((size >> 8) & 0xff);
    psh->datasize[1] = (unsigned char)(size & 0xff);

    //-------------------------------------------------------------------
    // copy complete indata
    //-------------------------------------------------------------------
    memcpy(output + sizeof(StrHeader),indata,inlength);

    //-------------------------------------------------------------------
    // append OTH bytes
    //-------------------------------------------------------------------
    ptr    = output + sizeof(StrHeader) + inlength;
    *ptr++ = 0;
    *ptr++ = *extension++;
    *ptr++ = *extension++;
    *ptr++ = *extension;
    *ptr++ = 0;
    *ptr++ = 0xF8;

    size = *outlength - sizeof(StrHeader);
    ptr  = psh->datasize;

    checksum = 0;
    while (size--) checksum += *ptr++;

    output[*outlength-2] = (unsigned char)(checksum & 0xff);
    output[*outlength-1] = (unsigned char)((checksum >> 8) & 0xff);

    return output;
}