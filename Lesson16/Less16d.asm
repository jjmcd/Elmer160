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
