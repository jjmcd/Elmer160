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
