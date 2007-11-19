			title		'ISRa - interrupt service routine for L20a'
			subtitle	'Part of Lesson 21 on multiple processors'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc

;------------------------------------------------------------------------
;**
;	ISRa
;
;	This function provides the interrupt service routine for use by 
;	exercise L20a.
;
;**
;	WB8RCR - 19-May-06
;	$Revision: 1.14 $ $State: Exp $ $Date: 2007-11-19 10:37:02-05 $

			extern		binary,dirty

	IF PROC == 84
			udata
	ELSE
			udata_shr
	ENDIF
w_temp		res			1				; Save area for W
status_temp	res			1				; Save area for status

	; Interrupt service routine
IRQSVC		code
			movwf		w_temp			; Save off the W register
			swapf		STATUS,W		; And the STATUS (use swapf
			movwf		status_temp		; so as not to change STATUS)
	IF PROC != 84
			banksel		binary			; Don't know bank settings on
										; entry, restoring STATUS will
										; restore original bank
										; Note that binary and dirty are
										; assumed to be in the same bank
	ENDIF

			; Bump up the two-byte value we will display
			incf		binary+1,F		; Increment low byte
			btfsc		STATUS,Z		; Overflow? (incf doesn't affect C)
			incf		binary,F		; Increment high byte
			incf		dirty,F			; Note that value changed

			; Note that if we do not clear T0IF, we will be interrupted again
			; as soon as we do the retfie, so we will get nothing else done.
		IF (PROC == 819) || (PROC == 88)
			bcf			INTCON,TMR0IF
		ELSE
			bcf			INTCON,T0IF		; Clear the old interrupt
		ENDIF

			swapf		status_temp,W	; Restore the status
			movwf		STATUS			; register
			swapf		w_temp,F		; Restore W without disturbing
			swapf		w_temp,W		; the STATUS register
			retfie

			end
