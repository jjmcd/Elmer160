;	Less17c.asm - Mainline to test sending letters to LCD
;
;	JJMcD - 2005-03-19
;	$Revision: 1.1 $ $Date: 2011-12-21 21:38:58-05 $
			include		P16F628A.INC
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _BOREN_OFF
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
