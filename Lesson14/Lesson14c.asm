; Lesson14c - fetch values from table in File Register
;
		processor	pic16f84a
		include		p16f84a.inc

		cblock		H'20'
			D1					; Storage for seven
			D2					; element long table
			D3
			D4
			D5
			D6
			D7
			Index				; Counter in table
			Target				; Result from table
		endc

		goto		Start
		org			h'80'
Start
		movlw		H'51'		; Load up the
		movwf		D1			; table with entries
		movlw		H'52'		; from 81 to 87
		movwf		D2
		movlw		H'53'
		movwf		D3
		movlw		H'54'
		movwf		D4
		movlw		H'55'
		movwf		D5
		movlw		H'56'
		movwf		D6
		movlw		H'57'
		movwf		D7

		movlw		D1			; Point to address of 
		movwf		FSR			; first entry
		movlw		H'7'		; Initialize count of
		movwf		Index		; Entries to read

Loop
		movf		INDF,W		; Get value from the table
		movwf		Target		; and store it
		incf		FSR,F		; Point to next entry
		decfsz		Index,F		; Done?
		goto		Loop		; No, go back and do next

		nop
alldud	goto		alldud

		end
