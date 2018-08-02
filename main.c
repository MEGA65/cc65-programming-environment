/*
  A simple example program using CC65 and some simple routines to
  use an 80 column ASCII screen on the MEGA65.

  If you follow some restrictions, it is also possible to make such
  programs compile and run natively on your development system for
  testing.
 
*/

#include <stdio.h>
#include <string.h>

#include "hal.h"
#include "memory.h"
#include "screen.h"
#include "ascii.h"

#ifdef __CC65__
void main(void)
#else
int main(int argc,char **argv)
#endif
{
#ifdef __CC65__
  mega65_fast();
  setup_screen();
#endif  
  
  // set border and screen colours
  POKE(0xd020U,0);
  POKE(0xd021U,6);

  // Write a line of text
  write_line("Type something, then press RETURN",0);
  // Change the colour of that line of text
  recolour_last_line(4);
 

  // Read a line of input, and print it back out 
  {
    char line_of_input[80];
    unsigned char len;
    len=read_line(line_of_input,80);
    if (len) {
      write_line(line_of_input,0);
      recolour_last_line(7);
    }
  }
  
  // This program doesn't clean up for return to C64 BASIC,
  // so it finishes in an infinite loop. 
#ifdef __CC65__
  while(1) continue;
#else
  return 0;
#endif
  
}
