		include		"PickleMacs.inc"

	; Provided Routines
		global		LCDclear
	; Required routines
		extern		SendI
		extern		waste
		extern		wastel

		code
; ------------------------------------------------------------------------
	; Clear the LCD
LCDclear:
		LCD16	H'00',H'01'
		call	wastel
		return

		end

