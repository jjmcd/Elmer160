; Lesson 7x - single byte decimal conversion

		processor	pic16f84a
		include		"p16f84a.inc"
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'30'
			Value			; Number to convert
			Temp			; Storage for Convert
			Digit1			; High order digit
			Digit2			; Middle digit
			Digit3			; Low digit
		endc

		goto		Start

;	Convert binary in Value to 3 digits
Convert
		clrf		Digit1			; Clear out the locations
		clrf		Digit2			; where the digits of the
		clrf		Digit3			; display we be stored
		movf		Value,W			; Pick up the result and
		movwf		Temp			; copy it to a work area
Cnvt_b	; 0 <= Temp <= 255
		movlw		D'100'			; Subtract 100 from Temp
		bsf			STATUS,C		;
		subwf		Temp,W			; 
		btfss		STATUS,C		; Was there a borrow?
		goto		Cnvt_c			; Yes, go to next digit
		incf		Digit1,F		; No, increment display
		movwf		Temp			; and save off difference
		goto		Cnvt_b			; Go back and do it again
Cnvt_c	; 0 <= Temp <= 100
		movlw		D'10'			; Subtract 10 from Temp
		bsf			STATUS,C		;
		subwf		Temp,W			;
		btfss		STATUS,C		; Was there a borrow?
		goto		Cnvt_d			; Yes, go on to next digit
		incf		Digit2,F		; No, increment display
		movwf		Temp			; and save off difference
		goto		Cnvt_c			; Go back and do it again
Cnvt_d	; 0 <= Temp <= 10
		movlw		D'1'			; Subtract 1 from Temp
		bsf			STATUS,C		;
		subwf		Temp,W			;
		btfss		STATUS,C		; Was there a borrow?
		goto		Cnvt_e			; Yes, all done
		incf		Digit3,F		; No, increment display
		movwf		Temp			; and save off difference
		goto		Cnvt_d			; Go back and do it again
Cnvt_e
		return

Start
		movlw		D'5'
		movwf		Value
		call		Convert

		movlw		D'12'
		movwf		Value
		call		Convert

		movlw		D'123'
		movwf		Value
		call		Convert

Loop
		goto		Loop
		end
