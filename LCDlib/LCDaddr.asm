		title		'LCDaddr - Set the LCD display address'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDaddr
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
;  WB8RCR - 13-Nov-04
;  $Revision: 1.39 $ $Date: 2006-09-25 20:24:26-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDaddr
	; Required routines
		extern		LCDsend
		extern		Del40us

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address
_LCDOV1	udata_ovr
Addr	res			1

LCDLIB	code
LCDaddr:
		iorlw		LCD_SET_DDRAM   ;  OR in command byte
		call		LCDsend	        ;  Send to LCD
		call		Del40us
		return

		end
