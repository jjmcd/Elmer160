; Lesson 7c - single byte decimal conversion - refactored

		processor	pic16f84a
		include		"p16f84a.inc"
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'30'
			Value			; Number to convert
			Temp			; Storage for Convert
			DigitNum		; Which digit
			Digit1			; Low order digit
			Digit2			; Middle digit
			Digit3			; High digit
		endc

		goto		Start

;	Table of decades
DecTbl
		addwf		PCL,F
		dt			D'0',D'1',D'10',D'100'

;	Convert binary in Value to 3 digits
Convert
		clrf		Digit1			; Clear out the locations
		clrf		Digit2			; where the digits of the
		clrf		Digit3			; display we be stored
		movf		Value,W			; Pick up the result and
		movwf		Temp			; copy it to a work area
		movlw		D'3'				; We will do digits 3,2,1
		movwf		DigitNum		; (but not 0)

Cnvt_b	; Calculate next digit
		movf		DigitNum,W		; Pick up the digit number
		addlw		Digit1-1		; And add in the start location
		movwf		FSR				; Store in indirect address
		movf		DigitNum,W		; Pick up the digit number
		call		DecTbl			; Get what decade we are doing
		subwf		Temp,W			; Subtract from remainder left
		btfss		STATUS,C		; Was there a borrow?
		goto		Cnvt_c			; Yes, go to next digit
		incf		INDF,F			; No, increment display
		movwf		Temp			; and save off difference
		goto		Cnvt_b			; Go back and do it again
Cnvt_c	; Move on to next digit
		decfsz		DigitNum,F		; Decrement the digit counter
		goto		Cnvt_b			; If not done, do next decade
		return						; Otherwise all done

Start
		movlw		D'5'			; Try a single digit
		movwf		Value
		call		Convert

		movlw		D'12'			; Now try 2 digits
		movwf		Value
		call		Convert

		movlw		D'123'			; Finally, 3 digits
		movwf		Value
		call		Convert

Loop
		goto		Loop
		end
