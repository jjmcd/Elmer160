		title		'LCDaddr - Set the LCD display address'
		subtitle	'Part of the Lesson 17 replacement LCDlib library'
		list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  MyAddr
;
;  Set the LCD display address.
;
;  This function sets the display address for the next character
;  to be displayed on the LCD.  The caller passes in the address
;  in the W register.
;
;  For the PIC-EL 16 character display, the ninth character is
;  at address 32 (decimal).  For most other 2 line displays, the
;  first character of the second line is at address 64.
;
;  The contents of the W register are destroyed.
;
;**
;  WB8RCR - 3-Aug-05
;  $Revision: 1.8 $ $Date: 2005-08-09 21:03:56-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDaddr
	; Required routines
		extern		LCDsend
		extern		Del2ms

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address
MYLIB	code
LCDaddr:
		iorlw		LCD_SET_DDRAM ; OR in command byte
		call		LCDsend		; Send to LCD
		call		Del2ms		; Delay for processing
		return

		end
