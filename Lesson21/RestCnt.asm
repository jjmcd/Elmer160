			title		'RestCnt - Restore counter from EEPROM'
			subtitle	'Part of Lesson 21 on multiple processors'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc
			include		EEPROM.inc

;------------------------------------------------------------------------
;**
;	RestCnt
;
;	Restore the counter from EEPROM
;
;**
;	WB8RCR - 23-May-06
;	$Revision: 1.14 $ $State: Exp $ $Date: 2007-11-19 10:43:57-05 $

			errorlevel	-302
			global		RestCnt
			extern		binary,LEDflg

;	Macros to do bank selection based on processor.  Note that these aren't
;	general-purpose macros.  Each depends on what went before, so they are only
;	applicable in this specific routine.

SelectAddress	MACRO
		IF ( PROC != 84 )
			banksel		EEADR
		ENDIF
			ENDM
SelectControl	MACRO
		IF ( PROC == 84) || ( PROC == 88 ) || ( PROC == 819 )
			banksel		EECON1
		ENDIF
			ENDM
SelectData		MACRO
		IF ( PROC == 84) || ( PROC == 88 ) || ( PROC == 819 )
			banksel		EEDATA
		ENDIF
			ENDM
SelectBinary	MACRO
		IF ( PROC != 84 )
			banksel		binary
		ENDIF
			ENDM

MYLIB		code
RestCnt:
			movlw		H'0a'			; Middle LED on
			movwf		PORTB
			movwf		LEDflg
			SelectAddress
			movlw		SAVADR			; Store the EEPROM address
			movwf		EEADR			; to the address register
			SelectControl
		IFDEF EEPGD						; For processors that support
			bcf			EECON1,EEPGD	; it, ensure EEPROM not FLASH
		ENDIF
			bsf			EECON1,RD		; and command a read
			SelectData
			movf		EEDATA,W		; Pick up the value from EEPROM
			SelectBinary
			movwf		binary			; And save it in binary
			SelectAddress
			incf		EEADR,F			; Now point to next EEPROM location
			SelectControl
			bsf			EECON1,RD		; again command a read
			SelectData
			movf		EEDATA,W		; grab the high byte
			SelectBinary
			movwf		binary+1		; and store in high byte of result
			
			movlw		H'0e'				; All LEDs off
			movwf		LEDflg
			movwf		PORTB

			return
			end
