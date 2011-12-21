; Less16d.asm
;
;	Demonstrate the use of a library.  Uses LCDlib to
;	display a single character on the LCD.
;
;	WB8RCR - 29-Oct-04
;	$Revision: 1.4 $ $Date: 2011-12-21 13:02:11-05 $
;===========================================================
		processor	pic16f628a
		include		P16F628A.INC
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BOREN_OFF

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
