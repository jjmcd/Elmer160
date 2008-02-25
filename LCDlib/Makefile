# Makefile to build LCDlibb for each of the five
# processors used in Lesson 21
#
# $Revision: 2.0 $
# $Date: 2008-02-25 15:25:32-05 $
#
RM=rm -f
MAKE=make -f Makefile_1
DELDEPS=Del450ns.asm Del2ms.asm Del40us.asm Del1s.asm \
  Del512ms.asm Del256ms.asm Del128ms.asm
LCDDEPS=LCDinit.asm LCDletr.asm LCDsend.asm LCDsnd.asm \
  LCDclear.asm $(DELDEPS)

all: LCDlib_84A.lib LCDlib_88.lib LCDlib_628.lib \
  LCDlib_648A.lib LCDlib_819.lib LCDlib_716.lib \
  LCDlib_627A.lib LCDlib_87.lib LCDlib_818.lib \
  LCDlib_627.lib LCDlib_628A.lib

clean:
	$(RM) *.o *.hex *.map *.d *.lst *.cod

LCDlib_84A.lib : $(LCDDEPS)
	$(MAKE) P=84A

LCDlib_87.lib : $(LCDDEPS)
	$(MAKE) P=87

LCDlib_88.lib : $(LCDDEPS)
	$(MAKE) P=88

LCDlib_627.lib : $(LCDDEPS)
	$(MAKE) P=627

LCDlib_627A.lib : $(LCDDEPS)
	$(MAKE) P=627A

LCDlib_628.lib : $(LCDDEPS)
	$(MAKE) P=628

LCDlib_628A.lib : $(LCDDEPS)
	$(MAKE) P=628A

LCDlib_648A.lib : $(LCDDEPS)
	$(MAKE) P=648A

LCDlib_818.lib : $(LCDDEPS)
	$(MAKE) P=818

LCDlib_819.lib : $(LCDDEPS)
	$(MAKE) P=819

LCDlib_716.lib : $(LCDDEPS)
	$(MAKE) P=716


