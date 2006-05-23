			title		'SaveCntB - Save counter in EEPROM'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		p16f84a.inc

;------------------------------------------------------------------------
;**
;	SaveCnt
;
;	Save the counter in EEPROM - non-interrupt version
;
;**
;	WB8RCR - 23-May-06
;	$Revision: 1.1 $ $State: Exp $ $Date: 2006-05-23 14:30:28-04 $

			global		SaveCnt
			extern		binary

MYLIB		code
SaveCnt:
			bcf			INTCON,GIE		; Turn off interrupts

			movlw		H'10'			; Set address in EEPROM
			movwf		EEADR			; to be written
			movf		binary,W		; Set data to be written
			movwf		EEDATA			;

			errorlevel	-302
			banksel		EECON1			; Bank 1
			bsf			EECON1,WREN		; Enable write
			movlw		H'55'			; This sequence is
			movwf		EECON2			; required before the
			movlw		H'AA'			; EEPROM may be written
			movwf		EECON2			;
			bsf			EECON1,WR		; Start write
Wait1		btfsc		EECON1,WR		; Wait for write complete
			goto		Wait1

		; Now next byte
			errorlevel	+302
			banksel		EEADR
			incf		EEADR,F			; Next byte to be written
			movf		binary+1,W		; Set data to be written
			movwf		EEDATA			;

			errorlevel	-302
			banksel		EECON1			; Bank 1
			movlw		H'55'			; This sequence is
			movwf		EECON2			; required before the
			movlw		H'AA'			; EEPROM may be written
			movwf		EECON2			;
			bsf			EECON1,WR		; Start write
Wait2		btfsc		EECON1,WR		; Wait for write complete
			goto		Wait2

			bcf			EECON1,WREN		; Disable write
			errorlevel	+302
			banksel		EEADR			; Back to bank 0
			bsf			INTCON,GIE		; Turn interrupts back on

			return
			end
