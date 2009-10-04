: Batch file to assemble Lesson 21 apps
:
SET PROC=%1%
SET MPDIR=I:\USB\Microchip\MPASM Suite\
SET LCDDIR=H:\PIC\Lesson21\compare\760\lcdlib\
SET ASM="%MPDIR%MPASMWIN.exe"
SET LIB="%MPDIR%mplib.exe"
SET LINK="%MPDIR%mplink.exe"
SET HEX="%MPDIR%MP2HEX.exe"
SET ASMFLAGS=/q+ /p16F%PROC%
: Create the library of subroutines for all programs
%ASM% %ASMFLAGS% "ConvBCD2.asm" /l"ConvBCD2_%PROC%.lst" /e"ConvBCD2_%PROC%.err" /o"ConvBCD2_%PROC%.o"
%ASM% %ASMFLAGS% "Disp16.asm" /l"Disp16_%PROC%.lst" /e"Disp16_%PROC%.err" /o"Disp16_%PROC%.o"
%ASM% %ASMFLAGS% "InitTMR0.asm" /l"InitTMR0_%PROC%.lst" /e"InitTMR0_%PROC%.err" /o"InitTMR0_%PROC%.o"
%ASM% %ASMFLAGS% "RestCnt.asm" /l"RestCnt_%PROC%.lst" /e"RestCnt_%PROC%.err" /o"RestCnt_%PROC%.o"
%LIB% /c L21_%PROC%.lib "ConvBCD2_%PROC%.o" "Disp16_%PROC%.o" "InitTMR0_%PROC%.o" "RestCnt_%PROC%.o"
: Create L21a
%ASM% %ASMFLAGS% "ISRa.asm" /l"ISRa_%PROC%.lst" /e"ISRa_%PROC%.err" /o"ISRa_%PROC%.o"
%ASM% %ASMFLAGS% "L21a.asm" /l"L21a_%PROC%.lst" /e"L21a_%PROC%.err" /o"L21a_%PROC%.o"
: %LINK% "Less21-F%PROC%.lkr" ISRa_%PROC%.o L21a_%PROC%.o L21_%PROC%.lib "%LCDDIR%LCDlib_%PROC%.lib" /z__MPLAB_BUILD=1 /o"L21a_%PROC%.cof" /M"L21a_%PROC%.map" /W
%LINK% "Less21-F%PROC%.lkr" ISRa_%PROC%.o L21a_%PROC%.o L21_%PROC%.lib "%LCDDIR%LCDlib_%PROC%.lib" /o"L21a_%PROC%.cof" /M"L21a_%PROC%.map" /W
%HEX% "L21a_%PROC%.cof"
: Create L21b
%ASM% %ASMFLAGS% "SaveCntB.asm" /l"SaveCntB_%PROC%.lst" /e"SaveCntB_%PROC%.err" /o"SaveCntB_%PROC%.o"
%ASM% %ASMFLAGS% "L21b.asm" /l"L21b_%PROC%.lst" /e"L21b_%PROC%.err" /o"L21b_%PROC%.o"
:%LINK% "Less21-F%PROC%.lkr" ISRa_%PROC%.o SaveCntB_%PROC%.o L21b_%PROC%.o L21_%PROC%.lib "%LCDDIR%LCDlib_%PROC%.lib" /z__MPLAB_BUILD=1 /o"L21b_%PROC%.cof" /M"L21b_%PROC%.map" /W
%LINK% "Less21-F%PROC%.lkr" ISRa_%PROC%.o SaveCntB_%PROC%.o L21b_%PROC%.o L21_%PROC%.lib "%LCDDIR%LCDlib_%PROC%.lib" /o"L21b_%PROC%.cof" /M"L21b_%PROC%.map" /W
%HEX% "L21b_%PROC%.cof"
: Create L21c
%ASM% %ASMFLAGS% "SaveCntC.asm" /l"SaveCntC_%PROC%.lst" /e"SaveCntC_%PROC%.err" /o"SaveCntC_%PROC%.o"
%ASM% %ASMFLAGS% "ISRc.asm" /l"ISRc_%PROC%.lst" /e"ISRc_%PROC%.err" /o"ISRc_%PROC%.o"
%ASM% %ASMFLAGS% "L21c.asm" /l"L21c_%PROC%.lst" /e"L21c_%PROC%.err" /o"L21c_%PROC%.o"
: %ASM% %ASMFLAGS% ".asm" /l"_%PROC%.lst" /e"_%PROC%.err" /o"_%PROC%.o"
: %LINK% "Less21-F%PROC%.lkr" SaveCntC_%PROC%.o ISRc_%PROC%.o L21c_%PROC%.o L21_%PROC%.lib "%LCDDIR%LCDlib_%PROC%.lib" /z__MPLAB_BUILD=1 /o"L21c_%PROC%.cof" /M"L21c_%PROC%.map" /W
%LINK% "Less21-F%PROC%.lkr" SaveCntC_%PROC%.o ISRc_%PROC%.o L21c_%PROC%.o L21_%PROC%.lib "%LCDDIR%LCDlib_%PROC%.lib" /o"L21c_%PROC%.cof" /M"L21c_%PROC%.map" /W
%HEX% "L21c_%PROC%.cof"
