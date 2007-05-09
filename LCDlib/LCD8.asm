		title		'LCD8 - Set the LCD DDRAM address to 8'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCD8
;
;  Set the LCD DDRAM address to 8.
;
;  This function sets the DDRAM address of the LCD
;  to 8.  The DDRAM address determines where in the LCD
;  memory the next character will be displayed.
;
;  Setting the DDRAM address to 8 causes the next
;  character to appear at the right-hand side of
;  an 8 character display.  This is useful for
;  scrolling characters across the display from
;  right to left.
;
;  The contents of the W register are ignored by
;  this routine.  The contents of the W register
;  are destroyed on exit.
;
;**
;  WB8RCR - 24-Sep-04
;  $Revision: 2.0 $ $Date: 2007-05-09 11:17:48-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCD8		; Set the DDRAM address to eight
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us

LCDLIB	code
; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to eight
LCD8:
		movlw	    LCD_SET_DDRAM | H'08'
		call	    LCDsend
		call	    Del40us
		return

		end
