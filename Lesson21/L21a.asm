			title		'L21a - Use timer interrupt to bump up counter'
			subtitle	'Part of Lesson 21 on multiple processors'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc
			include		Configuration.inc

;------------------------------------------------------------------------
;**
;	L21a
;
;	This program loops and displays a value on the LCD fifteen times
;	a second.  The timer interrupt is used to initiate the incementing
;	of that value in the interrupt context.
;
;	The program relies on the BCD and LCD routines from previous lessons.
;
;**
;	WB8RCR - 30-Apr-06
;	$Revision: 1.16 $ $State: Exp $ $Date: 2008-12-27 17:34:00-05 $

			extern		binary,dirty
			extern		LCDinit, LCDclear, LCDsend, Disp16, InitTMR0, LEDflg

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

	; Now that we have the initialization done, it is safe to enable
	; interrupts.  We need to separately enable the TMR0 interrupt as
	; well as the general interrupt.  The INT, PORTB and EEPROM interrupts
	; are disabled by default.
	;
	; NOTE: INTCON is in all banks, so we need not concern
	; ourselves with banksel.  

	IF (PROC == 818) || (PROC == 819) || (PROC == 88)	; 16F88 and 819 have a
			bsf			INTCON,TMR0IE	; different name for T0IE
	ELSE
			bsf			INTCON,T0IE		; Allow timer interrupt
	ENDIF
			bsf			INTCON,GIE		; Enable interrupts

	;	Main program loop here
Loop
			call		Disp16			; Display the value in memory
Loop1
			movf		dirty,W			; Test whether a new value
			btfsc		STATUS,Z
			goto		Loop1			; No, check again
			goto		Loop			; Yes, go do display

			end
