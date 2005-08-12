			title		'ConvHex2 - Convert a word to hex ASCII'
			subtitle	'Part of Lesson 18 on display conversion'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	ConvHex2
;
;	Takes a binary value stored in 'binary' and converts it to hex
;	ASCII, storing the result in digits - digits+3
;
;**
;  WB8RCR - 11-Aug-05
;  $Revision: 1.2 $ $State: Exp $ $Date: 2005-08-12 09:31:32-04 $

		include		p16f84a.inc

		global		ConvHex2
		extern		binary,digits

		code
ConvHex2
	; First convert high nybble
		movlw		digits		; Get address of storage area
		movwf		FSR			; and place in FSR
		swapf		binary,W	; Get hi nybble
		call		Hexit		; Convert to hex
	; Now low nybble
		incf		FSR			; Point to next character
		movf		binary,W	; Now we don't need the swapf
		call		Hexit		; Convert low nybble
	; Now convert high nybble of the next byte
		incf		FSR			; Next character
		swapf		binary+1,W	; As before
		call		Hexit
	; Now low nybble
		incf		FSR
		movf		binary+1,W
		call		Hexit

		return

;	Subroutine to convert a single hex nybble.
;
;	Nybble to convert is in low nybble of W
;	Result stored in location pointer to by FSR
Hexit
		andlw		H'0f'		; Mask off excess
		iorlw		H'30'		; Convert to ASCII
		movwf		INDF		; Test to see
		sublw		'9'			; if the result was
		btfsc		STATUS,C	; 0-9.
		return					; Yes? done.
		movlw		H'7'		; No, convert : to A
		addwf		INDF,F		;
		return
		end
