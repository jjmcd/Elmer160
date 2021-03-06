		title		'LCDshift - set the LCD into shift mode'
		subtitle	'Part of the Lesson 17 replacement LCDlib library'
		list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  MyShift
;
;  Set the LCD to shift mode.
;
;  This function delays for sets the LCD into shift mode.  In
;  this mode, the display is shifted left each time a character
;  is written to the display.  Successive characters are written
;  to the same LCD location.
;
;  The contents of the W register are ignored.  The contents of
;  the W register are destroyed.
;**
;  WB8RCR - 3-Aug-05
;  $Revision: 1.8 $ $Date: 2005-08-09 21:03:58-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDshift
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us

MYLIB	code
; ------------------------------------------------------------------------
	; Set the LCD to shift mode
LCDshift:
		movlw	LCD_ENTRY_MODE | LCD_DISP_SHIFT | LCD_DIS_INCR
		call	LCDsend
		call	Del40us		; Leave a little longer wait
		return

		end
