		include		"p16f84A.inc"
		include		"LCDMacs.inc"

	; Provided Routines
		global	LCDsndI		; Send a command nybble to the LCD
		global	LCDsndD			; Send data to the LCD
	; Required routines
		extern	Del450ns			; Delay 450 nsec

LCDEN	equ			H'04'		; LCD enable bit number in PORTB
LCDRS	equ			H'40'		; LCD register select bit in PORTB

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
		call	Del450ns		; 450ns
		bcf		PORTB,LCDEN	; clear enable bit
		call	Del450ns		; 450ns
		return
		end
