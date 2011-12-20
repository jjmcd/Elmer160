; Lessn13d.asm
;
;  Roulette Wheel
;
;  WB8RCR - 16-Mar-04
;
;=====================================================================

		processor	pic16f628a
		include		"P16F628A.INC"
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BODEN_OFF
		list		b=4,n=70

;=====================================================================
;	Manifest Constants
;=====================================================================
PB1		equ			H'04'		; PORTA pin for PB1
SPKMSK	equ			B'00000100'	; Mask for speaker
HZ2TIME	equ			D'40'		; Clock ticks for 20/sec
HZ8TIME	equ			D'12'		; Clock ticks for 80/sec
HZVMAX	equ			D'10'		; Fastest rotate rate

;=====================================================================
;	File register use
;=====================================================================
		cblock		H'20'
			Hz2Cnt				; 20 times per second counter
			HzVCnt				; variable times per second counter
			Hz8Cnt				; 80 times per second counter
			OutA				; Port A output storage
			OutB				; Port B output storage
			Inputs				; Input storage
			LEDstate			; Which LED on?
			LEDrate				; Rate of flashing
		endc

		goto		start

;=====================================================================
;  Subroutines
;=====================================================================
SendOut
		movf		OutB,W		; Pick up the output word
		movwf		PORTB		; And send it to the world
		movf		OutA,W		; Same with PORTA
		movwf		PORTA		;
		return

;=====================================================================
;  Time domains
;=====================================================================

;---------------------------------------------------------------------
;	80 times per second code
;---------------------------------------------------------------------
Hz8
	; Get inputs
		movf		PORTA,W
		movwf		Inputs

	; Check button state
		btfsc		Inputs,PB1		; Is button up?
		return						; Button up, do nothing
	; Button is down
		movlw		HZVMAX
		movwf		LEDrate			; Fastest flashing
		return

;---------------------------------------------------------------------
;	20 times per second code
;---------------------------------------------------------------------
Hz2
	; Check whether rate already slowest
		movf		LEDrate,W		; Pick up rate and xor with
		xorlw		0xff			; ff so Z set if equal
		btfsc		STATUS,Z		; Is rate slowest?
		return						; Yes, do nothing
	; Make LEDs slower
		incf		LEDrate,F		; Bump it down by one
		return

;---------------------------------------------------------------------
;	Variable times per second code
;---------------------------------------------------------------------
HzV
		rlf			LEDstate,F		; Move the 1 over a bit
		btfss		LEDstate,4		; Did it roll off the end?
		goto		SetLEDs			; No, continue on
		movlw		B'00000010'		; Yes, reset to bit 1 on
		movwf		LEDstate		; and store it away
SetLEDs
		movlw		B'1110001'		; Initially turn on LEDs (actually
		andwf		OutB,F			; overkill since no other IO)
		movf		LEDstate,W		; Pick up LED state
		xorlw		H'0e'			; Flip because active low
		iorwf		OutB,F			; Set it in the outputs
		movlw		SPKMSK			; Pick up speaker mask
		xorwf		OutA,F			; and toggle the speaker
		movf		LEDrate,W		; Pick up rate, if it's
		xorlw		H'ff'			; ff we want to be sure
		btfsc		STATUS,Z		; that the speaker transistor
		bcf			OutA,2			; is turned off
		call		SendOut			; Go do output
		return

;=====================================================================
;  Mailine begins here -- Initialization
;=====================================================================
start

;---------------------------------------------------------------------
;	Set up timer 
;---------------------------------------------------------------------
		errorlevel	-302
		banksel		INTCON
		bcf			INTCON,T0IE		; Mask timer interrupt
	; Normally, we would have simply loaded a constant, but the
	; code below makes it explicit what we are doing
		banksel		OPTION_REG
		bcf			OPTION_REG,T0CS	; Select timer
		bcf			OPTION_REG,PSA	; Prescaler to timer
		bcf			OPTION_REG,PS2	; \
		bcf			OPTION_REG,PS1	;  >- 1:4 prescale
		bsf			OPTION_REG,PS0	; /
;---------------------------------------------------------------------
;	Set up I/O 
;---------------------------------------------------------------------
		banksel		TRISB
		clrw						; 
		movwf		TRISB			; Make all port B output
		banksel		TRISA
		bcf			TRISA,2
		banksel		PORTA
		errorlevel	+302
		movlw		H'07'
		movwf		CMCON

;---------------------------------------------------------------------
;	Initialize memory
;---------------------------------------------------------------------
		movlw		B'00001110'		; Initially set all LEDs
		movwf		OutB			; to off
		movwf		PORTB

		movlw		HZ2TIME			; Initialize 20 times
		movwf		Hz2Cnt			; per second counter
		movlw		HZ8TIME			; and eighty times per
		movwf		Hz8Cnt			; second counter

		movlw		B'00000010'		; Initialize the LED
		movwf		LEDstate		; states
		movlw		H'd0'			; and the speed of LED
		movwf		LEDrate			; movement

;=====================================================================
; Main program loop here
;=====================================================================
main
		btfss		INTCON,T0IF		; Did timer overflow?
		goto		main			; No, hang around some more
		bcf			INTCON,T0IF		; reset overflow flag

;---------------------------------------------------------------------
;	Check for eighty times per second
;---------------------------------------------------------------------
		decfsz		Hz8Cnt,F		; Count down until Hz8
		goto		$+4				; Not time yet
		movlw		HZ8TIME			; Reset the counter so
		movwf		Hz8Cnt			; it's available next time
		call		Hz8				; Go do thrice per second code

;---------------------------------------------------------------------
;	Check for twenty times per second
;---------------------------------------------------------------------
		decfsz		Hz2Cnt,F		; Count down until Hz2
		goto		$+4				; Not time yet
		movlw		HZ2TIME			; Reset the counter so
		movwf		Hz2Cnt			; it's available next time
		call		Hz2				; Go do twice per second code

;---------------------------------------------------------------------
;	Check for variable times per second
;---------------------------------------------------------------------
	; Special case, if LEDrate = 0xff quit doing this
		movf		LEDrate,W		; Pick up rate, if it's
		xorlw		H'ff'			; ff we want to not run
		btfsc		STATUS,Z		; this time domain
		goto		main

		decfsz		HzVCnt,F		; Count down until Hz1
		goto		$+4				; Not time yet
		movf		LEDrate,W		; Reset the counter so
		movwf		HzVCnt			; it's available next time
		call		HzV				; Go do 5X per second code

		goto		main
		end
