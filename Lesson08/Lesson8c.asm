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
		bcf			PORTB,1		; Try to change PORTB
		bsf			PORTB,1
		banksel		TRISB		; Switch to Bank 1
		errorlevel	-302		; Turn off warning
		bcf			TRISB,1		; Make bit 1 output
		banksel		PORTB		; Back to Bank 0
		errorlevel	+302		; Turn warning back on
		bcf			PORTB,1		; Try to change PORTB again
		bsf			PORTB,1
Loop
		goto		Loop
		end
