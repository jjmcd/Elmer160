;	Less17g4 - Initialize the LCD
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2005-04-26 14:26:46-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDinit		; Initialize the LCD
	; Required routines
		extern		LCDsend
		extern		Del2ms		; Delay 1.8 msec

		udata
Count	res			1			; Storage for loop counter

		code
; ------------------------------------------------------------------------
	; Initialize the LCD
LCDinit:
	; Initialize the LCD to 4 bits
	;
	; Set the ports in case the user has forgotten
		movlw		H'80'		; Turn off low 7 bits
		errorlevel	-302		; Suppress message
		banksel		TRISB		; Now set the low 7 bits of
		andwf		TRISB,F		; PORTB to outputs
		banksel		PORTB		; Back to bank zero and
		errorlevel	+302		; re-enable the error message

	; First, need to wait a long time after power up to
	; allow time for 44780 to get it's act together
		movlw		H'20'		; Need >15.1ms after 4.5V
		movwf		Count		; we will wait 65ms (after 2V
		call		Del2ms		; in the case of LF parts)
		decfsz		Count,F		;
		goto		$-2

	; Initialization begins with sending 0x03 3 times followed
	; by a 0x02 to define 4 bit data
		movlw		H'33'
		call		LCDsend
		movlw		H'32'
		call		LCDsend

	; Now set up the display the way we want it
		movlw		LCD_FUN_SET | LCD_DL_4 | LCD_2_LINE | LCD_5X7_FONT
		call		LCDsend

	;	Initialize doesn't clear the memory, so do it now
		movlw		LCD_DISP_CLEAR	; Display clear
		call		LCDsend

	; Set display to no shift
		movlw		LCD_ENTRY_MODE | LCD_NO_SHIFT | LCD_DIS_INCR
		call		LCDsend

	; Turn on display, cursor, and cursor blinking
		movlw		LCD_DISPLAY | LCD_DISP_ON | LCD_CURS_ON | LCD_BLINK_ON
		call		LCDsend

		return
		end
