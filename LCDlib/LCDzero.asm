		include		"PickleMacs.inc"

	; Provided Routines
		global		LCDzero
	; Required routines
		extern		SendI
		extern		waste
		extern		wastel

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to zero
		code
LCDzero:
		LCD16	H'08',H'00'
		return

		end
