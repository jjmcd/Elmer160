; Less16c.asm
;
;	Simple mainline to demonstrate overlaid data.  Simply
;	calls two subroutines over and over.
;
;	WB8RCR - 18-Nov-04
;	$Revision: 1.2 $ $Date: 2005-01-20 16:31:46-05 $
;===========================================================
		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

		extern		Sub1,Sub2

STARTUP	code
		goto		Start
		code
Start
		call		Sub1
		call		Sub2
		goto		Start
		end
