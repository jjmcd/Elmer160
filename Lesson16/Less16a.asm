; Less16a.asm
;
;	Simple mainline to demonstrate linking.  Simply
;	calls a subroutine and twiddles a GPR location.
;
;	WB8RCR - 29-Oct-04
;	$Revision: 1.4 $ $Date: 2011-12-21 12:39:23-05 $
;===========================================================

		processor	pic16f628a
		include		P16F628A.INC
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BOREN_OFF

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
