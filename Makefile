
CC65=	cc65/bin/cc65
CL65=	cc65/bin/cl65
COPTS=	-t c64 -O -Or -Oi -Os --cpu 65c02
LOPTS=	

FILES=		example.prg 

M65IDESOURCES=	main.c \
		memory.c \
		screen.c \
		hal_mega65.c

ASSFILES=	main.s \
		memory.s \
		screen.s \
		hal_mega65.s \
		charset.s

HEADERS=	Makefile \
		memory.h \
		screen.h \
		hal.h \
		ascii.h

DATAFILES=	ascii8x8.bin

%.s:	%.c $(HEADERS) $(DATAFILES) $(CC65)
	$(CC65) $(COPTS) -o $@ $<

all:	$(FILES)

$(CC65):
	git submodule init
	git submodule update
	(cd cc65 && make -j 8)

ascii8x8.bin: ascii00-7f.png tools/pngprepare
	tools/pngprepare charrom ascii00-7f.png ascii8x8.bin

asciih:	asciih.c
	$(CC) -o asciih asciih.c
ascii.h:	asciih
	./asciih

tools/pngprepare:	tools/pngprepare.c
	$(CC) -I/usr/local/include -L/usr/local/lib -o tools/pngprepare tools/pngprepare.c -lpng

example.prg:	$(ASSFILES) $(DATAFILES) $(CL65)
	$(CL65) $(COPTS) $(LOPTS) -vm -m example.map -o example.prg $(ASSFILES)

clean:
	rm -f $(FILES)

cleangen:
	rm ascii8x8.bin
