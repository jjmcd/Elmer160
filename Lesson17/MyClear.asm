		title		'LCDclear - Clear the LCD display'
		subtitle	'Part of the Lesson 17 replacement LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  MyClear
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
;  WB8RCR - 3-Aug-05
;  $Revision: 1.8 $ $Date: 2005-08-09 21:03:58-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDclear
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del2ms

MYLIB	code
; ------------------------------------------------------------------------
	; Clear the LCD
LCDclear:
		movlw		LCD_DISP_CLEAR
		call		LCDsend
		call		Del2ms
		return

		end

