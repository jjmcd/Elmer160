;	Less17e6.asm - Subroutine to clear the display
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2005-04-26 10:59:36-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDclear
	; Required routines
		extern		LCDsend		; Send command to LCD
		extern		Del40us
		extern		Del2ms

LCDLIB	code
; ------------------------------------------------------------------------
	; Clear the LCD
LCDclear:
		movlw		LCD_DISP_CLEAR
		call		LCDsend
		call		Del2ms
		return

		end
