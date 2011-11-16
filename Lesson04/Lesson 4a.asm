; Lesson 4a - PIC Elmer lesson 4
; WB8RCR - 11 Oct 2003

		processor	16f628A
		include		p16f84a.inc
		__config	_HS_OSC & _WDT_OFF & _PWRTE_ON

; Variable Storage

Spot1	equ			H'30'	; First program variable
Spot2	equ			H'31'	; Second program variable

; Program code

Start
		movlw		D'5'	; Place a 5 into Spot1
		movwf		Spot1	;

		movlw		D'2'	; Add a 2 to it and store the
		addwf		Spot1,W	; result in Spot2
		movwf		Spot2	;

		movlw		D'3'	; Subtract a 3 from Spot2 and
		subwf		Spot2,W	; store the result in Spot1
		movwf		Spot1	;

		clrw				; Clear out W and Spot1
		clrf		Spot1	;

		incf		Spot1,F	; Bump up Spot1 twice
		incf		Spot1,F	;

		decf		Spot2,F	; And bump down Spot2
		decf		Spot2,F	;

		nop					; Keep the simulator happy
		end					; And we're done
