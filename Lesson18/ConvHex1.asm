			title		'ConvBCD1 - Convert a byte to BCD'
			subtitle	'Part of Lesson 18 on display conversion'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	ConvHex1
;
;	Takes a binary value stored in 'binary' and converts it to hex
;	ASCII, storing the result in d1 and d2.
;
;**
;  WB8RCR - 11-Aug-05
;  $Revision: 1.2 $ $State: Exp $ $Date: 2005-08-12 09:30:14-04 $

		include		p16f84a.inc

		global		ConvHex1
		extern		binary,d1,d2

;	Macro to convert the low nybble of W to ASCII hex
;	and store the result at the argument 'digit'
ToHex	MACRO		digit
		LOCAL		Next
		andlw		H'0f'		; Mask off excess
		iorlw		H'30'		; Convert to ASCII
		movwf		digit		; Test to see
		sublw		'9'			; if the result was
		btfsc		STATUS,C	; 0-9.
		goto		Next		; Yes? done.
		movlw		H'7'		; No, convert : to A
		addwf		digit,F		;
Next
		ENDM

		code
ConvHex1
	; First convert high nybble
		swapf		binary,W	; Get hi nybble
		ToHex		d1			; Convert it
	; Now low nybble
		movf		binary,W	; Now we don't need the swapf
		ToHex		d2			; and convert it

		return
		end
