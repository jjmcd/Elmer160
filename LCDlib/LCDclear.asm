		title		'LCDclear - Clear the LCD display'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDclear
;
;  Clear the LCD display.
;
;  LCDclear clears the contents of the LCD and
;  sets the DDRAM address to zero.
;
;  The contents of the W register are ignored by
;  this routine.  The contents of the W register
;  are destroyed on exit.
;
;**
		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDclear
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

		code
; ------------------------------------------------------------------------
	; Clear the LCD
LCDclear:
		LCD16		H'00',H'01'
		call		Del2ms
		return

		end

