			title		'L20c - Counter with interrupt store and count'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

;------------------------------------------------------------------------
;**
;	L20c
;
;	This program loops and displays a value on the LCD fifteen times
;	a second.  The timer interrupt is used to initiate the incementing
;	of that value in the interrupt context.  In this version, pressing
;	PB1 saves the count in EEPROM and PB2 restores the count from EEPROM.
;	This one differs from L20b in that the EEPROM completion interrupt
;	is used instead of looping on EEPROM completion.
;
;	The program relies on the BCD and LCD routines from previous lessons.
;
;**
;	WB8RCR - 30-Apr-06
;	$Revision: 1.1 $ $State: Exp $ $Date: 2007-05-04 11:46:38-04 $

			global		eestate
			extern		binary, dirty, LEDflg
			extern		LCDinit, LCDclear, LCDsend, Del128ms
			extern		Disp16, InitTMR0, SaveCnt, RestCnt

			udata
eestate		res			1

STARTUP		code
			nop
			goto		Start

PROG		code
Start:
	; Initialization

			call		InitTMR0		; Initialize the timer

			call		LCDinit			; Initialize the LCD

	; The next two lines suppress the cursor.  Rather than including
	; LCDmacs.inc, we simply use the values for
	; LCD_DISPLAY | LCD_DISP_ON | LCD_CURS_OFF | LCD_BLINK_OFF
	; We could have just used H'0c' but that would have been even 
	; more cryptic.  This isn't very important but it makes for
	; a little nicer display.
			movlw		H'08' | H'04' | H'00' | H'00'
			call		LCDsend

			call		LCDclear		; Clear the display
			clrf		binary			; Start the counter off
			clrf		binary+1		; at zero
			movlw		H'0e'			; Initialize the LED
			movwf		LEDflg			; settings
			clrf		eestate			; Init EEPROM state

	; Now that we have the initialization done, it is safe to enable
	; interrupts.  We need to separately enable the TMR0 interrupt as
	; well as the general interrupt.  The INT, PORTB and EEPROM interrupts
	; are disabled by default.
	;
	; NOTE: INTCON is in all banks, so we need not concern
	; ourselves with banksel.  
			bsf			INTCON,T0IE		; Allow timer interrupt
			bsf			INTCON,GIE		; Enable interrupts

	;	Main program loop here
Loop
			call		Disp16			; Display the value in memory
Loop1
		; Test whether an EEPROM write is in progress.  If so,
		; go SaveCnt to process it.  Note that ODD values of eestate
		; require handling by SaveCnt.  Even values are handled by
		; the interrupt handler

			btfsc		eestate,0		; We call eestate when bit 0
			call		SaveCnt			; is set (eestate = 1, 3, 5)

		; Check the pushbuttons.  Note that it would be better
		; to debounce the buttons.  We could restore several times
		; in a row.  That isn't much of a problem, but storing
		; could be.
			movlw		H'08'			; Check whether PB2 pressed
			andwf		PORTA,W			;
			btfsc		STATUS,Z		;
			call		RestCnt			; Yes, go to restore count

			movlw		H'10'			; Now check whether PB1 pressed
			andwf		PORTA,W			;
			btfss		STATUS,Z		;
			goto		CheckDirty		; No, see if display dirty
			movf		eestate,W		; eestate must be zero to
			btfss		STATUS,Z		; initiate a write
			goto		CheckDirty		; !=0, don't write
			movlw		h'01'			; Schedule a write because
			movwf		eestate			; we have a value to save
CheckDirty
			movf		dirty,W			; Test whether a new value
			btfsc		STATUS,Z
			goto		Loop1			; No, check again
			goto		Loop			; Yes, go do display

			end
