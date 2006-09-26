		title		'LCD10 - Set the LCD DDRAM address to 10(hex)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCD10
;
;  Set the LCD DDRAM address to 10(hex).
;
;  This function sets the DDRAM address of the LCD
;  to 16.  The DDRAM address determines where in the LCD
;  memory the next character will be displayed.
;
;  Setting the DDRAM address to 8 causes the next
;  character to appear at the right-hand side of
;  an 16 character display.  This is useful for
;  scrolling characters across the display from
;  right to left.
;
;  The contents of the W register are ignored by
;  this routine.  The contents of the W register
;  are destroyed on exit.
;
;**
;  WB8RCR - 24-Sep-04
;  $Revision: 1.39 $ $Date: 2006-09-25 20:25:24-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCD10		; Set the DDRAM address to sixteen
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us

LCDLIB	code
; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to sixteen
LCD10:
		movlw	    LCD_SET_DDRAM | H'10'
		call	    LCDsend
		call		Del40us
		return

		end
