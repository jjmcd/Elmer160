; Lesson15d.asm - Encoder
;
;	Determine which way we are turning the encoder
;
;	Depending on the direction of rotation, illuminate LED 1
;	or LED 3.  Uses a simpler algorithm.
;
;   In this example, the rightmost bit from the previous reading
;   is XORed with the leftmost bit from the current reading.
;   The result will tell us which way the shaft is turned.
;
;   Notice that given the sequence 00,01,11,10 etc.:
;
;             Forward        Backward
;                /              \
;      00                   1 xor 0 = 1
;      01    0 xor 0 = 0    1 xor 0 = 1
;      11    1 xor 1 = 0    0 xor 1 = 1
;      10    1 xor 1 = 0    0 xor 1 = 1
;      00    0 xor 0 = 0
;
; WB8RCR - 21-Sep-04
; $Revision: 1.10 $ $Date: 2004-10-22 10:05:24-04 $
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

	; Read the encoder.  If the reading has changed, go ahead
	; and see what direction the change implies.
Hz2000
	; Read the encoder bits
		movf		PORTA,W			; Pick up the input word
		andlw		B'00000011'		; Mask off all but encoder
		movwf		ThisRead		; And save into current reading

	; If the current reading is the same as the previous reading,
	; we don't want to change the LEDs
		xorwf		LastRead,W		; Previous reading
		btfsc		STATUS,Z		; Same?
		return						; Yes, do nothing

	; We now want to check the result or the right bit of the
	; previous reading XORed with the left bit of the current
		movf		ThisRead,W		; Remember for
		movwf		LastRead		; next time

	; Move last reading over 1 and mask other bits
		rlf			Input,F			; Rotate the input storage
		movlw		B'00000110'		; Keep 2 bits from last time
		andwf		Input,F			; but clear all others

	; XOR current status into input word
		movf		ThisRead,W		; Pick up current reading
		xorwf		Input,F			; And OR it into the input

	; Set LEDs
		movlw		B'00001110'		; Initially set the outputs
		movwf		Output			; to all LEDs off

		btfss		Input,1			; Test bit 1
		goto		SetUp			; Move up
		goto		SetDn			; Move Down

	; Movement is clockwise, turn on LED1
SetUp
		movlw		B'00001100'		; Initially set the outputs
		movwf		Output			; to all LEDs off
		return
	; Movement is counterclockwise, turn on LED3
SetDn
		movlw		B'00000110'		; Initially set the outputs
		movwf		Output			; to all LEDs off
		return
	; No change, don't change LEDs
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
