		include		"LCDMacs.inc"

	; Provided Routines
		global		LCD10		; Set the DDRAM address to sixteen
	; Required routines
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.7 msec

		code
; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to sixteen
LCD10:
		LCD16	H'09',H'00'
		return

		end
