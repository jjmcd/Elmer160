;	Less17d.asm - Mainline to test sending letters to LCD
;
;	JJMcD - 2005-03-19
;	$Revision: 1.1 $ $Date: 2005-03-19 11:17:00-04 $
			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
			extern		LCDinit,LCDletr

STARTUP		code
			goto		Start
			code
Start
			call		LCDinit

			movlw		'2'
			call		LCDletr
			movlw		'N'
			call		LCDletr
			movlw		'2'
			call		LCDletr
			movlw		'/'
			call		LCDletr
			movlw		'4'
			call		LCDletr
			movlw		'0'
			call		LCDletr

aa			goto		aa
			end
