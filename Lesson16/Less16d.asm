		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

		extern		LCDinit,LCDletr

STARTUP	code
		goto		Start
		code
Start
	; Make PORTB pins be outputs
		errorlevel	-302
		banksel		TRISB
		clrf		TRISB
		banksel		PORTB
		errorlevel	+302

	; Initialize the LCD
		call		LCDinit

	; Put something on the LCD
		movlw		'2'
		call		LCDletr

aa		goto		aa
		end
