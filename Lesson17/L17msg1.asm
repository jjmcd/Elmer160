;	L17msg1 - Display a message on the LCD
;
;	JJMcD - 14-May-05
;	$Revision: 1.1 $ $Date: 2005-05-14 16:10:20-04 $
			include		p16f84a.inc

			global		Msg1
			extern		LCDletr

			udata
MsgIdx		res			1				; Counter for message index

TABLES		code
Msg1T		movlw		HIGH(Msg1Ts)	; Pick up high byte of table address
			movwf		PCLATH			; And save into PCLATH
			movf		MsgIdx,W		; Pick up indes
			addwf		PCL,F			; And look up in table
Msg1Ts		dt			"MultiPig",0		; Message, terminated with a zero

			code
Msg1		clrf		MsgIdx			; Clear out the message index
Msg1L		call		Msg1T			; Go get the character
			xorlw		H'00'			; Test to see if it was a zero
			btfsc		STATUS,Z		; Was it?
			return						; Yes, all done
			call		LCDletr			; Display the letter on the LCD
			incf		MsgIdx,F		; Point to the next letter
			goto		Msg1L			; And go do it again

			end
