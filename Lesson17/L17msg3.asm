;	L17msg3 - Display a scrollingmessage on the LCD
;
;	JJMcD - 14-May-05
;	$Revision: 1.1 $ $Date: 2005-05-15 10:36:26-04 $
			include		p16f84a.inc

			global		Msg3
			extern		LCDletr,LCDshift,LCDunshf,LCDaddr
			extern		Del256ms

			udata
MsgIdx		res			1				; Counter for message index

TABLES		code
Msg3T		movlw		HIGH(Msg3Ts)	; Pick up high byte of table address
			movwf		PCLATH			; And save into PCLATH
			movf		MsgIdx,W		; Pick up indes
			addwf		PCL,F			; And look up in table
Msg3Ts		dt			"Watson, come here please.       ",0

			code
Msg3		clrf		MsgIdx			; Clear out the message index
			call		LCDshift		; Set the LCD to shift mode
			movlw		H'08'			; Position to the right end
			call		LCDaddr			; of the LCD display
Msg3L		call		Msg3T			; Go get the character
			xorlw		H'00'			; Test to see if it was a zero
			btfsc		STATUS,Z		; Was it?
			goto		Msg3Q			; Yes, all done
			call		LCDletr			; Display the letter on the LCD
			call		Del256ms		; Wait so message isn't total blur
			incf		MsgIdx,F		; Point to the next letter
			goto		Msg3L			; And go do it again
Msg3Q		call		LCDunshf
			return
			end
