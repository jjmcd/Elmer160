		title		'LCDunshf - set the LCD into unshift mode'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDunshf
;
;  Set the LCD to unshift mode.
;
;  This function delays for sets the LCD into normal mode.  In
;  this mode, the DDRAM address is incremented for each
;  character, causing the character to be displayed to the
;  right of the previous character.
;
;  The contents of the W register are ignored.  The contents of
;  the W register are destroyed.
;**
		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDunshf
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

		code
; ------------------------------------------------------------------------
	; Turn off LCD shift mode
LCDunshf:
		LCD16	H'00',H'04'
		call	Del40us		; Leave a little longer wait
		return

		end
