; Less16b.asm
;
;	Simple mainline to demonstrate linking.  Load something
;	into W, call a routine to save it, then clear the W and
;	call the routine to restore it.
;
;	WB8RCR - 16-Nov-04
;	$Revision: 1.3 $ $Date: 2004-11-16 11:30:42-05 $
;===========================================================

		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

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
