		title		'LCDclear - Clear the LCD display'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDclear
;
;  Clear the LCD display.
;
;  LCDclear clears the contents of the LCD and
;  sets the DDRAM address to zero.
;
;  The contents of the W register are ignored by
;  this routine.  The contents of the W register
;  are destroyed on exit.
;
;**
;  WB8RCR - 24-Sep-04
;  $Revision: 1.20 $ $Date: 2005-01-23 11:09:46-05 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDclear
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us
		extern		Del2ms

		code
; ------------------------------------------------------------------------
	; Clear the LCD
LCDclear:
		movlw		LCD_DISP_CLEAR
		call		LCDsend
		call		Del2ms
		return

		end

