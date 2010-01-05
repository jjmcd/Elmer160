#
#	Makefile - make file for tstMenu.c and related progs
#
# Commands
ASM=/usr/bin/gpasm
CC=/usr/libexec/sdcc/sdcc
LINK=/usr/bin/gplink
LIB=/usr/bin/gplib
RM=/bin/rm -f
CP=/bin/cp
LIBDIR=/usr/share/sdcc/lib/pic16
INCDIR=/usr/share/sdcc/include/pic16
INC2DIR=/usr/share/sdcc/include

# Assembler options
ASMOPTS=--deps --processor 18f1320
# Compiler optimizations
OPTZ=--optimize-goto --optimize-cmp --optimize-df --obanksel=2 --opt-code-size --peep-asm
# SDCC options
CCOPTS=-mpic16 -p18f1320 $(OPTZ) --model-small --pstack-model=small -I"$(INCDIR)" -I"$(INC2DIR)"
# Linker options
LNKOPTS=--map --script 18f1320.lkr -I"$(LIBDIR)"
# Linker options tstMenu only
LNMOPTS=--map --script tstMenu.lkr -I"$(LIBDIR)"
# PIC 18F base libraries
LIB18=libc18f.lib libio18f1320.lib libm18f.lib libsdcc.lib pic18f1320.lib
# LCDlib dependencies for delays
DELDEPS=Del450ns.o Del2ms.o Del40us.o Del1s.o Del512ms.o Del256ms.o Del128ms.o
# LCDlib dependencies, all
LCDDEPS=LCDinter.o LCDinit.o LCDletr.o LCDsend.o LCDsnd.o LCDclear.o LCDzero.o LCDaddr.o $(DELDEPS)


.SUFFIXES: .c .asm .o .hex

.c.o:
	$(CC) $(CCOPTS) -S $<
	$(ASM) $(ASMOPTS) -c $*.asm

.c.asm:
	$(CC) $(CCOPTS) -S $<

.asm.o:
	$(ASM) $(ASMOPTS) -c $<

all: LongMsg.hex Blink1320.hex TstStdio.hex tstMenu.hex TstStdio2.hex

clean:
	$(RM) *.o *.hex *.map *.d *.lst *.cod Blink1320.asm Delay1320.asm 88LCD.asm TstStdio.asm tstMenu.asm *.p

LongMsg.hex: LongMsg.o Delay1320.o config.o crt0.o LCDlib.lib
	$(LINK) $(LNKOPTS) -o $@ $^ $(LIB18)

Blink1320.hex: Blink1320.o Delay1320.o config.o crt0.o LCDlib.lib
	$(LINK) $(LNKOPTS) -o $@ $^ $(LIB18)

TstStdio.hex: TstStdio.o putchar.o Delay1320.o config.o crt0.o LCDlib.lib
	$(LINK) $(LNKOPTS) -o $@ $^ $(LIB18)

TstStdio2.hex: TstStdio2.o putchar.o Delay1320.o config.o crt0.o LCDlib.lib
	$(LINK) $(LNKOPTS) -o $@ $^ $(LIB18)

tstMenu.hex: tstMenu.o Delay1320.o config.o crt0.o LCDlib.lib
	$(LINK) $(LNMOPTS) -o $@ $^ $(LIB18)

LCDlib.lib: $(LCDDEPS)
	$(LIB) -c $@ $^

crt0.c:
	$(CP)  /usr/share/sdcc/lib/src/pic16/startup/crt0.c .

