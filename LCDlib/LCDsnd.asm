		include		"LCDMacs.inc"
;**
;  LCDsnd
;
;  Sends a nybble to the LCD.  Two entry points are provided, LCDsndI to
;  send a command nybble, LCDsndD to send a data nybble.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.20 $ $Date: 2005-01-23 11:09:50-05 $

	; Provided Routines
		global	LCDsndI		; Send a command nybble to the LCD
		global	LCDsndD		; Send data to the LCD
	; Required routines
;		extern	Del450ns	; Delay 450 nsec

LCDEN	equ			H'04'	; LCD enable bit number in PORTB
LCDRS	equ			H'40'	; LCD register select bit in PORTB

		code
; ------------------------------------------------------------------------
	; Send data to the LCD
LCDsndD:
		andlw	00fh		; only use low order 4 bits
		iorlw	LCDRS		; Select register
		goto	$+2			; Skip over LCDsndI

; ------------------------------------------------------------------------
	; Send a command nybble to the LCD
LCDsndI:
		andlw	00fh		; only use low order 4 bits
							; FALL THROUGH to SendLCD

; ------------------------------------------------------------------------
	; Actually move the data
		movwf	PORTB		; Send data to PORTB
		bsf		PORTB,LCDEN	; turn on enable bit
;		call	Del450ns	; 450ns
		nop
		bcf		PORTB,LCDEN	; clear enable bit
;		call	Del450ns	; 450ns
		nop
		return
		end
