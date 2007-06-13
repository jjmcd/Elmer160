			title		'ISRc - interrupt service routine for L20c'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc
			include		EEPROM.inc

;------------------------------------------------------------------------
;**
;	ISRc
;
;	This function provides the interrupt service routine for use by 
;	exercise L20c.
;
;	The function must first save state.  Then, it checks to see whether the
;	interrupt was caused by the timer.  If so, the value binary is incremented.
;	Then it checks to see if the interrupt was an EEPROM write completion
;	interrupt.  If so, it increments the eestate variable.  In each case, the
;	relevant interrupt falg must be cleared.  Then state is restored before
;	returning from the interrupt.
;
;**
;	WB8RCR - 19-May-06
;	$Revision: 1.13 $ $State: Exp $ $Date: 2007-06-13 10:21:20-04 $

			extern		binary,dirty,eestate

	IF		PROC==84
			udata
	ELSE
			udata_shr
	ENDIF
w_temp		res			1				; Save area for W
status_temp	res			1				; Save area for status

	; Interrupt service routine
IRQSVC		code
			movwf		w_temp			; Save off the W register
			swapf		STATUS,W		; And the STATUS
			movwf		status_temp		;
			banksel		0				; Be sure we are in bank 0

			; Now that the status is safely saved, test whether it was a timer
			; interrupt that got us here
	IF 		(PROC == 819) || (PROC == 88)
			btfss		INTCON,TMR0IF
	ELSE
			btfss		INTCON,T0IF		; Timer interrupt flag
	ENDIF
			goto		IRQEEPROM		; No, go check EEPROM

			; Bump up the two-byte value we will display
	IF PROC != 84
			banksel		binary
	ENDIF
			incf		binary+1,F		; Increment low byte
			btfsc		STATUS,Z		; Overflow? (incf doesn't affect C)
			incf		binary,F		; Increment high byte
			incf		dirty,F			; Note that value changed

			; Note that if we do not clear T0IF, we will be interrupted again
			; as soon as we do the retfie, so we will get nothing else done.
	IF 		(PROC == 819) || (PROC == 88)
			bcf			INTCON,TMR0IF
	ELSE
			bcf			INTCON,T0IF		; Clear the old interrupt
	ENDIF

			; Check the EEPROM completion interrupt flag
IRQEEPROM
			banksel		IFREG
			errorlevel	-302
			btfss		IFREG,EEIF		; EEPROM completion interrupt
			goto		IRQEXIT

			; Handle the EEPROM completion interrupt
IRQEEDONE
			bcf			IFREG,EEIF		; Clear the interrupt flag
			banksel		eestate
			incf		eestate,F		; Remember we handled it

			; Restore status and return from the interrupt
IRQEXIT
			banksel		0				; Ensure bank 0
			errorlevel	+302
			swapf		status_temp,W	; Restore the status
			movwf		STATUS			; register
			swapf		w_temp,F		; Restore W without disturbing
			swapf		w_temp,W		; the STATUS register
			retfie

			end
