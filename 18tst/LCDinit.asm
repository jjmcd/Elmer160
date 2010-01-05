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
;  $Revision: 3.0 $ $Date: 2007-03-25 10:11:56-04 $

		include		"LCDmacs.inc"

	; Provided Routines
		global		LCDinit		; Initialize the LCD
	; Required routines
		extern		LCDsend
		extern		Del2ms		; Delay 1.8 msec

_LCDOV1	udata_ovr
Count	res			1			; Storage for loop counter

LCDLIB	code
; ------------------------------------------------------------------------
	; Initialize the LCD
LCDinit:
		; Initialize the LCD to 4 bits
		;
		; Set the ports in case the user has forgotten
		IF			PROC == 627	; For 16F627/628
		movlw		H'07'		; Turn off comparators
		iorwf		CMCON,F		; so they can be I/O
		ENDIF
        IF          PROC == 716
        errorlevel  -302
        banksel     ADCON1
        movlw       H'07'
        movwf       ADCON1
        banksel     CCP1CON
        errorlevel  +302
        clrf        CCP1CON
        ENDIF
		movlw		H'80'		; Turn off low 7 bits
		IF			PROC == 88	; For 16F88 only
		andwf		PORTA,F		; of PORTA
		ENDIF
        IF          PROC == 1320
        movlw       H'7f'       ; Set A/D pins
        movwf       ADCON1      ; to digital
        bcf         TRISB,4     ; LCD EN
        bcf         TRISB,5     ; LCD EN
        bcf         TRISB,6     ; LCD RS
        bcf         TRISA,2     ; D4
        bcf         TRISA,3     ; D5
        bcf         TRISB,0     ; D6
        bcf         TRISB,1     ; D7
        bcf         LATB,4
        bcf         LATB,5
        bcf         LATB,6
        ELSE
		errorlevel	-302		; Suppress message
        IF          PROC != 54
		banksel		LCDTRIS		; Now set the low 7 bits of
		andwf		LCDTRIS,F		; LCDPORT to outputs
        ELSE
        tris        LCDPORT
        ENDIF
        ENDIF
		IF			PROC == 88	; For 16F88 only
		banksel		ANSEL		; Need to set the A/D converter
		andwf		ANSEL,F		; pins to normal
		ENDIF
        IF          PROC != 1320
		banksel		LCDPORT		; Back to bank zero and
        ENDIF
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
        call        Del2ms

		; Now set up the display the way we want it
		IFDEF		LCD2LINE
		movlw		LCD_FUN_SET | LCD_DL_4 | LCD_2_LINE | LCD_5X7_FONT
		call		LCDsend
		ELSE
		movlw		LCD_FUN_SET | LCD_DL_4 | LCD_1_LINE | LCD_5X7_FONT
		call		LCDsend
		ENDIF
        call        Del2ms

		; It seems to help to turn off the display and clear it before
		; setting the entry mode
		movlw		LCD_DISPLAY | LCD_DISP_OFF	; Display Off
		call		LCDsend
        call        Del2ms
		movlw		LCD_DISP_CLEAR	; Display clear
		call		LCDsend
        call        Del2ms

		; Set display to no shift
		movlw		LCD_ENTRY_MODE | LCD_NO_SHIFT | LCD_DIS_INCR
		call		LCDsend
        call        Del2ms

		; Turn on display, cursor, and cursor blinking
		movlw		LCD_DISPLAY | LCD_DISP_ON | LCD_CURS_ON | LCD_BLINK_ON
		call		LCDsend
        call        Del2ms

		return
		end
