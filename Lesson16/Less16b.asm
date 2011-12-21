; Less16b.asm
;
;	Simple mainline to demonstrate linking.  Load something
;	into W, call a routine to save it, then clear the W and
;	call the routine to restore it.
;
;	WB8RCR - 16-Nov-04
;	$Revision: 1.4 $ $Date: 2011-12-21 12:46:20-05 $
;===========================================================

		processor	pic16f628a
		include		P16F628A.INC
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BOREN_OFF

		extern		Sub1,Sub2

STARTUP	code
		goto		Start
		code
Start
		movlw		h'3a'
		call		Sub1

		clrw
		call		Sub2

aa		goto		aa

		end
