;	Lesson8a.asm - 
;	15-Jan-2003
;
		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'3d'
			Bank0
			Bank1
		endc
		goto		Start

;	Mainline starts here
Start
		movf		PORTB,W		; Read PORTB
		movwf		Bank0		; Save the value
		banksel		TRISB		; Switch to Bank 1
		errorlevel	-302		; Turn off warning
		movf		TRISB,W		; Read PORTB again
		movwf		Bank1		; Save the value again
		banksel		PORTB		; Back to Bank 0
		errorlevel	+302		; Turn warning back on
Loop
		goto		Loop
		end
