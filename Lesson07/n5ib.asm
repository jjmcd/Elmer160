; PIC Elmer-160 Lesson 7 - Homework
; N5IB Jan 25 2004
;
		processor	16f84a
		include		<p16f84a.inc>
		__config	_HS_OSC & _WDT_OFF & _PWRTE_ON

; Variable storage
;
	cblock		H'40'
		min_0			;minuend
		min_1
		min_2
		min_3
		sub_0			;subtrahend
		sub_1
		sub_2
		sub_3
		dif_0			;difference
		dif_1
		dif_2
		dif_3
		endc
;
; Program code
;
		goto	Start		;jump over subroutines to main program loop
;
;subroutine to zero out the answer word, not really needed
;
Zeroans		clrf	dif_0
		clrf	dif_1
		clrf	dif_2
		clrf	dif_3
		return
;
;
;32 bit subtraction routine - (minuend) - (subtrahend) = (difference)
;
Sub32
;					;temporarily save the minuend into the difference location
		movf	min_0,W
		movwf	dif_0		;byte 0
;
		movf	min_1,W
		movwf	dif_1		;byte 1
;
		movf	min_2,W
		movwf	dif_2		;byte 2
;
		movf	min_3,W
		movwf	dif_3		;byte 3
;
;					;perform subtraction of byte 0
;
		movf	sub_0,W		;get the low byte of the subtrahend into W
		subwf	dif_0,W		;subtract it from the low byte of the *saved* minuend
		movwf	dif_0		;and store the result in the low byte of the difference
		call	bor1		;now check for a borrow condition from byte 1
;
					;perform subtraction of byte 1
;
		movf	sub_1,W		;get byte 1 of the subtrahend into W
		subwf	dif_1,W		;subtract it from byte 1 of the *saved* minuend
		movwf	dif_1		;and store the result in byte 1 of the difference
		call	bor2		;check if borrow propagated to byte 2
;
;					;perform subtraction of byte 2
;
		movf	sub_2,W		;get byte 2 of the subtrahend into W
		subwf	dif_2,W		;subtract it from the byte 2 of the *saved* minuend
		movwf	dif_2		;and store the result in byte 2 of the difference
		call	bor3		;now check for a borrow condition from byte 3
;
;					;perform subtraction of byte 3
;
		movf	sub_3,W		;get byte 3 of the subtrahend into W
		subwf	dif_3,W		;subtract it from byte 3 of the *saved* minuend
		movwf	dif_3		;and store the result in byte 3 of the difference
;					;no need to check borrow unless wish to detect overflow
;
		return			;done - answer is in 4 bytes of difference location
;
;subroutine to check for a borrow conditions, multiple entry points, one
exit
;
bor1		btfsc	STATUS,C	;if CARRY has been CLEARED a borrow from min_1 is needed
		goto	nobor		;if no borrow is needed
		movf	dif_1,W		;otherwise, get the next byte of saved minuend (dif_1)
		addlw	H'FF'		;add a twos complement -1
		movwf	dif_1		;store temporarily in dif_1
;					;now check if the borrow propagated to byte 2
;
bor2		btfsc	STATUS,C	;if CARRY has been CLEARED a borrow from min_2 is needed
		goto	nobor		;if no borrow is needed
		movf	dif_2,W		;otherwise, get the next byte of the saved minuend (dif_2)
		addlw	H'FF'		;add the twos complement -1
		movwf	dif_2		;store temporarily in vfo_2
;					;now check ifthe borrow propagates to byte 3
;
bor3		btfsc	STATUS,C	;if CARRY has been CLEARED a borrow from min_3 is needed
		goto	nobor		;if no borrow is needed	
		movf	dif_3,W		;otherwise, get the next byte of the saved minuend (dif_3)
		addlw	H'FF'		;add the twos complement -1
		movwf	dif_3		;save in highest order byte of vfo frequency
;
nobor		return			;come here when all propagated borrows have been done
;
;
;	********** Main program loop **********
;
Start					;set up values before subroutine calls
;		
		movlw	H'6c'
		movwf	min_0		
		movlw	H'9e'
		movwf	min_1		;sets up decimal 3579500
		movlw	H'36'
		movwf	min_2
		movlw	H'00'
		movwf	min_3
;
		movlw	H'00'
		movwf	sub_0
		movlw	H'00'
		movwf	sub_1		;sets up hex 00 4b 00 00, decimal 4915200
		movlw	H'4b'
		movwf	sub_2
		movlw	H'00'
		movwf	sub_3
;
;
		call	Zeroans		;clear out the answer space
		call	Sub32		;do a 32 bit subtraction
;
Loop
		goto	Loop		;hang here until tired  :^))
;
		end
