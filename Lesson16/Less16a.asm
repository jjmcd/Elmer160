; Less16a.asm
;
;	Simple mainline to demonstrate linking.  Simply
;	calls a subroutine and twiddles a GPR location.
;
;	WB8RCR - 29-Oct-04
;	$Revision: 1.3 $ $Date: 2004-11-16 10:04:28-05 $
;===========================================================

		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

;	Need to define the external entry point we require so that
;	the assembler doesn't complain it's undefined
		extern		aSub

;	Section of data in GP registers
		udata
var1	res			1

;	Startup code located where the PIC goes at reset
STARTUP	code
		goto		Start

;	Main part ofthe code wherever the linker cares to put it
		code
Start
		movlw		h'17'	; Put something in the W register
		call		aSub	; Go to work on it
		movwf		var1	; Save off the result

aa		goto		aa
		end
