		include		"PickleMacs.inc"

	; Provided Routines
		global		LCD8		; Set the DDRAM address to eight
	; Required routines
		extern		SendI		; Send a command bybble to the LCD
		extern		waste		; Delay 48 usec
		extern		wastel		; Delay 1.7 msec

		code
; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to eight
LCD8:
		LCD16	H'08',H'08'
		return

		end
