			title		'SaveCntB - Save counter in EEPROM'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc
			include		EEPROM.inc

;------------------------------------------------------------------------
;**
;	SaveCnt
;
;	Save the counter in EEPROM - non-interrupt version
;
;**
;	WB8RCR - 23-May-06
;	$Revision: 1.13 $ $State: Exp $ $Date: 2007-05-05 16:20:38-04 $

			global		SaveCnt
			extern		binary,LEDflg

MYLIB		code
SaveCnt:
			movlw		H'06'			; Upper LED on
			movwf		PORTB
			movwf		LEDflg

			errorlevel	-302
			banksel		EECON1
Wait0		btfsc		EECON1,WR		; Be sure no write in progress
			goto		Wait0

			banksel		EEADR

			movlw		SAVADR			; Set address in EEPROM
			movwf		EEADR			; to be written
			banksel		binary
			movf		binary,W		; Set data to be written
			banksel		EEDATA
			movwf		EEDATA			;

			banksel		EECON1			; Bank 1
		IFDEF EEPGD						; For processors that support
			bcf			EECON1,EEPGD	; it, ensure EEPROM not FLASH
		ENDIF
			bcf			INTCON,GIE		; Turn off interrupts
			bsf			EECON1,WREN		; Enable write
			movlw		H'55'			; This sequence is
			movwf		EECON2			; required before the
			movlw		H'AA'			; EEPROM may be written
			movwf		EECON2			;
			bsf			EECON1,WR		; Start write
			bsf			INTCON,GIE		; Turn interrupts back on
Wait1		btfsc		EECON1,WR		; Wait for write complete
			goto		Wait1

		; Now next byte
			banksel		EEADR
			incf		EEADR,F			; Next byte to be written
			banksel		binary
			movf		binary+1,W		; Set data to be written
			banksel		EEDATA
			movwf		EEDATA			;

			banksel		EECON1			; Bank 1
			bcf			INTCON,GIE		; Turn off interrupts
			movlw		H'55'			; This sequence is
			movwf		EECON2			; required before the
			movlw		H'AA'			; EEPROM may be written
			movwf		EECON2			;
			bsf			EECON1,WR		; Start write
			bsf			INTCON,GIE		; Turn interrupts back on
Wait2		btfsc		EECON1,WR		; Wait for write complete
			goto		Wait2

			bcf			EECON1,WREN		; Disable write
			errorlevel	+302
			banksel		0				; Back to bank 0

			movlw		H'0e'			; All LEDs off
			movwf		LEDflg
			movwf		PORTB

			return
			end
