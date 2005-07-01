;	L17msg2 - Display a message on the LCD
;
;	In this example, we will write the letters out of order,
;	waiting a short while between each to give the viewer a
;	chance to see what is happening.
;
;	The display will be:
;
;              t
;       E      t
;       E     ft
;       El    ft
;       El   aft
;       Ele  aft
;       Ele raft
;       Elecraft
;
;	JJMcD - 14-May-05
;	$Revision: 1.3 $ $State: Exp $ $Date: 2005-07-01 14:47:34-04 $

			list		b=4,c=156,n=58,x=Off
			include		p16f84a.inc

			global		Msg2
			extern		LCDletr,LCDaddr
			extern		Del256ms

			udata
MsgIdx		res			1				; Counter for message index
PosIdx		res			1				; Character position

TABLES		code

;	Table containing the order in which to display the message
Msg2P		movlw		high Msg2Ps		; Pick up high byte of table address
			movwf		PCLATH			; And save into PCLATH
			movf		PosIdx,W		; Pick up index
			addwf		PCL,F			; And look up in table
Msg2Ps		dt			7,0,6,1,5,2,4,3,8	; Position for each character
										; Last pos 8 to move cursor off LCD
;	Table containing the message to display
Msg2T		movlw		high Msg2Ts		; Pick up high byte of table address
			movwf		PCLATH			; And save into PCLATH
			movf		MsgIdx,W		; Pick up index
			addwf		PCL,F			; And look up in table
Msg2Ts		dt			"Elecraft",0	; Message, terminated with a zero


;	Subroutine to display message in a strange order
			code
Msg2		clrf		PosIdx			; Clear out the message index
Msg2L		call		Msg2P			; Get the position
			movwf		MsgIdx			; Remember which char to pick up
			call		LCDaddr			; And position the cursor
			call		Msg2T			; Go get the character
			xorlw		H'00'			; Test to see if it was a zero
			btfsc		STATUS,Z		; Was it?
			return						; Yes, all done
			call		LCDletr			; Display the letter on the LCD
			call		Del256ms		; Wait a bit to see it
			incf		PosIdx,F		; Point to the next letter
			goto		Msg2L			; And go do it again

			end
