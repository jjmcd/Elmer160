; Encoder Reader
; for use with encoder supplied with PicEl
; Uses SIGGEN method for Non-slip

		processor	pic16f84a
		include		"p16f84a.inc"
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON
		list		b=4,n=70

;=====================================================================
;	Manifest Constants
;=====================================================================
LED1	equ			H'03'			; PORTB bit number for LED
LED2	equ			H'02'			; PORTB bit number for LED
LED3	equ			H'01'			; PORTB bit number for LED
MASKA	equ			B'11111111'		; PORTA all inputs
MASKB	equ			B'00000000'		; PORTB all outputs

;=====================================================================
;	File register use
;=====================================================================
	cblock		H'20'
		old			;old encoder reading
		new			;curent encoder reading
		olddir		;old direction
		newdir		;new direction
		blink		; blinks LED 2
		Count		;used in delay routine
		endc

	goto		start			; Skip over interrupt vector
	org			H'05'

;=====================================================================
;  Mailine begins here -- Initialization
;=====================================================================
start
	banksel		TRISB			;
	movlw		MASKB			; Set PORTB to be all outputs
	movwf		TRISB
	banksel		PORTB
	movf		PORTA,w		;get initial encoder data
	andlw		H'03'		;initialize variables
	movwf		old	
	clrf		olddir
	clrf		blink
;=====================================================================
; Main program loop here
;=====================================================================

main

	call	read

    	;Compare previous encoder inputs (old) with latest ones (new).
	movf	new,W	;Move the contents of new to W
	xorwf   old,W    ;XOR previous old with new to see if they are equal.
	skpnz		  	;Test result and skip next line if non 0.
	goto    main     ;Result is 0. Rotary encoder did not move.

     ;Result is 1.  Rotary encoder moved.  Determine direction.  

	bcf	STATUS,C  	;Clear the carry bit in the status register and
	rlf     old,F     	;left shift
	movf    new,W     	;Move the contents of new to W in order to XOR.
	xorwf   old,W    	;XOR previous inputs to determine CW or CCW.
	andlw	H'02'
	movwf	newdir
	xorwf	olddir,F	;XOR to see if same direction as last
	skpz				;No change in direction
	goto	J1			;Ignore this transition - possible change
good:
	btfsc	newdir,1   ;Test bit 1 of result
	goto	right      ;Bit is 1 (direction is CW). 
	goto	left

left	
	bsf		PORTB,LED3
	bcf		PORTB,LED1
	goto	J2

right	
	bcf		PORTB,LED3
	bsf		PORTB,LED1

J2	bsf		PORTB,LED2 		;toggle LED 2
	movlw	H'01'
	xorwf	blink,F
	skpz
	bcf		PORTB,LED2

J1	movf	new,w			;New data to old
	movwf	old
	movf	newdir,w
	movwf	olddir
	goto main

read	;waste some time then Read encoder
	movlw	h'ff'
	movwf	Count
	decfsz	Count,f
	goto	$-1
	movf	PORTA,w		;get encoder data
	andlw	H'03'
	movwf	new
	return

	end





