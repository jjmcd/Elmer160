; Less16d.asm
;
;	Demonstrate the use of a library.  Uses LCDlib to
;	display a single character on the LCD.
;
;	WB8RCR - 29-Oct-04
;	$Revision: 1.3 $ $Date: 2005-01-20 17:10:30-05 $
;===========================================================
		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

		extern		LCDinit,LCDletr

STARTUP	code
		goto		Start
		code
Start
	; Initialize the LCD
		call		LCDinit

	; Put something on the LCD
		movlw		'2'
		call		LCDletr

aa		goto		aa
		end
