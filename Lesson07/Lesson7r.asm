;	Lesson7a.asm - Rotating bits through the carry
;	18-Jan-2003
;
		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'40'
			l1					; Low byte
			l2					; next
			l3					; next
			l4					; High byte
		endc

	;	Set up arguments without carry/borrow
		movlw		H'01'		; Set the low bit to one
		movwf		l1
		movlw		H'00'		; And clear out all th
		movwf		l2			; higher order bytes
		movwf		l3
		movwf		l4
		bcf			STATUS,C	; Clear the carry
Loop
		rlf			l1,F		; Rotate low byte
		rlf			l2,F		; and next
		rlf			l3,F		; etc.
		rlf			l4,F		;
		goto		Loop		; Do it again
		end
