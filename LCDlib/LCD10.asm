		include		"PickleMacs.inc"

	; Provided Routines
		global		LCD10		; Set the DDRAM address to sixteen
	; Required routines
		extern		SendI		; Send a command bybble to the LCD
		extern		waste		; Delay 48 usec
		extern		wastel		; Delay 1.7 msec

		code
; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to sixteen
LCD10:
		LCD16	H'09',H'00'
		return

		end
