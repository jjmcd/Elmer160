		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDzero
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to zero
		code
LCDzero:
		LCD16	H'08',H'00'
		return

		end
