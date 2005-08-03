		include		"LCDMacs.inc"
;**
;  MySnd
;
;  Sends a nybble to the LCD.  Two entry points are provided, LCDsndI to
;  send a command nybble, LCDsndD to send a data nybble.
;
;**
;  WB8RCR - 6-Jul-05
;  $Revision: 1.1 $ $Date: 2005-07-06 13:26:42-04 $

	; Provided Routines
		global	LCDsndI		; Send a command nybble to the LCD
		global	LCDsndD		; Send data to the LCD
	; Required routines
		extern	Del450ns	; Delay 450 nsec


MYLIB	code
; ------------------------------------------------------------------------
	; Send data to the LCD
LCDsndD:
		andlw	00fh		; only use low order 4 bits
		iorlw	LCDRS		; Select register
		goto	Send		; Skip over LCDsndI

; ------------------------------------------------------------------------
	; Send a command nybble to the LCD
LCDsndI:
		andlw	00fh		; only use low order 4 bits
							; FALL THROUGH to SendLCD

; ------------------------------------------------------------------------
	; Actually move the data
Send:
		movwf	LCDPORT		; Send data to LCDPORT
		iorlw	LCDEN		; Turn on enable bit
		movwf	LCDPORT
		call	Del450ns	; 450ns
		xorlw	LCDEN
		movwf	LCDPORT
		call	Del450ns	; 450ns
		return
		end
