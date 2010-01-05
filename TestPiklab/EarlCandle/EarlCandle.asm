; Candle.asm    Flicker the candle
; Outputs on B2, B3 and B4  Three rightmost LCD sockets
; Data table driven - one LED at a time is off.
; Earl's code modified for 84A (Piklab wouldn't program
; the 716 properly) and relocatable (Piklab kept trying
; to link the hex file).

	processor	pic16f84a
	include		"p16f84a.inc"
	__config	_XT_OSC & _WDT_OFF & _PWRTE_ON
	list		b=4,n=70

	udata
flag	res		1
num1	res		1
num2	res		1
num3	res		1  ; used in random

        errorlevel      -302            ;turn off wrong bank error
	code
        goto            start           ; Skip over interrupt vector
table   addwf   	PCL,f           ; Which LED is on table
;                	dt              B'00001110',B'00001100',B'00001010',B'00000110'
                	dt              B'00000000',B'00000010',B'00000100',B'00001000'


;=====================================================================
;  Mailine begins here -- Initialization
;=====================================================================

start
        banksel         TRISB                   ; switch to bank 1
        movlw           H'00'                   ; Set PORTB to be all outputs
        movwf           TRISB
        movlw           H'00'
        movwf           TRISA                   ;Port A all outputs
        movlw           B'00000110'
;        movwf           ADCON1                  ;Make Port A Digital
        banksel         PORTB                   ;Back to bank 0


        banksel         INTCON                  ;setup timer 0
        bcf             INTCON,T0IE             ;turn off timer interrupt
        banksel         OPTION_REG
        movlw           B'10000101'             ;enable timer0  set prescaler divide by 64
        movwf           OPTION_REG
        banksel         PORTB                   ;Back to bank 0
        movlw           D'2'                    ;(256-2) = 254
        movwf           TMR0
        movwf           num1
        movwf           num2            ; seed random
        movwf           flag            ;timing divisor

;--------------End Initialization

loop1   
        btfss   	INTCON,T0IF             ;did timer overflow?
        goto    	loop1                   ;no
        movlw   	D'1'                    ;
        movwf   	TMR0                    ; reset timer0
        bcf             INTCON,T0IF             ;reset overflow
        decfsz  	flag,f
        goto    	loop1

L3      call    	random          ; stir up random numbers
        movf    	num2,w          ; get a random number
        andlw   	B'00000011'     ; mask off to get 0 - 3
        call    	table
        movwf   	PORTB           ; shove output to port B
        movlw   	D'06'           ;reset timing constant
        movwf   	flag
        movf    	num3,w          ; get another random number
        andlw   	B'00000011'     ; select two bits 0-3
        addwf   	flag,f          ; vary timing constant 6 to 9
        goto 		loop1

random
        BCF     	STATUS,C
        RRF    		num1,F
        RRF    		num2,F
        RRF    		num3,F
        BTFSS   	STATUS,C
        RETURN
        MOVLW   	0xD7
        XORWF   	num1,f
        XORWF   	num2,f
        XORWF   	num3,f
        RETURN

        end