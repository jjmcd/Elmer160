		title		"PORTB Test                      John J. McDonough - 23-Feb-04"
; ----------------------------------------------------------------------
; FILE     : Harley.asm                                                *
; CONTENTS : Exercise PORTB for testing                                *
; COPYRIGHT: 2004 John J. McDonough, WB8RCR                            *
; AUTHOR   : John J. McDonough, WB8RCR                                 *
; VERSION  : 1.0                                                       *
;------------------------------------------------------------------------
		list		b=4,c=132,n=77,x=Off
		processor	16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON


		cblock	020h
			Cnt1
			Cnt2
			Cnt3
			Wanted
			Output
		endc

; ------------------------------------------------------------------------
;	Manifest Constants
LED1	equ			D'3'		; LED 1 bit number
LED2	equ			D'2'		; LED 2 bit number
LED3	equ			D'1'		; LED 3 bit number
CNT1	equ			D'100'
CNT2	equ			D'100'
CNT3	equ			D'100'

; ------------------------------------------------------------------------
		org			0
		goto		Start1
		org			5		; Skip past interrupt vector

Delay
		movlw		CNT1
		movwf		Cnt1
Del1
		movlw		CNT2
		movwf		Cnt2
Del2
		movlw		CNT3
		movwf		Cnt3
Del3
		decfsz		Cnt3,F
		goto		Del3
		decfsz		Cnt2,F
		goto		Del2
		decfsz		Cnt1,F
		goto		Del1
		return


		subtitle	"Initialization"
		page
; ------------------------------------------------------------------------
;	Initialize counters and ports

Start1:
		; PORTB connections as follows:
		;
		;  RB0 - LCD DB4 / PB4
		;  RB1 - LCD DB5 / LED1
		;  RB2 - LCD DB6 / LED2
		;  RB3 - LCD DB7 / LED3
		;  RB4 - HD44780 Enable
		;  RB5 - HD44780 Read/Write (1=read)
		;  RB6 - HD44780 Register Select (1=data, 0=instruction)
		;  RB7 - Xmtr / DDS
		errorlevel	-302
		banksel		TRISB
		movlw		H'00'			; All bits output
		movwf		TRISB
		banksel		PORTB

TestLoop:
		movlw		B'11111010'
		movwf		PORTB
		call		Delay

		movlw		B'11111101'
		movwf		PORTB
		call		Delay

		movlw		B'11111011'
		movwf		PORTB
		call		Delay

		movlw		B'11110101'
		movwf		PORTB
		call		Delay

		movlw		B'11101011'
		movwf		PORTB
		call		Delay

		movlw		B'11011101'
		movwf		PORTB
		call		Delay

		movlw		B'10111011'
		movwf		PORTB
		call		Delay

		movlw		B'01111101'
		movwf		PORTB
		call		Delay

		goto		TestLoop
		end
