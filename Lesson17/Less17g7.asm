;	Less17g7 - Set the LCD address
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2005-04-26 14:26:48-04 $

		include		"LCDMacs.inc"
	; Provided Routines
		global		LCDaddr
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address
_LCDOV1	udata_ovr
Addr	res			1

LCDLIB	code
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
