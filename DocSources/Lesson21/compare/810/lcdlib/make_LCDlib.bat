: Batch file to assemble LCD library
:
SET PROC=%1%
SET MPDIR=I:\Usb\MP810\MPASM Suite\
SET LCDDIR=H:\PIC\Lesson21\compare\810\lcdlib\
SET ASM="%MPDIR%MPASMWIN.exe"
SET LIB="%MPDIR%mplib.exe"
SET ASMFLAGS=/q+ /p16F%PROC%

%ASM% %ASMFLAGS% "LCDinit.asm" /l"LCDinit_%PROC%.lst" /e"LCDinit_%PROC%.err" /o"LCDinit_%PROC%.o"
%ASM% %ASMFLAGS% "LCDletr.asm" /l"LCDletr_%PROC%.lst" /e"LCDletr_%PROC%.err" /o"LCDletr_%PROC%.o"
%ASM% %ASMFLAGS% "LCDsend.asm" /l"LCDsend_%PROC%.lst" /e"LCDsend_%PROC%.err" /o"LCDsend_%PROC%.o"
%ASM% %ASMFLAGS% "LCDsnd.asm" /l"LCDsnd_%PROC%.lst" /e"LCDsnd_%PROC%.err" /o"LCDsnd_%PROC%.o"
%ASM% %ASMFLAGS% "LCDclear.asm" /l"LCDclear_%PROC%.lst" /e"LCDclear_%PROC%.err" /o"LCDclear_%PROC%.o"
%ASM% %ASMFLAGS% "LCDzero.asm" /l"LCDzero_%PROC%.lst" /e"LCDzero_%PROC%.err" /o"LCDzero_%PROC%.o"
%ASM% %ASMFLAGS% "LCDaddr.asm" /l"LCDaddr_%PROC%.lst" /e"LCDaddr_%PROC%.err" /o"LCDaddr_%PROC%.o"
%ASM% %ASMFLAGS% "LCDinsc.asm" /l"LCDinsc_%PROC%.lst" /e"LCDinsc_%PROC%.err" /o"LCDinsc_%PROC%.o"
%ASM% %ASMFLAGS% "LCDshift.asm" /l"LCDshift_%PROC%.lst" /e"LCDshift_%PROC%.err" /o"LCDshift_%PROC%.o"
%ASM% %ASMFLAGS% "LCDsc16.asm" /l"LCDsc16_%PROC%.lst" /e"LCDsc16_%PROC%.err" /o"LCDsc16_%PROC%.o"
%ASM% %ASMFLAGS% "LCD8.asm" /l"LCD8_%PROC%.lst" /e"LCD8_%PROC%.err" /o"LCD8_%PROC%.o"
%ASM% %ASMFLAGS% "LCDunshf.asm" /l"LCDunshf_%PROC%.lst" /e"LCDunshf_%PROC%.err" /o"LCDunshf_%PROC%.o"
%ASM% %ASMFLAGS% "LCDmsg.asm" /l"LCDmsg_%PROC%.lst" /e"LCDmsg_%PROC%.err" /o"LCDmsg_%PROC%.o"
%ASM% %ASMFLAGS% "Del450ns.asm" /l"Del450ns_%PROC%.lst" /e"Del450ns_%PROC%.err" /o"Del450ns_%PROC%.o"
%ASM% %ASMFLAGS% "Del2ms.asm" /l"Del2ms_%PROC%.lst" /e"Del2ms_%PROC%.err" /o"Del2ms_%PROC%.o"
%ASM% %ASMFLAGS% "Del40us.asm" /l"Del40us_%PROC%.lst" /e"Del40us_%PROC%.err" /o"Del40us_%PROC%.o"
%ASM% %ASMFLAGS% "Del1s.asm" /l"Del1s_%PROC%.lst" /e"Del1s_%PROC%.err" /o"Del1s_%PROC%.o"
%ASM% %ASMFLAGS% "Del512ms.asm" /l"Del512ms_%PROC%.lst" /e"Del512ms_%PROC%.err" /o"Del512ms_%PROC%.o"
%ASM% %ASMFLAGS% "Del256ms.asm" /l"Del256ms_%PROC%.lst" /e"Del256ms_%PROC%.err" /o"Del256ms_%PROC%.o"
%ASM% %ASMFLAGS% "Del128ms.asm" /l"Del128ms_%PROC%.lst" /e"Del128ms_%PROC%.err" /o"Del128ms_%PROC%.o"

%LIB% /c LCDlib_%PROC%.lib LCDinit_%PROC%.o LCDletr_%PROC%.o LCDsend_%PROC%.o LCDsnd_%PROC%.o LCDclear_%PROC%.o LCDzero_%PROC%.o LCDaddr_%PROC%.o LCDinsc_%PROC%.o LCDshift_%PROC%.o LCDsc16_%PROC%.o LCD8_%PROC%.o LCDunshf_%PROC%.o LCDmsg_%PROC%.o Del450ns_%PROC%.o Del2ms_%PROC%.o Del40us_%PROC%.o Del1s_%PROC%.o Del512ms_%PROC%.o Del256ms_%PROC%.o Del128ms_%PROC%.o