; Lesson13b.asm - Introduction of state variables
;
;  Blink one or another LED, toggle when PB1 pressed
;
;  WB8RCR - 3-Mar-04
;
;=====================================================================

		processor	pic16f628a
		include		"P16F628A.INC"
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF
		list		b=4,n=70

;=====================================================================
;	Manifest Constants
;=====================================================================
LED1M	equ			B'00001000'	; PORTB pin for LED
LED2M	equ			B'00000100'	; PORTB pin for LED
PB1		equ			H'04'		; PORTA pin for PB1
HZ5TIME	equ			D'49'		; Clock ticks for 5/sec
HZ2TIME	equ			D'122'		; Clock ticks for 2/sec
HZNTIME	equ			D'12'		; Clock ticks for 20/sec

;=====================================================================
;	File register use
;=====================================================================
		cblock		H'20'
			Hz2Cnt				; Twice per second counter
			Hz5Cnt				; 5 times per second counter
			HzNCnt				; 20 times per second counter
			Outputs				; Output storage
			Inputs				; Input storage
			PBstate				; What state is PB?
			LEDstate			; Which LED flashing?
		endc

		goto		start

;=====================================================================
;  Subroutines
;=====================================================================
SendOut
		movf		Outputs,W		; Pick up the output word
		movwf		PORTB			; And send it to the world
		return

;=====================================================================
;  Time domains
;=====================================================================

;---------------------------------------------------------------------
;	Twenty times per second code
;---------------------------------------------------------------------
HzN

	; Get inputs
		movf		PORTA,W
		movwf		Inputs

	; Check button state
		btfss		PBstate,PB1		; Was button down?
		goto		wasDown			; Yes
wasUp
		btfsc		Inputs,PB1		; Is button still up?
		return						; Was up and still up, do nothing
		bcf			PBstate,PB1		; Was up, remember now down
		return
wasDown
		btfss		Inputs,PB1		; If it is still down
		return						; Was down and still down, do nothing
		bsf			PBstate,PB1		; remember released

	; Button was down and now it's up,
	; we need to flip LEDstate
		movlw		H'01'			; Toggle LSB of LED
		xorwf		LEDstate,F		; state
		movlw		B'00001110'		; Turn off all LEDs
		movwf		Outputs
		return

;---------------------------------------------------------------------
;	Five times per second code
;---------------------------------------------------------------------
Hz5

	; Check whether we are doing this
		btfss		LEDstate,0		; Is LEDstate:0 = 0?
		return						; Yes, return

		movlw		LED1M			; Toggle LED1 state
		xorwf		Outputs,F		;
		call		SendOut			; Set outputs
		return

;---------------------------------------------------------------------
;	Two times per second code
;---------------------------------------------------------------------
Hz2

	; Check whether we are doing this
		btfsc		LEDstate,0	; Is LEDstate:0 = 0?
		return					; No, return

		movlw		LED2M			; Toggle LED2 state
		xorwf		Outputs,F		;
		call		SendOut			; Set outputs
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
		bsf			OPTION_REG,PS1	;  >- 1:16 prescale
		bsf			OPTION_REG,PS0	; /
;---------------------------------------------------------------------
;	Set up I/O 
;---------------------------------------------------------------------
		banksel		TRISB
		clrw						; 
		movwf		TRISB			; Make all port B output
		banksel		PORTA
		errorlevel	+302
		movlw		H'07'
		movwf		CMCON

;---------------------------------------------------------------------
;	Initialize memory
;---------------------------------------------------------------------
		movlw		B'00001110'		; Initially set all LEDs
		movwf		Outputs			; to off
		movwf		PORTB

		movlw		H'00'			; Initialize LED state
		movwf		LEDstate
		movlw		B'00010000'		; and pushbutton state
		movwf		PBstate

		movlw		HZ5TIME			; Initialize the counters
		movwf		Hz5Cnt			; for the three time domains
		movlw		HZ2TIME
		movwf		Hz2Cnt
		movlw		HZNTIME
		movwf		HzNCnt

;=====================================================================
; Main program loop here
;=====================================================================
main
		btfss		INTCON,T0IF		; Did timer overflow?
		goto		main			; No, hang around some more
		bcf			INTCON,T0IF		; reset overflow flag

;---------------------------------------------------------------------
;	Check for twenty times per second
;---------------------------------------------------------------------
		decfsz		HzNCnt,F		; Count down until HzN
		goto		$+4				; Not time yet
		movlw		HZNTIME			; Reset the counter so
		movwf		HzNCnt			; it's available next time
		call		HzN				; Go do 20X per second code

;---------------------------------------------------------------------
;	Check for five times per second
;---------------------------------------------------------------------
		decfsz		Hz5Cnt,F		; Count down until Hz5
		goto		$+4				; Not time yet
		movlw		HZ5TIME			; Reset the counter so
		movwf		Hz5Cnt			; it's available next time
		call		Hz5				; Go do 5X per second code

;---------------------------------------------------------------------
;	Check for two times per second
;---------------------------------------------------------------------
		decfsz		Hz2Cnt,F		; Count down until Hz2
		goto		$+4				; Not time yet
		movlw		HZ2TIME			; Reset the counter so
		movwf		Hz2Cnt			; it's available next time
		call		Hz2				; Go do twice per second code

		goto		main
		end
