; Lesson15b.asm - Encoder
;
;	Determine which way we are turning the encoder
;
;	Depending on the direction of rotation, illuminate LED 1
;	or LED 3.  If an impossible value is calculated, 
;	illuminate LED2.
;
;   In this version, we combine the current and previous
;   encoder readings and use the result as an index into
;   a table which tells us which direction the shaft is
;   being turned.
;
; WB8RCR - 11-Aug-04
; $Revision: 1.4 $ $Date: 2011-12-21 18:38:19-04 $
;
;=====================================================================

		processor	pic16f28a
		include		P16F628A.INC
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BODEN_OFF
		list		b=4,n=70

; Port bit assignments
LED1	equ			3	; LED1 on PORTB
LED2	equ			2	; LED2 on PORTB
LED3	equ			1	; LED3 on PORTB
ENC1	equ			0	; Encoder 1 on PORTA
ENC2	equ			1	; Encoder 2 on PORTA

		cblock		H'20'
			Input
			Output
		endc

Start
	; Initialize GP register locations
		clrf		Input		; Clear the input storage
		clrf		Output		; and the output storage
	; Set the LEDs to be outputs
		banksel		TRISB		; Select bank 1
		errorlevel	-302		; Yes, we know!
		bcf			TRISB,LED1	; Clear the TRIS bits
		bcf			TRISB,LED2	; for each of the LEDs
		bcf			TRISB,LED3	; making them outputs
		errorlevel	+302		; Back on just in case
		banksel		PORTB		; Back to bank 0
		movlw		H'07'
		movwf		CMCON
Loop
	; Move last reading over 2 and mask other bits
		rlf			Input,F		; Rotate the input storage
		rlf			Input,F		; over two bits
		movlw		B'00001100'	; Keep 2 bits from last time
		andwf		Input,F		; but clear all others
	; Move current status into input word
		btfsc		PORTA,ENC1	; ENC1 low?
		bsf			Input,ENC1	; No, set it high on output
		btfsc		PORTA,ENC2	; ENC2 low?
		bsf			Input,ENC2	; No, set it high on output

	; Set LEDs
		movlw		B'00001110'	; Initially set the outputs
		movwf		Output		; to all LEDs off
		movf		Input,W		; Pick up the input word
		addwf		PCL,F		; Jump depending on value
		goto		SetNo		; 0000 Same
		goto		SetUp		; 0001 Up
		goto		SetDn		; 0010 Down
		goto		SetErr		; 0011 Error
		goto		SetDn		; 0100 Down
		goto		SetNo		; 0101 Same
		goto		SetErr		; 0110 Error
		goto		SetUp		; 0111 Up
		goto		SetUp		; 1000 Up
		goto		SetErr		; 1001 Error
		goto		SetNo		; 1010 Same
		goto		SetDn		; 1011 Down
		goto		SetErr		; 1100 Error
		goto		SetDn		; 1101 Down
		goto		SetUp		; 1110 Up
		goto		SetNo		; 1111 Same
	; Movement is clockwise, turn on LED1
SetUp
		bcf			Output,LED1	; Clear=ON
		goto		Outputs
	; Movement is counterclockwise, turn on LED3
SetDn
		bcf			Output,LED3	; Clear=ON
		goto		Outputs
	; Got a bad combination, turn on LED2
SetErr
		bcf			Output,LED2	; Clear=ON
		goto		Outputs
	; No change, don't change LEDs
SetNo
		goto		Loop

	; Send the outputs
Outputs
		movf		Output,W	; Pick up the output word
		movwf		PORTB		; and send it to PORTB
		goto		Loop		; Do it again

		end
