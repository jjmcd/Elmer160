@ECHO OFF
REM Build the LCD Library - MPLAB 6.x version
REM
REM Set PROC for the desired processor
REM Set TOOLS to reflect the location of MPLAB on your system
REM
SET PROC=627
SET TOOLS=C:\usb\MPLAB IDE\MCHIP_tools

SET ASM="%TOOLS%\MPASMWIN.EXE"
SET LIB="%TOOLS%\MPLIB.EXE"
SET ASMFLAGS=/e+ /l+ /x- /c+ /p16F%PROC% /o+ /q
SET HERE=.
SET THERE=..

CD %THERE%
%ASM% %ASMFLAGS% Del128ms.asm
%ASM% %ASMFLAGS% Del1s.asm
%ASM% %ASMFLAGS% Del2ms.asm
%ASM% %ASMFLAGS% Del256ms.asm
%ASM% %ASMFLAGS% Del40us.asm
%ASM% %ASMFLAGS% Del450ns.asm
%ASM% %ASMFLAGS% Del512ms.asm
%ASM% %ASMFLAGS% DelWrk.asm
%ASM% %ASMFLAGS% LCD10.asm
%ASM% %ASMFLAGS% LCD8.asm
%ASM% %ASMFLAGS% LCDaddr.asm
%ASM% %ASMFLAGS% LCDclear.asm
%ASM% %ASMFLAGS% LCDinit.asm
%ASM% %ASMFLAGS% LCDinsc.asm
%ASM% %ASMFLAGS% LCDletr.asm
%ASM% %ASMFLAGS% LCDmsg.asm
%ASM% %ASMFLAGS% LCDsc16.asm
%ASM% %ASMFLAGS% LCDsend.asm
%ASM% %ASMFLAGS% LCDshift.asm
%ASM% %ASMFLAGS% LCDsnd.asm
%ASM% %ASMFLAGS% LCDunshf.asm
%ASM% %ASMFLAGS% LCDzero.asm

CD %PROC%
MOVE %THERE%\Del128ms.o %HERE%
MOVE %THERE%\Del1s.o %HERE%
MOVE %THERE%\Del2ms.o %HERE%
MOVE %THERE%\Del256ms.o %HERE%
MOVE %THERE%\Del40us.o %HERE%
MOVE %THERE%\Del450ns.o %HERE%
MOVE %THERE%\Del512ms.o %HERE%
MOVE %THERE%\DelWrk.o %HERE%
MOVE %THERE%\LCD10.o %HERE%
MOVE %THERE%\LCD8.o %HERE%
MOVE %THERE%\LCDaddr.o %HERE%
MOVE %THERE%\LCDclear.o %HERE%
MOVE %THERE%\LCDinit.o %HERE%
MOVE %THERE%\LCDinsc.o %HERE%
MOVE %THERE%\LCDletr.o %HERE%
MOVE %THERE%\LCDmsg.o %HERE%
MOVE %THERE%\LCDsc16.o %HERE%
MOVE %THERE%\LCDsend.o %HERE%
MOVE %THERE%\LCDshift.o %HERE%
MOVE %THERE%\LCDsnd.o %HERE%
MOVE %THERE%\LCDunshf.o %HERE%
MOVE %THERE%\LCDzero.o %HERE%

%LIB% /c LCDlib_%PROC%.lib Del128ms.o Del1s.o Del256ms.o Del2ms.o Del40us.o Del450ns.o Del512ms.o DelWrk.o LCD10.o LCD8.o LCDaddr.o LCDclear.o LCDinit.o LCDinsc.o LCDletr.o LCDmsg.o LCDsc16.o LCDsend.o LCDshift.o LCDsnd.o LCDunshf.o LCDzero.o

DEL %THERE%\Del128ms.lst
DEL %THERE%\Del1s.lst
DEL %THERE%\Del2ms.lst
DEL %THERE%\Del256ms.lst
DEL %THERE%\Del40us.lst
DEL %THERE%\Del450ns.lst
DEL %THERE%\Del512ms.lst
DEL %THERE%\DelWrk.lst
DEL %THERE%\LCD10.lst
DEL %THERE%\LCD8.lst
DEL %THERE%\LCDaddr.lst
DEL %THERE%\LCDclear.lst
DEL %THERE%\LCDinit.lst
DEL %THERE%\LCDinsc.lst
DEL %THERE%\LCDletr.lst
DEL %THERE%\LCDmsg.lst
DEL %THERE%\LCDsc16.lst
DEL %THERE%\LCDsend.lst
DEL %THERE%\LCDshift.lst
DEL %THERE%\LCDsnd.lst
DEL %THERE%\LCDunshf.lst
DEL %THERE%\LCDzero.lst

DEL %THERE%\Del128ms.err
DEL %THERE%\Del1s.err
DEL %THERE%\Del2ms.err
DEL %THERE%\Del256ms.err
DEL %THERE%\Del40us.err
DEL %THERE%\Del450ns.err
DEL %THERE%\Del512ms.err
DEL %THERE%\DelWrk.err
DEL %THERE%\LCD10.err
DEL %THERE%\LCD8.err
DEL %THERE%\LCDaddr.err
DEL %THERE%\LCDclear.err
DEL %THERE%\LCDinit.err
DEL %THERE%\LCDinsc.err
DEL %THERE%\LCDletr.err
DEL %THERE%\LCDmsg.err
DEL %THERE%\LCDsc16.err
DEL %THERE%\LCDsend.err
DEL %THERE%\LCDshift.err
DEL %THERE%\LCDsnd.err
DEL %THERE%\LCDunshf.err
DEL %THERE%\LCDzero.err

DEL %HERE%\Del128ms.o
DEL %HERE%\Del1s.o
DEL %HERE%\Del2ms.o
DEL %HERE%\Del256ms.o
DEL %HERE%\Del40us.o
DEL %HERE%\Del450ns.o
DEL %HERE%\Del512ms.o
DEL %HERE%\DelWrk.o
DEL %HERE%\LCD10.o
DEL %HERE%\LCD8.o
DEL %HERE%\LCDaddr.o
DEL %HERE%\LCDclear.o
DEL %HERE%\LCDinit.o
DEL %HERE%\LCDinsc.o
DEL %HERE%\LCDletr.o
DEL %HERE%\LCDmsg.o
DEL %HERE%\LCDsc16.o
DEL %HERE%\LCDsend.o
DEL %HERE%\LCDshift.o
DEL %HERE%\LCDsnd.o
DEL %HERE%\LCDunshf.o
DEL %HERE%\LCDzero.o

ECHO .
ECHO Build of LCDlib_%PROC%.lib complete.
