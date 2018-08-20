
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

ascii8x8.bin: ascii00-7f.png tools/pngprepare tools/raw2bin
	# Convert PNG font to bin format
	tools/pngprepare charrom ascii00-7f.png temp.bin
	# Get the first 128 chars from our PNG derived character set
	dd if=temp.bin bs=1024 count=1 of=00-7f.bin
	# Convert the codepage 437 from raw to bin format
	tools/raw2bin 8x8.raw 8x8.bin
	# get the 2nd half of the chars from the codepage 437 file
	dd if=8x8.bin of=80-ff.bin bs=1024 skip=1
	# Glue the first 128 chars from our PNG to the last 128 chars from the codepage 437 font
	cat 00-7f.bin 80-ff.bin > ascii8x8.bin

asciih:	asciih.c
	$(CC) -o asciih asciih.c
ascii.h:	asciih
	./asciih

tools/pngprepare:	tools/pngprepare.c
	$(CC) -I/usr/local/include -L/usr/local/lib -o tools/pngprepare tools/pngprepare.c -lpng

tools/raw2bin:	tools/raw2bin.c
	$(CC) -I/usr/local/include -L/usr/local/lib -o tools/raw2bin tools/raw2bin.c -lpng

example.prg:	$(ASSFILES) $(DATAFILES) $(CL65)
	$(CL65) $(COPTS) $(LOPTS) -vm -m example.map -o example.prg $(ASSFILES)

clean:
	rm -f $(FILES)

cleangen:
	rm ascii8x8.bin
