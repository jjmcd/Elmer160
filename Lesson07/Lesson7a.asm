;	Lesson7a.asm - example of double byte arthmetic
;	8-Jan-2003
;
		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'10'
			v1_lo			; Variable 1, low byte
			v1_hi			; Variable 1, high byte
			v2_lo			; Variable 2, low byte
			v2_hi			; Variable 2, high byte
			res_lo			; Result, low byte
			res_hi			; Result, high byte
		endc

		goto		Start

;	16 bit addition
Add16
		movf		v1_lo,W	; Low byte first operand
		addwf		v2_lo,W	; Add in low byte second operand
		movwf		res_lo	; Store result
		movf		v1_hi,W	; Pick up high byte first operand
		btfsc		STATUS,C; Was there a carry?
		addlw		H'01'	; Yes, add in carry
		addwf		v2_hi,W	; Add in high byte second operand
		movwf		res_hi	; Store high byte result
		return

;	16 bit subtraction
Sub16
		movf		v2_lo,W	; Low byte first operand
		subwf		v1_lo,W	; Subtract low byte second operand
		movwf		res_lo	; Store result
		movf		v2_hi,W	; High byte second operand
		btfss		STATUS,C; Borrow?
		sublw		H'01'	; Yes, take borrow
		subwf		v1_hi,W	; Subtract high byte
		movwf		res_hi	; Store result
		return

;	Mainline starts here
Start
	;	Set up arguments without carry/borrow
		movlw		H'04'	; First value H'0204'
		movwf		v1_lo	; = 516 decimal
		movlw		H'02'
		movwf		v1_hi

		movlw		H'02'	; Second value H'0102'
		movwf		v2_lo	; = 258 decimal
		movlw		H'01'
		movwf		v2_hi

	; Do an addition
		call		Add16	; Result should be 774
							; or H'0306'

	;	Do a subtraction
		call		Sub16	; Result should be 258
							; or H'0102'

	;	Set up arguments with carry/borrow
		movlw		H'02'	; First value H'0102'
		movwf		v1_lo	; = 258 decimal
		movlw		H'01'
		movwf		v1_hi

		movlw		H'ff'	; Second value H'00ff'
		movwf		v2_lo	; = 255 decimal
		clrf		v2_hi

	; Do an addition
		call		Add16	; Result should be 513
							; or H'0201'

	;	Do a subtraction
		call		Sub16	; Result should be 3
							; or H'0003'
Loop
		goto		Loop
		end
