# Makefile for Lesson 21
#
# This makefile is intended for use with gputils
#
# $Revision: 1.13 $ $State: Exp $ $Date: 2007-11-19 12:22:56-05 $
#
# Set symbols for a few commands
ASM=gpasm
LINK=gplink
RM=rm -f
LIB=gplib
#
# Define switches for PIC16F88
ASM88=--deps --processor 16F88
LNK88=--map --script Less21-F88.lkr
#
# Define dependencies for PIC16F88
LIBS88=Mylib_88.lib LCDlib_88.lib
L21A88DEPS=ISRa_88.o L21a_88.o $(LIBS88)
L21B88DEPS=ISRa_88.o L21b_88.o SaveCntB_88.o $(LIBS88)
L21C88DEPS=ISRc_88.o L21c_88.o SaveCntC_88.o $(LIBS88)
#
# Define switches for PIC16F84A
ASM84A=--deps --processor 16F84A
LNK84A=--map --script Less21-F84A.lkr
#
# Define dependencies for PIC16F84A
LIBS84A=Mylib_84A.lib LCDlib_84A.lib
L21A84ADEPS=ISRa_84A.o L21a_84A.o $(LIBS84A)
L21B84ADEPS=ISRa_84A.o L21b_84A.o SaveCntB_84A.o $(LIBS84A)
L21C84ADEPS=ISRc_84A.o L21c_84A.o SaveCntC_84A.o $(LIBS84A)
#
# Define switches for PIC16F628
ASM628=--deps --processor 16F628
LNK628=--map --script Less21-F628.lkr
#
# Define dependencies for PIC16F628
LIBS628=Mylib_628.lib LCDlib_628.lib
L21A628DEPS=ISRa_628.o L21a_628.o $(LIBS628)
L21B628DEPS=ISRa_628.o L21b_628.o SaveCntB_628.o $(LIBS628)
L21C628DEPS=ISRc_628.o L21c_628.o SaveCntC_628.o $(LIBS628)
#
# Define switches for PIC16F648A
ASM648A=--deps --processor 16F648A
LNK648A=--map --script Less21-F648A.lkr
#
# Define dependencies for PIC16F648A
LIBS648A=Mylib_648A.lib LCDlib_648A.lib
L21A648ADEPS=ISRa_648A.o L21a_648A.o $(LIBS648A)
L21B648ADEPS=ISRa_648A.o L21b_648A.o SaveCntB_648A.o $(LIBS648A)
L21C648ADEPS=ISRc_648A.o L21c_648A.o SaveCntC_648A.o $(LIBS648A)
#
# Define switches for PIC16F819
ASM819=--deps --processor 16F819
LNK819=--map --script Less21-F819.lkr
#
# Define dependencies for PIC16F819
LIBS819=Mylib_819.lib LCDlib_819.lib
L21A819DEPS=ISRa_819.o L21a_819.o $(LIBS819)
L21B819DEPS=ISRa_819.o L21b_819.o SaveCntB_819.o $(LIBS819)
L21C819DEPS=ISRc_819.o L21c_819.o SaveCntC_819.o $(LIBS819)

.SUFFIXES: .asm .o .hex

# For a complete make, 3 hex files per processor
all: L21a_88.hex   L21b_88.hex   L21c_88.hex  \
     L21a_84A.hex  L21b_84A.hex  L21c_84A.hex \
     L21a_628.hex  L21b_628.hex  L21c_628.hex \
     L21a_648A.hex L21b_648A.hex L21c_648A.hex\
     L21a_819.hex  L21b_819.hex  L21c_819.hex 

# Remove everything that is built
clean:
	$(RM) *.o *.hex *.map *.d *.lst *.cod

# Remove all built artifacts except hex and map
tidy:
	$(RM) *.o *.d *.cod *.lst

#
#  For each processor, we build a MyLib containing those functions
#  that are the same across the three programs, and then link the
#  programs.  Since the names of the .o are different than the names
#  of the .asm, we cannot rely on default rules for the assembly.
#
#  For the PIC16F88
#
L21a_88.hex: $(L21A88DEPS)
	$(LINK) $(LNK88) -o $@ $^

L21b_88.hex: $(L21B88DEPS)
	$(LINK) $(LNK88) -o $@ $^

L21c_88.hex: $(L21C88DEPS)
	$(LINK) $(LNK88) -o $@ $^

Mylib_88.lib: ConvBCD2_88.o Disp16_88.o InitTMR0_88.o RestCnt_88.o
	$(LIB) -c $@ $^

RestCnt_88.o : RestCnt.asm
	$(ASM) $(ASM88) -c $< -o $@

ConvBCD2_88.o : ConvBCD2.asm
	$(ASM) $(ASM88) -c $< -o $@

Disp16_88.o : Disp16.asm
	$(ASM) $(ASM88) -c $< -o $@

InitTMR0_88.o : InitTMR0.asm
	$(ASM) $(ASM88) -c $< -o $@

ISRa_88.o     : ISRa.asm
	$(ASM) $(ASM88) -c $< -o $@

L21a_88.o     : L21a.asm
	$(ASM) $(ASM88) -c $< -o $@

L21b_88.o     : L21b.asm
	$(ASM) $(ASM88) -c $< -o $@

SaveCntB_88.o : SaveCntB.asm
	$(ASM) $(ASM88) -c $< -o $@

ISRc_88.o     : ISRc.asm
	$(ASM) $(ASM88) -c $< -o $@

L21c_88.o     : L21c.asm
	$(ASM) $(ASM88) -c $< -o $@

SaveCntC_88.o : SaveCntC.asm
	$(ASM) $(ASM88) -c $< -o $@

#
#  For the PIC16F84A
#
L21a_84A.hex: $(L21A84ADEPS)
	$(LINK) $(LNK84A) -o $@ $^

L21b_84A.hex: $(L21B84ADEPS)
	$(LINK) $(LNK84A) -o $@ $^

L21c_84A.hex: $(L21C84ADEPS)
	$(LINK) $(LNK84A) -o $@ $^

Mylib_84A.lib: ConvBCD2_84A.o Disp16_84A.o InitTMR0_84A.o RestCnt_84A.o
	$(LIB) -c $@ $^

RestCnt_84A.o : RestCnt.asm
	$(ASM) $(ASM84A) -c $< -o $@

ConvBCD2_84A.o : ConvBCD2.asm
	$(ASM) $(ASM84A) -c $< -o $@

Disp16_84A.o : Disp16.asm
	$(ASM) $(ASM84A) -c $< -o $@

InitTMR0_84A.o : InitTMR0.asm
	$(ASM) $(ASM84A) -c $< -o $@

ISRa_84A.o     : ISRa.asm
	$(ASM) $(ASM84A) -c $< -o $@

L21a_84A.o     : L21a.asm
	$(ASM) $(ASM84A) -c $< -o $@

L21b_84A.o     : L21b.asm
	$(ASM) $(ASM84A) -c $< -o $@

SaveCntB_84A.o : SaveCntB.asm
	$(ASM) $(ASM84A) -c $< -o $@

ISRc_84A.o     : ISRc.asm
	$(ASM) $(ASM84A) -c $< -o $@

L21c_84A.o     : L21c.asm
	$(ASM) $(ASM84A) -c $< -o $@

SaveCntC_84A.o : SaveCntC.asm
	$(ASM) $(ASM84A) -c $< -o $@

#
#  For the PIC16F628
#
L21a_628.hex: $(L21A628DEPS)
	$(LINK) $(LNK628) -o $@ $^

L21b_628.hex: $(L21B628DEPS)
	$(LINK) $(LNK628) -o $@ $^

L21c_628.hex: $(L21C628DEPS)
	$(LINK) $(LNK628) -o $@ $^

Mylib_628.lib: ConvBCD2_628.o Disp16_628.o InitTMR0_628.o RestCnt_628.o
	$(LIB) -c $@ $^

RestCnt_628.o : RestCnt.asm
	$(ASM) $(ASM628) -c $< -o $@

ConvBCD2_628.o : ConvBCD2.asm
	$(ASM) $(ASM628) -c $< -o $@

Disp16_628.o : Disp16.asm
	$(ASM) $(ASM628) -c $< -o $@

InitTMR0_628.o : InitTMR0.asm
	$(ASM) $(ASM628) -c $< -o $@

ISRa_628.o     : ISRa.asm
	$(ASM) $(ASM628) -c $< -o $@

L21a_628.o     : L21a.asm
	$(ASM) $(ASM628) -c $< -o $@

L21b_628.o     : L21b.asm
	$(ASM) $(ASM628) -c $< -o $@

SaveCntB_628.o : SaveCntB.asm
	$(ASM) $(ASM628) -c $< -o $@

ISRc_628.o     : ISRc.asm
	$(ASM) $(ASM628) -c $< -o $@

L21c_628.o     : L21c.asm
	$(ASM) $(ASM628) -c $< -o $@

SaveCntC_628.o : SaveCntC.asm
	$(ASM) $(ASM628) -c $< -o $@

#
#  For the PIC16F648A
#
L21a_648A.hex: $(L21A648ADEPS)
	$(LINK) $(LNK648A) -o $@ $^

L21b_648A.hex: $(L21B648ADEPS)
	$(LINK) $(LNK648A) -o $@ $^

L21c_648A.hex: $(L21C648ADEPS)
	$(LINK) $(LNK648A) -o $@ $^

Mylib_648A.lib: ConvBCD2_648A.o Disp16_648A.o InitTMR0_648A.o RestCnt_648A.o
	$(LIB) -c $@ $^

RestCnt_648A.o : RestCnt.asm
	$(ASM) $(ASM648A) -c $< -o $@

ConvBCD2_648A.o : ConvBCD2.asm
	$(ASM) $(ASM648A) -c $< -o $@

Disp16_648A.o : Disp16.asm
	$(ASM) $(ASM648A) -c $< -o $@

InitTMR0_648A.o : InitTMR0.asm
	$(ASM) $(ASM648A) -c $< -o $@

ISRa_648A.o     : ISRa.asm
	$(ASM) $(ASM648A) -c $< -o $@

L21a_648A.o     : L21a.asm
	$(ASM) $(ASM648A) -c $< -o $@

L21b_648A.o     : L21b.asm
	$(ASM) $(ASM648A) -c $< -o $@

SaveCntB_648A.o : SaveCntB.asm
	$(ASM) $(ASM648A) -c $< -o $@

ISRc_648A.o     : ISRc.asm
	$(ASM) $(ASM648A) -c $< -o $@

L21c_648A.o     : L21c.asm
	$(ASM) $(ASM648A) -c $< -o $@

SaveCntC_648A.o : SaveCntC.asm
	$(ASM) $(ASM648A) -c $< -o $@

#
#  For the PIC16F819
#
L21a_819.hex: $(L21A819DEPS)
	$(LINK) $(LNK819) -o $@ $^

L21b_819.hex: $(L21B819DEPS)
	$(LINK) $(LNK819) -o $@ $^

L21c_819.hex: $(L21C819DEPS)
	$(LINK) $(LNK819) -o $@ $^

Mylib_819.lib: ConvBCD2_819.o Disp16_819.o InitTMR0_819.o RestCnt_819.o
	$(LIB) -c $@ $^

RestCnt_819.o : RestCnt.asm
	$(ASM) $(ASM819) -c $< -o $@

ConvBCD2_819.o : ConvBCD2.asm
	$(ASM) $(ASM819) -c $< -o $@

Disp16_819.o : Disp16.asm
	$(ASM) $(ASM819) -c $< -o $@

InitTMR0_819.o : InitTMR0.asm
	$(ASM) $(ASM819) -c $< -o $@

ISRa_819.o     : ISRa.asm
	$(ASM) $(ASM819) -c $< -o $@

L21a_819.o     : L21a.asm
	$(ASM) $(ASM819) -c $< -o $@

L21b_819.o     : L21b.asm
	$(ASM) $(ASM819) -c $< -o $@

SaveCntB_819.o : SaveCntB.asm
	$(ASM) $(ASM819) -c $< -o $@

ISRc_819.o     : ISRc.asm
	$(ASM) $(ASM819) -c $< -o $@

L21c_819.o     : L21c.asm
	$(ASM) $(ASM819) -c $< -o $@

SaveCntC_819.o : SaveCntC.asm
	$(ASM) $(ASM819) -c $< -o $@

