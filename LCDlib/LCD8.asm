		include		"LCDMacs.inc"

	; Provided Routines
		global		LCD8		; Set the DDRAM address to eight
	; Required routines
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.7 msec

		code
; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to eight
LCD8:
		LCD16	H'08',H'08'
		return

		end
