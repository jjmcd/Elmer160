; Less16c.asm
;
;	Simple mainline to demonstrate overlaid data.  Simply
;	calls two subroutines over and over.
;
;	WB8RCR - 18-Nov-04
;	$Revision: 1.3 $ $Date: 2011-12-21 162:51:14-05 $
;===========================================================
		processor	pic16f628a
		include		P16F628A.INC
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON	 & _LVP_OFF & _BOREN_OFF

		extern		Sub1,Sub2

STARTUP	code
		goto		Start
		code
Start
		call		Sub1
		call		Sub2
		goto		Start
		end
