			title		'L20a - Use timer interrupt to bump up counter'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		p16f84a.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

;------------------------------------------------------------------------
;**
;	L20a
;
;	This program loops and displays a value on the LCD eight times
;	a second.  The timer interrupt is used to initiate the incementing
;	of that value in the interrupt context.
;
;	The program relies on the BCD and LCD routines from previous lessons.
;
;**
;	WB8RCR - 30-Apr-06
;	$Revision: 1.1 $ $State: Exp $ $Date: 2006-05-01 07:41:21-04 $

			global		binary,digits	; Needed by ConvBCD2
			extern		ConvBCD2, LCDinit, LCDclear, LCDzero, LCDletr, Del128ms

			udata
binary		res			2				; Storage for input value
digits		res			5				; Storage for resulting
w_temp		res			1				; Save area for W
status_temp	res			1				; Save area for status

STARTUP		code
			nop
			goto		Start

PROG		code
Start
	; enable timer mode
			errorlevel	-302
			banksel		INTCON
			bcf			INTCON,T0IE		; Mask timer interrupt

	; IRL, we would have simply loaded a constant, but the
	; code below makes it explicit what we are doing
			banksel		OPTION_REG
			bcf			OPTION_REG,T0CS	; Enable timer
			bcf			OPTION_REG,T0SE	; Use rising edge
			bcf			OPTION_REG,PSA	; Prescaler to timer
			bsf			OPTION_REG,PS2	; \
			bsf			OPTION_REG,PS1	;  >- 1:256 prescale
			bsf			OPTION_REG,PS0	; /
			banksel		PORTA

			call		LCDinit			; Initialize the LCD
			call		LCDclear		; and clear it
			clrf		binary			; Start the counter off
			clrf		binary+1		; at zero

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
			call		showValue		; Display the value in memory
			call		Del128ms		; Wait a little while
			goto		Loop			; Do it again

	;	Sub to display value
showValue
			call		ConvBCD2		; Convert the value to BCD
			call		LCDzero			; Cursor to left of LCD
			movf		digits,W		; Grab most significant digit
			call		LCDletr			; and display it
			movf		digits+1,W		; Then the next
			call		LCDletr			;
			movf		digits+2,W		; and the next
			call		LCDletr			;
			movf		digits+3,W		;   .
			call		LCDletr			;   .
			movf		digits+4,W		;   .
			call		LCDletr			;
			return

	; Interrupt service routine
IRQSVC		code
			movwf		w_temp			; Save off the W register
			swapf		STATUS,W		; And the STATUS
			movwf		status_temp		;

			; Bump up the two-byte value we will display
			incf		binary+1,F		; Increment low byte
			btfsc		STATUS,Z		; Overflow? (incf doesn't affect C)
			incf		binary,F		; Increment high byte

			; Note that if we do not clear T0IF, we will be interrupted again
			; as soon as we do the retfie, so we will get nothing else done.
			bcf			INTCON,T0IF		; Clear the old interrupt

			swapf		status_temp,W	; Restore the status
			movwf		STATUS			; register
			swapf		w_temp,F		; Restore W without disturbing
			swapf		w_temp,W		; the STATUS register
			retfie

			end
