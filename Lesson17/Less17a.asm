;	Less17a.asm - Mainline to test sending nybble to LCD
;
;	$Revision: 1.1 $ $Date: 2005-03-17 09:39:48-04 $
			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
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
