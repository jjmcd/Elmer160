		title		'LCDinit - Initialize the LCD display'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDinit
;
;  Initialize the LCD display.
;
;  LCDinit intializes the LCD.  This routine must be
;  called before any other LCD routines.  The LCD
;  requires significant time between power up and
;  initialization; LCDinit waits this amount of time.
;  In addition, initialization requires sending a
;  series of commands to the LCD, some of which take
;  some time for the LCD controller to process.
;  As a result, LCDinit takes almost a tenth of a
;  second to execute.
;
;  The contents of the W register are ignored by
;  this routine.  The contents of the W register
;  are destroyed on exit.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.7 $ $Date: 2004-11-23 17:19:02-05 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDinit		; Initialize the LCD
	; Required routines
		extern		LCDsend
;		extern		LCDsndI		; Send a command bybble to the LCD
;		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.8 msec

_LCDOV1	udata_ovr
Count	res			1			; Storage for loop counter

		code
; ------------------------------------------------------------------------
	; Initialize the LCD
LCDinit:
		; Initialize the LCD to 4 bits
		;
		; Set the ports in case the user has forgotten
		IFDEF		__16F628
		movlw		H'F8'
		andwf		CMCON,F
		ENDIF
		IFDEF		__16F628A
		movlw		H'F8'
		andwf		CMCON,F
		ENDIF
		movlw		H'80'		; Turn off low 7 bits
		IFDEF		__16F88		; For 16F88 only
		andwf		PORTA,F		; of PORTA
		ENDIF
		errorlevel	-302		; Suppress message
		banksel		TRISB		; Now set the low 7 bits of
		andwf		TRISB,F		; PORTB to outputs
		IFDEF		__16F88		; For 16F88 only
		banksel		ANSEL		; Need to set the A/D converter
		andwf		ANSEL,F		; pins to normal
		ENDIF
		banksel		PORTB		; Backto bank zero and
		errorlevel	+302		; re-enable the error message

		; First, need to wait a long time after power up to
		; allow time for 44780 to get it's act together
		movlw		020h		; Need >15.1ms after 4.5V
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
		IFDEF		LCD2LINE
		movlw		LCD_FUN_SET | LCD_DL_4 | LCD_2_LINE | LCD_5X10_FONT
		call		LCDsend
		ELSE
		movlw		LCD_FUN_SET | LCD_DL_4 | LCD_1_LINE | LCD_5X10_FONT
		call		LCDsend
		ENDIF

		; It seems to help to turn off the display and clear it before
		; setting the entry mode
		movlw		LCD_DISPLAY | LCD_DISP_OFF	; Display Off
		call		LCDsend
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
