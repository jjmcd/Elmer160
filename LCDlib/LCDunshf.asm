		title		'LCDunshf - set the LCD into unshift mode'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDunshf
;
;  Set the LCD to unshift mode.
;
;  This function delays for sets the LCD into normal mode.  In
;  this mode, the DDRAM address is incremented for each
;  character, causing the character to be displayed to the
;  right of the previous character.
;
;  The contents of the W register are ignored.  The contents of
;  the W register are destroyed.
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:22-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDunshf
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us

LCDLIB	code
; ------------------------------------------------------------------------
	; Turn off LCD shift mode
LCDunshf:
		movlw	LCD_ENTRY_MODE | LCD_NO_SHIFT | LCD_DIS_DECR
		call	LCDsend
		call	Del40us		; Leave a little longer wait
		return

		end
