: Batch file to assemble Regression_Seiko
:
SET PROC=%1%
SET MPDIR=I:\USB\Microchip\MPASM Suite\
SET LCDDIR=H:\PIC\Lesson21\compare\760\lcdlib\
SET ASM="%MPDIR%MPASMWIN.exe"
SET LIB="%MPDIR%mplib.exe"
SET LINK="%MPDIR%mplink.exe"
SET HEX="%MPDIR%MP2HEX.exe"
SET ASMFLAGS=/q+ /p16F%PROC%
:
: Regression-Seiko
:
%ASM% %ASMFLAGS% "Regression-Seiko.asm" /l"Regression-Seiko_%PROC%.lst" /e"Regression-Seiko_%PROC%.err" /o"Regression-Seiko_%PROC%.o"
%LINK% "Regression_%PROC%.lkr" Regression-Seiko_%PROC%.o LCDlib_%PROC%.lib /oRegression-Seiko_%PROC%.cof /MRegression-Seiko_%PROC%.map /W
%HEX% Regression-Seiko_%PROC%.cof
:
: Regression-44100
:
%ASM% %ASMFLAGS% "Regression-44100.asm" /l"Regression-44100_%PROC%.lst" /e"Regression-44100_%PROC%.err" /o"Regression-44100_%PROC%.o"
%LINK% "Regression_%PROC%.lkr" Regression-44100_%PROC%.o LCDlib_%PROC%.lib /oRegression-44100_%PROC%.cof /MRegression-44100_%PROC%.map /W
%HEX% Regression-44100_%PROC%.cof
:
: Regression-2x20
:
%ASM% %ASMFLAGS% "Regression2x20.asm" /l"Regression2x20_%PROC%.lst" /e"Regression2x20_%PROC%.err" /o"Regression2x20_%PROC%.o"
%LINK% "Regression_%PROC%.lkr" Regression2x20_%PROC%.o LCDlib_%PROC%.lib /oRegression2x20_%PROC%.cof /MRegression2x20_%PROC%.map /W
%HEX% Regression2x20_%PROC%.cof
:
: Regression
:
%ASM% %ASMFLAGS% "Regression.asm" /l"Regression_%PROC%.lst" /e"Regression_%PROC%.err" /o"Regression_%PROC%.o"
%LINK% "Regression_%PROC%.lkr" Regression_%PROC%.o LCDlib_%PROC%.lib /oRegression_%PROC%.cof /MRegression_%PROC%.map /W
%HEX% Regression_%PROC%.cof
