;	Less17a.asm - Mainline to test sending nybble to LCD
;
;	$Revision: 1.2 $ $Date: 2011-12-21 21:11:42-05 $
			include		P16F628A.INC
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _BOREN_OFF
			extern		LCDinit,LCDletr

STARTUP		code
			goto		Start
			code
Start
			call		LCDinit

			movlw		'H'
			call		LCDletr
			movlw		'e'
			call		LCDletr
			movlw		'l'
			call		LCDletr
			movlw		'l'
			call		LCDletr
			movlw		'o'
			call		LCDletr

aa			goto		aa
			end
