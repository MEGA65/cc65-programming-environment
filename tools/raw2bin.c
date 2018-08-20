#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>

int main(int argc,char **argv)
{
  if (argc<3) {
    fprintf(stderr,"Usage: raw2bin <font.raw> <font.bin>\n");
    exit(-3);
  }

  FILE *in=fopen(argv[1],"r");
  FILE *out=fopen(argv[2],"w");

  if (!in||!out) { fprintf(stderr,"Could not open input and/or output file.\n"); exit(-3); }

  char line[65536];
  line[0]=0; fgets(line,65536,in);
  while (line[0]) {
    for(int o=0;o<strlen(line);o+=8) {
       int b=0;
       for(int j=0;j<8;j++)
         if (line[o+j]=='@') b|=(1<<(7-j));
       fputc(b,out);
    }
    line[0]=0; fgets(line,1024,in);
  }
  fclose(out); fclose(in);
  return 0;
}
