;	Elmer 160 Lesson 14b - 9 June 2004
;	Send digits in Morse 

		processor	pic16f628a
		include		<P16F628A.INC>
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BODEN_OFF
		list		b=4,n=70

XMTR	equ			H'02'
KEY		equ			H'07'
Output	equ			PORTB

		cblock		H'20'
;			Output			; Output byte to transmitter
			L1				; Outer timing counter
			L2				; Inner timing counter
			DigToSend		; Digit currently being sent
			BitCount		; How far we are decoding Morse
		endc

		goto		Start	; Skip to mainline

Digit
		movwf		DigToSend	; Save digit
		movlw		H'5'		; 5 elements per digit
		movwf		BitCount
		movlw		H'03'		; Select page with
		movwf		PCLATH		; digit table
		movf		DigToSend,W	; Pick up the digit
		call		Table		; And get it's Morse
		movwf		DigToSend	; Save it off
		clrf		PCLATH		; and restore PCLATH
DigLoop
		rlf			DigToSend,F	; Get next element
		btfsc		STATUS,C	; Is it a dah?
		goto		SendDah		; Yes, send a dah
		call		Dit			; No, send a dit
		goto		EndLoop
SendDah	call		Dah
EndLoop
		decfsz		BitCount,F	; Decrement element count
		goto		DigLoop		; Not done? Do it again
		call		DahTime		; Inter-char space
		return

;	Delay a dit time
DitTime
		movlw		H'47'
		movwf		L1
DitTime1
		movlw		H'00'
		movwf		L2
DitTime2
		decfsz		L2,F
		goto		DitTime2
		decfsz		L1,F
		goto		DitTime1
		return
;	Delay a dah time
DahTime
		call		DitTime
		call		DitTime
		call		DitTime
		return
;	Delay a letter space
LetSpc
		call		DahTime		; OK, this is a tiny bit long
		return
;	Delay a word space
WordSpace
		call		DahTime
		call		DahTime
		return
;	Turn on the transmitter
XmitOn
		bcf			Output,XMTR
		bsf			Output,KEY
		return
;	Turn off the transmitter
XmitOff
		bsf			Output,XMTR
		bcf			Output,KEY
		return
;	Send a Dah
Dah
		call		XmitOn
		call		DahTime
		call		XmitOff
		call		DitTime
		return
;	Send a Dit
Dit
		call		XmitOn
		call		DitTime
		call		XmitOff
		call		DitTime
		return

;	Main program starts here
;
;	Initialization
Start
		clrf		Output		; Initialize output off
		banksel		TRISB
		bcf			TRISB,XMTR
		bcf			TRISB,KEY
		banksel		PORTB
		movlw		H'07'
		movwf		CMCON

;	Main loop here
Loop
		movlw		D'1'
		call		Digit
		movlw		D'2'
		call		Digit
		movlw		D'4'
		call		Digit
		movlw		D'8'
		call		Digit
		call		WordSpace
		goto		Loop

		org			h'300'
;	Convert a digit, 0-9, to Morse
Table
		addwf		PCL,F
		retlw		H'f8'	; 0
		retlw		H'78'	; 1
		retlw		H'38'	; 2
		retlw		H'18'	; 3
		retlw		H'08'	; 4
		retlw		H'00'	; 5
		retlw		H'80'	; 6
		retlw		H'c0'	; 7
		retlw		H'e0'	; 8
		retlw		H'f0'	; 9

		end

