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
		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDinit		; Initialize the LCD
	; Required routines
		extern		LCDsndI		; Send a command bybble to the LCD
		extern		Del40us		; Delay 40 usec
		extern		Del2ms		; Delay 1.8 msec

_LCDOV1	udata_ovr
_LCDV01	res			1			; Storage for loop counter

		code
; ------------------------------------------------------------------------
	; Initialize the LCD
LCDinit:
		; Initialize the LCD to 4 bits
		;
		; Set the ports in case the user has forgotten
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
		movwf		_LCDV01		; we will wait 65ms after 2V
		call		Del2ms		; (in the case of LF parts)
		decfsz		_LCDV01,F	;
		goto		$-2

		; Initialization begins with sending 0x03 3 times followed
		; by a 0x02 to define 4 bit data
		LCD16		H'03',h'03'
		LCD16		H'03',h'02'

		; Now set up the display the way we want it
		IFDEF		LCD2LINE
		LCD16		H'02',H'0c'	; Set lines, font
						; 7, 1=2 lines; 6, 0=5x7; 5, 4, don't care 
						;;; Note 0c0, 080 seems no diff on DMC20434
		ELSE
		LCD16		H'02',H'04'	; Set lines, font
		ENDIF
		LCD16		H'00',H'08'	; Display Off
		LCD16		H'00',H'01'	; Display On
		LCD16		H'00',H'06'	; Set Entry Mode
						; 7=0; 6=1; 5, 1=increment; 6, 1=shift
						;; Note, 060, 070 DOES seem to change things
		LCD16		H'00',H'0c'	; cursor, display on blink

		return
		end
