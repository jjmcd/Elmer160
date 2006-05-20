			title		'ISRa - interrupt service routine for L20a'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		p16f84a.inc

;------------------------------------------------------------------------
;**
;	InitTmr0
;
;	This function provides the interrupt service routine for use by 
;	exercise L20a.
;
;**
;	WB8RCR - 19-May-06
;	$Revision: 1.1 $ $State: Exp $ $Date: 2006-05-20 09:25:11-04 $

			extern		binary

			udata
w_temp		res			1				; Save area for W
status_temp	res			1				; Save area for status

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
