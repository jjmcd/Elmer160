		title		'LCDzero - Set LCD entry address to zero'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDzero
;
;  Set LCD DDRAM address to zero.
;
;  This function sets the LCD entry address to zero.  This
;  causes the next character to be displayed as the first
;  character on the display.
;
;  The W register is ignored.  The contents of the W
;  register are destroyed.
;**
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
