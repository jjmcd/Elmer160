;	Less17b.asm - Mainline to test sending letters to LCD
;
;	$Revision: 1.1 $ $Date: 2005-03-19 09:25:44-04 $
			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
			extern		LCDinit,LCDletr

STARTUP		code
			goto		Start
			code
Start
			call		LCDinit

			movlw		'E'
			call		LCDletr
			movlw		'l'
			call		LCDletr
			movlw		'm'
			call		LCDletr
			movlw		'e'
			call		LCDletr
			movlw		'r'
			call		LCDletr

aa			goto		aa
			end
