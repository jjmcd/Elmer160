;	Less17a1 - Replace send nybble code in library
;
;	JJMcD - 2005-03-17
;	$Revision: 1.1 $ $Date: 2005-03-17 09:36:58-04 $
			include		p16f84a.inc

	; Provided Routines
			global		LCDsndI		; Send a command nybble to the LCD
			global		LCDsndD		; Send data to the LCD

LCDEN		equ			H'04'		; LCD enable bit number in PORTB
LCDRS		equ			H'40'		; LCD register select bit in PORTB

			code
; ------------------------------------------------------------------------
	; Send data to the LCD
LCDsndD:
			andlw		00fh		; only use low order 4 bits
			iorlw		LCDRS		; Select register
			goto		$+2			; Skip over LCDsndI

; ------------------------------------------------------------------------
	; Send a command nybble to the LCD
LCDsndI:
			andlw		00fh		; only use low order 4 bits
									; FALL THROUGH to SendLCD

; ------------------------------------------------------------------------
	; Actually move the data
			movwf		PORTB		; Send data to PORTB
			bsf			PORTB,LCDEN	; turn on enable bit
			nop
			bcf			PORTB,LCDEN	; clear enable bit
			nop
			return

			end
