#include <stdio.h>
#include <stdlib.h>

#include "hal.h"
#include "memory.h"
#include "screen.h"
#include "ascii.h"

#define POKE(X,Y) (*(unsigned char*)(X))=Y
#define PEEK(X) (*(unsigned char*)(X))

unsigned char sdhc_card=0;

// Tell utilpacker what our display name is
const char *prop_m65u_name="PROP.M65U.NAME=SDCARD FDISK+FORMAT UTILITY";

void usleep(uint32_t micros)
{
  // Sleep for desired number of micro-seconds.
  // Each VIC-II raster line is ~64 microseconds
  // this is not totally accurate, but is a reasonable approach
  while(micros>64) {    
    uint8_t b=PEEK(0xD012);
    while(PEEK(0xD012)==b) continue;
    micros-=64;
  }
  return;
}

void mega65_fast(void)
{
  POKE(0,65);
}

