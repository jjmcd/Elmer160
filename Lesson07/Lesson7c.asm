;=================================================================================
; Lesson7a.asm - example of double byte arithmetic
; 8-Jan-2003
;=================================================================================
;
		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
;=================================================================================
; File register reservations
		cblock 		H'40'
			v1_lo 				; Variable 1, low byte
			v1_hi 				; Variable 1, high byte
			v2_lo 				; Variable 2, low byte
			v2_hi 				; Variable 2, high byte
			res_lo 				; Result, low byte
			res_hi 				; Result, high byte
			ans_lo				; Expected answer
			ans_hi
			index				; index into value table
		endc
;---------------------------------------------------------------------------------
		goto		Start 		; Skip past subroutines
;=================================================================================
; Subroutines begin here
;
;---------------------------------------------------------------------------------
; v1_high table
v1ht
		movf		index,W
		addwf		PCL,F
		dt			H'02',H'01',.37,.132,.55,.125,.115,.90
		dt			.120,.99,.52,.47,.98,.47,.69,.93
;---------------------------------------------------------------------------------
; v1_low table
v1lt
		movf		index,W
		addwf		PCL,F
		dt			H'04',H'fe',.203,.34,.38,.248,.161,.219
		dt			.145,.133,.19,.250,.48,.21,.83,.166
;---------------------------------------------------------------------------------
; v2_high table
v2ht
		movf		index,W
		addwf		PCL,F
		dt			H'01',H'00',.32,.101,.12,.115,.53,.79,.105,.76,.16,.32,.35,.42,.23,.53
;---------------------------------------------------------------------------------
; v2_low table
v2lt
		movf		index,W
		addwf		PCL,F
		dt			H'02',H'ff',.123,.118,.169,.137,.180,.229,.43,.231,.79,.22,.142,.165,.98,.34
;---------------------------------------------------------------------------------
; ans_high table
anht
		movf		index,W
		addwf		PCL,F
		dt			H'01',H'00',.5,.30,.42,.10,.61,.10,.15,.22,.35,.15,.62,.4,.45,.40
;---------------------------------------------------------------------------------
; ans_low table
anlt
		movf		index,W
		addwf		PCL,F
		dt			H'02',H'ff',.80,.172,.125,.111,.237,.246,.102,.158,.196,.228,.162,.112,.241,.132
;---------------------------------------------------------------------------------
; 16 bit addition
Add16
		movf		v1_lo,W 	; Low byte first operand
		addwf		v2_lo,W 	; Add in low byte second operand
		movwf		res_lo 		; Store result
		movf		v1_hi,W 	; Pick up high byte first operand
		btfsc		STATUS,C	; Was there a carry?
		addlw		H'01' 		; Yes, add in carry
		addwf		v2_hi,W 	; Add in high byte second operand
		movwf		res_hi 		; Store high byte result
		return
;---------------------------------------------------------------------------------
; 16 bit subtraction
Sub16
		movf 		v2_lo,W		; Subtract the low order subtrahend
		subwf	 	v1_lo,W		; from low order minuend
		movwf 		res_lo		; Save off result
		movf 		v1_hi,W		; Pick up high byte minuend
		btfss 		STATUS,C	; Subtract the borrow if needed
		addlw 		H'FF'		; by adding -1 to W
		movwf 		res_hi		; Temporarily save off high byte
		movf 		v2_hi,W		; Subtract high byte subtrahend
		subwf 		res_hi,F	; from saved minuend
		return

;Sub16
;		movf		v2_lo,W	; Low byte first operand
;		subwf		v1_lo,W	; Subtract low byte second operand
;		movwf		res_lo	; Store result
;		movf		v2_hi,W	; High byte second operand
;		btfss		STATUS,C; Borrow?
;		sublw		H'01'	; Yes, take borrow
;		subwf		v1_hi,W	; Subtract high byte
;		movwf		res_hi	; Store result
;		return

;Sub16
;		movf 		v2_lo,W 	; Low byte second operand
;		subwf 		v1_lo,W 	; Subtract from low byte first operand
;		movwf 		res_lo 		; Store result
;		movlw		H'00'		;
;		btfss 		STATUS,C	; Borrow?
;		movlw		H'01'		; Add instead of sub from other
;		addwf 		v2_hi,W 	; High byte second operand
;		subwf 		v1_hi,W 	; Subtract from high byte first
;		movwf 		res_hi 		; Store result
;		return
;
; Dan's
;result_lo	equ		res_lo
;result_hi	equ		res_hi
;Sub16
;		movf 		v2_lo, W	; Subtract the low order bytes
;		subwf	 	v1_lo, W	; Subtracts v2_lo from v1_lo
;		movwf 		result_lo
;		movf 		v1_hi, W
;		btfss 		STATUS, C	; Subtract the borrow if there was one
;		addlw 		H'FF'		;   by adding -1 to W
;		movwf 		result_hi
;		movf 		v2_hi, W
;		subwf 		result_hi, F; v1_hi - borrow - v2_hi -> result_hi
;		return
;---------------------------------------------------------------------------------
; Test values pointed to by index
Test
		call		v1ht		; Set up v1
		movwf		v1_hi
		call		v1lt
		movwf		v1_lo
		call		v2ht		; and v2
		movwf		v2_hi
		call		v2lt
		movwf		v2_lo
		call		Sub16		; do the subtract
		call		anht		; Pick up answer high
		subwf		res_hi,W	; compare to result
		btfss		STATUS,Z	; same?
		goto		errorhi		; no
		call		anlt		; answer low
		subwf		res_lo,W	;
		btfss		STATUS,Z
		goto		errorlo
		return
errorhi
		goto		errorhi
errorlo
		goto		errorlo
;=================================================================================
; Mainline starts here
Start
; Set up arguments without carry/borrow
		movlw 		H'04'		; First value H'0204'
		movwf 		v1_lo 		; = 516 decimal
		movlw 		H'02'
		movwf 		v1_hi
		movlw 		H'02' 		; Second value H'0102'
		movwf 		v2_lo 		; = 258 decimal
		movlw 		H'01'
		movwf 		v2_hi
; Do an addition
		call 		Add16 		; Result should be 774
								; or H'0306'
; Do a subtraction
		call 		Sub16 		; Result should be 258
								; or H'0102'
;;---------------------------------------------------------------------------------
;; Set up arguments with carry/borrow
;		movlw 		H'fe' 		; First value H'01fe'
;		movwf 		v1_lo 		; = 510 decimal
;		movlw 		H'01'
;		movwf 		v1_hi
;		movlw 		H'ff' 		; Second value H'00ff'
;		movwf 		v2_lo 		; = 255 decimal
;		clrf 		v2_hi
;; Do an addition
;		call 		Add16 		; Result should be 765
;								; or H'02fd'
;; Do a subtraction
;		call 		Sub16 		; Result should be 255
;								; or H'00ff'
;
		movlw		H'00'
		movwf		index

		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

		incf		index,F
		call		Test

Loop
		goto 		Loop
		end
