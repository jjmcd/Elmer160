;	Less17c.asm - Mainline to test sending letters to LCD
;
;	JJMcD - 2005-03-19
;	$Revision: 1.1 $ $Date: 2005-03-19 09:50:58-04 $
			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
			extern		LCDinit,LCDletr

STARTUP		code
			goto		Start
			code
Start
			call		LCDinit

			movlw		'Q'
			call		LCDletr
			movlw		'R'
			call		LCDletr
			movlw		'P'
			call		LCDletr

aa			goto		aa
			end
