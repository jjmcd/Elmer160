; Lesson15c.asm - Encoder
;
;	Determine which way we are turning the encoder
;
;	Depending on the direction of rotation, illuminate LED 1
;	or LED 3.  If an impossible value is calculated, 
;	illuminate LED2.  This version debounces the input.
;
; WB8RCR - 19-Aug-04
; $Revsion$ $Date: 2004-10-20 14:07:02-04 $
;
;=====================================================================

		processor	pic16f84a
		include		p16f84a.inc
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON
		list		b=4,n=70

; Port bit assignments
LED1	equ			3				; LED1 on PORTB
LED2	equ			2				; LED2 on PORTB
LED3	equ			1				; LED3 on PORTB
ENC1	equ			0				; Encoder 1 on PORTA
ENC2	equ			1				; Encoder 2 on PORTA
HZ2000T	equ			D'1'			; Number of clock ticks for Hz2000
HZ10T	equ			D'200'			; Number of clock ticks for Hz10

		cblock		H'20'
			Input					; Store the debounced input
			Output					; Store the outputs
			ThisRead				; Current reading
			LastRead				; Remember previous reading
			Hz2000cnt				; Counter for 2000x/sec
			Hz10Cnt					; Counter for 10x/sec
		endc

		goto		Start

;---------------------------------------------------------------------
;	2000 times per second code here
;---------------------------------------------------------------------

	; In order to debounce the input, we won't accept a reading
	; until we have seen the same input on two successive
	; reads of the encoder spaced 1/2 ms apart.  This is probably
	; not as much time as we would like, but the encoders shiped
	; with newer PIC-ELs generate their transitions in a very short
	; space, so a slower read would likely miss transitions.
Hz2000
	; Read the encoder bits
		movf		PORTA,W			; Pick up the input word
		andlw		H'03'			; Mask off all but encoder
		movwf		ThisRead		; And save into current reading
	; See if the same as last time
		movf		ThisRead,W		; Pick up current
		xorwf		LastRead,W		; Will be zero if same
		btfsc		STATUS,Z		; Zero?
		goto		NewReading		; Yes, will use reading
		movf		ThisRead,W		; No, remember for
		movwf		LastRead		; next time
		return						; Exit Hz2000
	; We now have two successive readings that are identical.
	; Add them into the input word after shifting the existing
	; contents left two bits.
NewReading
		movf		ThisRead,W		; Remember for
		movwf		LastRead		; next time
	; Move last reading over 2 and mask other bits
		rlf			Input,F			; Rotate the input storage
		rlf			Input,F			; over two bits
		movlw		B'00001100'		; Keep 2 bits from last time
		andwf		Input,F			; but clear all others
	; Move current status into input word
		movf		ThisRead,W		; Pick up current reading
		iorwf		Input,F			; And OR it into the input

	; Set LEDs

		movf		Input,W			; Pick up the input word
		addwf		PCL,F			; Jump depending on value
		goto		SetNo			; 0000 Same
		goto		SetUp			; 0001 Up
		goto		SetDn			; 0010 Down
		goto		SetErr			; 0011 Error
		goto		SetDn			; 0100 Down
		goto		SetNo			; 0101 Same
		goto		SetErr			; 0110 Error
		goto		SetUp			; 0111 Up
		goto		SetUp			; 1000 Up
		goto		SetErr			; 1001 Error
		goto		SetNo			; 1010 Same
		goto		SetDn			; 1011 Down
		goto		SetErr			; 1100 Error
		goto		SetDn			; 1101 Down
		goto		SetUp			; 1110 Up
		goto		SetNo			; 1111 Same
	; Movement is clockwise, turn on LED3
SetUp
		movlw		B'00001100'		; Set LED3 (bit 1) on
		movwf		Output			; (FALSE=LED on)
		return
	; Movement is counterclockwise, turn on LED1
SetDn
		movlw		B'00000110'		; Set LED1 (bit 3) on
		movwf		Output			; (FALSE=LED on)
		return
	; Got a bad combination, turn on LED2
SetErr
		movlw		B'00001010'		; Set LED2 (bit 2) on
		movwf		Output			; (FALSE=LED on)
		return
	; No change, leave LEDs alone
SetNo
		return						; Exit HZ10

;---------------------------------------------------------------------
;	10 times per second code here
;---------------------------------------------------------------------
	; Send the outputs
Hz10
		movf		Output,W		; Pick up the output word
		movwf		PORTB			; and send it to PORTB
		return						; Exit HZ10

;---------------------------------------------------------------------
;	Mainline begins here
;---------------------------------------------------------------------
Start
	; Initialize GP register locations
		clrf		Input			; Clear the input storage
		clrf		Output			; and the output storage
		movlw		HZ2000T			; Initialize the Hz2000
		movwf		Hz2000cnt		; counter
		movlw		HZ10T			; and the HZ10 counter
		movwf		Hz10Cnt			; 
	; Set up timer 
		errorlevel	-302			; Yes, we know!
		banksel		INTCON
		bcf			INTCON,T0IE		; Mask timer interrupt
		banksel		OPTION_REG
		bcf			OPTION_REG,T0CS	; Select timer
		bcf			OPTION_REG,PSA	; Prescaler to timer
		bcf			OPTION_REG,PS2	; \
		bcf			OPTION_REG,PS1	;  >- 1:2 prescale
		bcf			OPTION_REG,PS0	; /
	; Set the LEDs to be outputs
		banksel		TRISB			; Select bank 1
		bcf			TRISB,LED1		; Clear the TRIS bits
		bcf			TRISB,LED2		; for each of the LEDs
		bcf			TRISB,LED3		; making them outputs
		errorlevel	+302			; Back on just in case
		banksel		PORTB			; Back to bank 0

;---------------------------------------------------------------------
;	Main program loop here
;---------------------------------------------------------------------
main
		btfss		INTCON,T0IF		; Did timer overflow?
		goto		main			; No, hang around some more
		bcf			INTCON,T0IF		; reset overflow flag

;---------------------------------------------------------------------
;	Check for 2000 times per second
;---------------------------------------------------------------------
		decfsz		Hz2000cnt,F		; Count down until Hz2000
		goto		$+4				; Not time yet
		movlw		HZ2000T			; Reset the counter so
		movwf		Hz2000cnt		; it's available next time
		call		Hz2000			; Go do 2000X per second code
;---------------------------------------------------------------------
;	Check for 10 times per second
;---------------------------------------------------------------------
		decfsz		Hz10Cnt,F		; Count down until Hz10
		goto		$+4				; Not time yet
		movlw		HZ10T			; Reset the counter so
		movwf		Hz10Cnt			; it's available next time
		call		Hz10			; Go do 10X per second code

		goto		main
		end
