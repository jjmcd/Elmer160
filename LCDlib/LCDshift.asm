		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDshift
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

		code
; ------------------------------------------------------------------------
	; Set the LCD to shift mode
LCDshift:
		LCD16	H'00',H'07'
		call	Del40us		; Leave a little longer wait
		return

		end
