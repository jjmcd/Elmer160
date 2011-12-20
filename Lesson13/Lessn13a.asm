; Lesson13a.asm - demonstration of using TMR0 register
;
;  Blink LEDs at three different rates
;
;  WB8RCR - 3-Mar-04
;
;=====================================================================

		processor	pic16f628a
		include		"P16F628A.INC"
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BODEN_OFF
		list		b=4,n=70

;=====================================================================
;	Manifest Constants
;=====================================================================
LED1M	equ			B'0001000'	; Mask for LED1
LED2M	equ			B'0000100'	; Mask for LED2
LED3M	equ			B'0000010'	; Mask for LED3
HZ1TIME	equ			D'244'		; Clock ticks for 1/sec
HZ2TIME	equ			D'122'		; Clock ticks for 2/sec
HZ3TIME	equ			D'81'		; Clock ticks for 3/sec

;=====================================================================
;	File register use
;=====================================================================
		cblock		H'20'
			Hz1Cnt				; Once per second counter
			Hz2Cnt				; Twice per second counter
			Hz3Cnt				; Thrice per second counter
			Outputs				; Output storage
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
;	Three times per second code
;---------------------------------------------------------------------
Hz3
		movlw		LED3M			; Toggle LED3 bit by
		xorwf		Outputs,F		; XORing with current state
		call		SendOut			; Set outputs
		return

;---------------------------------------------------------------------
;	Two times per second code
;---------------------------------------------------------------------
Hz2
		movlw		LED2M			; Toggle LED2 bit by
		xorwf		Outputs,F		; XORing with current state
		call		SendOut			; Set outputs
		return

;---------------------------------------------------------------------
;	Once per second code
;---------------------------------------------------------------------
Hz1
		movlw		LED1M			; Toggle LED1 bit by
		xorwf		Outputs,F		; XORing with current state
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
	; Normally, we would have simply loaded a constant, but
	; the code below makes it explicit what we are doing
		banksel		OPTION_REG
		bcf			OPTION_REG,T0CS	; Enable timer
		bcf			OPTION_REG,PSA	; Prescaler to timer
		bcf			OPTION_REG,PS2	; \
		bsf			OPTION_REG,PS1	;  >- 1:16 prescale
		bsf			OPTION_REG,PS0	; /
;---------------------------------------------------------------------
;	Set up I/O 
;---------------------------------------------------------------------
		banksel		TRISB			; 
		clrw						; Make all PORTB bits output
		movwf		TRISB			; 
		banksel		PORTA			; Back to bank 0
		errorlevel	+302
		movlw		H'07'
		movwf		CMCON

;---------------------------------------------------------------------
;	Initialize memory
;---------------------------------------------------------------------
		movlw		B'00001110'		; Initially set all LEDs
		movwf		Outputs			; to off
		movlw		HZ1TIME			; Initialize the counters
		movwf		Hz1Cnt			; for the three time domains
		movlw		HZ2TIME
		movwf		Hz2Cnt
		movlw		HZ3TIME
		movwf		Hz3Cnt

;=====================================================================
; Main program loop here
;=====================================================================
main
		btfss		INTCON,T0IF		; Did timer overflow?
		goto		main			; No, hang around some more
		bcf			INTCON,T0IF		; reset overflow flag

;---------------------------------------------------------------------
;	Check for three times per second
;---------------------------------------------------------------------
		decfsz		Hz3Cnt,F		; Count down until Hz3
		goto		$+4				; Not time yet
		movlw		HZ3TIME			; Reset the counter so
		movwf		Hz3Cnt			; it's available next time
		call		Hz3				; Go do thrice per second code

;---------------------------------------------------------------------
;	Check for two times per second
;---------------------------------------------------------------------
		decfsz		Hz2Cnt,F		; Count down until Hz2
		goto		$+4				; Not time yet
		movlw		HZ2TIME			; Reset the counter so
		movwf		Hz2Cnt			; it's available next time
		call		Hz2				; Go do twice per second code

;---------------------------------------------------------------------
;	Check for once per second
;---------------------------------------------------------------------
		decfsz		Hz1Cnt,F		; Count down until Hz1
		goto		$+4				; Not time yet
		movlw		HZ1TIME			; Reset the counter so
		movwf		Hz1Cnt			; it's available next time
		call		Hz1				; Go do once per second code

		goto		main
		end
