			title		'ConvBCD1 - Convert a byte to BCD'
			subtitle	'Part of Lesson 18 on BCD conversion'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	ConvBCD1
;
;	Takes a binary value stored in 'binary' and converts it to BCD
;	storing the result in d1-d3.
;
;**
;  WB8RCR - 10-Aug-05
;  $Revision: 1.2 $ $State: Rel $ $Date: 2011-12-22 11:28:19-05 $

		include		P16F628A.INC

		global		ConvBCD1
		extern		binary,d1,d2,d3

		udata
work	res			1				; Remainder from division

;------------------------------------------------------------------
; Translate one digit of a byte to BCD
DoDigit	Macro		Decade,Letter
		Local		Again,Alldud
Again
		movlw		Decade			; Subtract Decade from Temp
		subwf		work,W			; 
		btfss		STATUS,C		; Was there a borrow?
		goto		Alldud			; Yes, go to next digit
		incf		Letter,F		; No, increment display
		movwf		work			; and save off difference
		goto		Again			; Go back and do it again
Alldud
		endm

;------------------------------------------------------------------

		code
ConvBCD1
	; Clear out result area
		clrf		d1
		clrf		d2
		clrf		d3
	; Move argument to work
		movf		binary,W
		movwf		work
	; Convert each digit
		DoDigit		D'100',d1
		DoDigit		D'10',d2
		DoDigit		D'1',d3
		return

		end
