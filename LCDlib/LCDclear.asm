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
		LCD16	H'00',H'01'
		call	Del2ms
		return

		end

