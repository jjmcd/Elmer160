; Lesson14d - Read data from EEPROM
;
		processor	pic16f628a
		include		P16F628A.INC

		cblock		H'20'
			Index
			Target
			Location
		endc

		goto		Start
		org			h'80'
Start
		movlw		H'7'
		movwf		Index
		movlw		0
		movwf		Location

Loop
	;  NOTE that the following code is fairly specific to
	;  the PIC16F628A.  On other PICs, the various
	;  EEPROM registers are in different banks.
		movf		Location, W	; Location in EEPROM
		banksel		EEADR		; Select bank for EE regs
		errorlevel	-302
		movwf		EEADR		;
		bsf			EECON1,RD	; Initiate read
		movf		EEDATA,W	; Pick up the data
		banksel		Target
		errorlevel	+302
		movwf		Target		; and store it off
		incf		Location,F	; Point to next EEPROM loc
		decfsz		Index,F		; Count down
		goto		Loop		; Go do next location

		nop
alldud	goto		alldud

		org			H'2100'
		de			H'51'
		de			H'52'
		de			H'53'
		de			H'54'
		de			H'55'
		de			H'56'
		de			H'57'


		end
