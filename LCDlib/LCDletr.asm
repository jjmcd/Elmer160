		title		'LCDletr, LCDdig - Display letter or digit'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDdig,LCDletr
	; Required routines
		extern		LCDsndD
		extern		Del40us

_LCDOV1	udata_ovr
_LCDV01	res			1			; Storage for letter
_LCDV02	res			1			; Storage for high nybble of letter

		code
; ------------------------------------------------------------------------
;**
;  Send a digit to the LCD.
;
;  LCDdig sends a digit to the LCD.  The digit
;  will be entered at the current DDRAM postion.
;  The digit is provided in the lower four bits
;  of the W register.  If the lower four bits of the
;  W register contains a value higher than 9, a
;  trash character will be displayed. The
;  contents of the W register are destroyed on
;  exit.
;
;**
LCDdig:
		andlw		00fh
		iorlw		030h		; note falls thru

; ------------------------------------------------------------------------
;**
;  Send a letter to the LCD.
;
;  LCDletr sends a letter to the LCD.  The letter
;  will be entered at the current DDRAM postion.
;  The letter is provided in the W register. The
;  contents of the W register are destroyed on
;  exit.
;
;**
LCDletr:
		movwf		_LCDV01		; save off the letter
		andlw		0f0h		; high nybble
		movwf		_LCDV02		; Save hi nybble
		rrf			_LCDV02,F	; And move it to the right
		rrf			_LCDV02,F	;
		rrf			_LCDV02,F	;
		rrf			_LCDV02,F	;
		movfw		_LCDV02		; Pick it up
		call		LCDsndD

		movfw		_LCDV01		; get it
		andlw		00fh		; Mask off high stuff
		call		LCDsndD

		call		Del40us		; delay a while
								; Note: Doesn't work without this
		return

		end
