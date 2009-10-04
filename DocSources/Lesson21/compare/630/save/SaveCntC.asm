			title		'SaveCntC - Save counter in EEPROM'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc
			include		EEPROM.inc

;------------------------------------------------------------------------
;**
;	SaveCnt
;
;	Save the counter in EEPROM - interrupt version
;
;**
;	WB8RCR - 23-May-06
;	$Revision: 1.13 $ $State: Exp $ $Date: 2007-05-15 09:42:08-04 $

			global		SaveCnt
			extern		binary, eestate, LEDflg

MYLIB		code
SaveCnt:
	; Routine needs to do different things depending where in the
	; sequence we are called.
	;
	; eestate value of 1 means that we must write the first byte
	; of the value.  3 means that we must write the second value.
	; 5 means to reset eestate to zero.  Any even value is handled
	; by the interrupt handler.

			movlw		HIGH(SaveCnt)	; Setup PCLATH for
			movwf		PCLATH			; table call
			rrf			eestate,W		; Need to check only bits
			andlw		H'03'			; 1 and 2
			addwf		PCL,F			; Jump
			goto		FirstByte		; 1 (0)=First byte
			goto		NextByte		; 3 (1)=Second byte
			goto		Clearit			; 5 (2)=Done
Clearit
			errorlevel	-302
			banksel		IEREG
			bcf			IEREG,EEIE		; Disable EEPROM Interrupt
			banksel		eestate
			errorlevel	+302
			clrf		eestate			; Return to state 0
			movlw		H'0e'			; All LEDs off
			movwf		PORTB
			movwf		LEDflg
			return						;

FirstByte
			movlw		H'06'			; Top LED on
			movwf		PORTB			; to indicate write in 
			movwf		LEDflg			; progress
			errorlevel	-302
			banksel		EECON1			; Check to be sure a write
			btfsc		EECON1,WR		; is not already in progress
			return						; Yes, we'll be back
			movlw		SAVADR			; Set address in EEPROM
			banksel		EEADR
			movwf		EEADR			; to be written
			banksel		binary
			movf		binary,W		; Set data to be written
			banksel		EEDATA
			movwf		EEDATA			;
			goto		ContWrite

NextByte
			banksel		EECON1			; Check for write in
			btfsc		EECON1,WR		; progress
			return
			movlw		SAVADR+1		; Set address in EEPROM
			banksel		EEADR
			movwf		EEADR			; to be written
			banksel		binary
			movf		binary+1,W		; Set data to be written
			banksel		EEDATA
			movwf		EEDATA			;

ContWrite
			;errorlevel	-302
			banksel		EECON1			; Bank 1
			bcf			INTCON,GIE		; Turn off interrupts
			bsf			EECON1,WREN		; Enable write
			movlw		H'55'			; This sequence is
			movwf		EECON2			; required before the
			movlw		H'AA'			; EEPROM may be written
			movwf		EECON2			;
			bsf			EECON1,WR		; Start write
			bsf			IEREG,EEIE		; Enable EEPROM Interrupt
			bsf			INTCON, GIE		; Re-enable interrupts
			errorlevel	+302

			banksel		eestate
			incf		eestate,F		; Ready for next step

			return
			end
