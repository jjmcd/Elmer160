;	Lesson8a.asm - 
;	15-Jan-2003
;
		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'3d'
			Count
		endc
PB1		equ			D'4'

		goto		Start


;	Mainline starts here
Start
		banksel		TRISA
		bcf			TRISA,0
		banksel		PORTA

TestPB1d
		btfsc		PORTA,PB1	; PB1 down?
		goto		TestPB1d	; No, wait for press
TestPB1u
		btfss		PORTA,PB1	; PB1 up?
		goto		TestPB1u	; No, wait for release

		incf		Count,F		; Add button press
		goto		TestPB1d	; and go test again

Loop
		goto		Loop
		end
