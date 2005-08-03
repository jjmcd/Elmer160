		title		'LCDaddr - Set the LCD display address'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

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
;  $Revision: 1.1 $ $Date: 2005-08-03 07:59:34-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDaddr
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address
		udata
Addr	res			1

MYLIB	code
LCDaddr:
		movwf		Addr		; Save off address
		swapf		Addr,W		; Will send high byte first
		iorlw		h'08'		; Set command bit on
		call		LCDsndI		; Send high byte to LCD
		call		Del40us		; 40us

		movf		Addr,W		; Grab the low byte
		call		LCDsndI		; Send to LCD
		call		Del2ms		; 4.1ms
		return

		end
