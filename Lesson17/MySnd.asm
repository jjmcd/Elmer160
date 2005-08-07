		title		'LCDsnd - Send a nybble to the LCD'
		subtitle	'Part of the Lesson 17 replacement LCDlib library'
		list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  MySnd
;
;  Sends a nybble to the LCD.  Two entry points are provided, LCDsndI to
;  send a command nybble, LCDsndD to send a data nybble.
;
;**
;  WB8RCR - 6-Jul-05
;  $Revision: 1.7 $ $Date: 2005-08-07 13:40:20-04 $

		include		"LCDMacs.inc"

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
