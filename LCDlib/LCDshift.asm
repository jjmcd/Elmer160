		include		"PickleMacs.inc"

	; Provided Routines
		global		LCDshift
	; Required routines
		extern		SendI
		extern		waste
		extern		wastel

		code
; ------------------------------------------------------------------------
	; Set the LCD to shift mode
LCDshift:
		LCD16	H'00',H'07'
		call	waste		; Leave a little longer wait
		return

		end
