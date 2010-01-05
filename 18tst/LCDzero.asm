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
;  WB8RCR - 24-Sep-04
;  $Revision: 3.0 $ $Date: 2007-03-25 10:12:29-04 $

		include		"LCDmacs.inc"

	; Provided Routines
		global		LCDzero
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to zero
LCDLIB	code
LCDzero:
		movlw	LCD_SET_DDRAM | H'00'
		call	LCDsend
		call	Del40us
		return

		end
