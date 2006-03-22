			title		'L19c - Example of PWM output'
			subtitle	'Part of Lesson 19'
			list		b=4,c=132,n=77,x=Off

;------------------------------------------------------------------------
;**
;	L19c
;
;	This program reads the voltage on AN0, and uses that voltage
;	to set the duty cycle for the PWM output.  It is expected that
;	a pot allows adjusting the voltage on AN0 and an LED is 
;	connected to CCP1 so that turning the pot results in changing
;	the brightness of the LED.
;
;**
;	WB8RCR - 8-Feb-06
;	$Revision: 1.3 $ $State: Exp $ $Date: 2006-03-22 10:43:58-04 $

			include		p16f873.inc
			__config	_WDT_OFF&_PWRTE_ON&_BODEN_OFF&_LVP_OFF&_DEBUG_OFF

#define PORTCMASK B'11111011'		; TRIS mask for port C
#define ADCOSC		B'11000000'		; ADC use internal RC
#define CHANNEL0	B'00000000'		; ADC channel 0 (RA0/AN0)
#define CHANNEL4	B'00100000'		; ADC channel 4 (RA5/AN4)
#define ADCON		B'00000001'		; ADC power on

			udata_shr
c1			res			1	; Counter for ADC delay
ADCval		res			1	; Pot position
DSH			res			1
DSL			res			1

STARTUP		code
			goto		Start
PROG1		code
Start
	; ------------------------------------------------------
	; Initialize the A/D converter
	; ------------------------------------------------------
	; Set the A/D to left justified, use Vdd, Vss as refs
			banksel		ADCON1
			errorlevel	-302
			movlw		B'00000000'	; All analog
;			movlw		B'00001110'	; RA0 analog, others digital
			movwf		ADCON1
			errorlevel	+302
	; Select channel etc.
	;	7-6 = 11 Frc
	;	5-3 = 100 channel 4
	;	2 = 0 conversion not started
	;	1 = don't care
	;	0 = 1 A/D converter turned on
			banksel		ADCON0
			movlw		ADCOSC | CHANNEL0 | ADCON
			movwf		ADCON0

	; ------------------------------------------------------
	; Set the PWM period
	; ------------------------------------------------------
		; PR2 sets the period
			banksel		PR2
			movlw		H'80'
			movwf		PR2
		; Clear TRISC<2>
			banksel		TRISC
			movlw		PORTCMASK
			movwf		TRISC
		; TMR2 prescaler scales the period and duty cycle
			banksel		T2CON
			movlw		B'00000111'
			movwf		T2CON
		; Configure CCP1 for PWM
			banksel		CCP1CON
			movlw		H'0f'
			movwf		CCP1CON
			banksel		PORTA

Loop
	; ------------------------------------------------------
	; Pick up the value from the ADC
	; ------------------------------------------------------

	; Hang around a while to charge the cap
			decfsz		c1,F			; This is a longer wait
			goto		Loop			; than needed but easy
	; Start the conversion
			bsf			ADCON0,GO		; GO=1 starts conversion
	; Wait for conversion to complete
Conv
			btfsc		ADCON0,GO		; Hardware clears GO
			goto		Conv			; when A/D complete
	; Pick up the value
			movf		ADRESH,W		; Only using 8 MSBs
			movwf		ADCval			; of analog value

	; ------------------------------------------------------
	; Now set the duty cycle depending on the ADC result
	; ------------------------------------------------------

		; ADC value in W already
			movwf		DSH				; Save into hi 8 bits
			movwf		DSL				; and also into low
			bcf			STATUS,C		; Rotate high one bit
			rrf			DSH,F			; making sure <7> clear
			swapf		DSL,F			; Move bit <1> into
			rlf			DSL,F			; <5>
			movlw		H'20'			; and mask unneeded bits
			andwf		DSL,F			;
			movlw		H'0c'			; Maintain PWM mode in
			iorwf		DSL,F			; CCP1M
			banksel		CCPR1L			; 
			movf		DSH,W			; Set high 8 bits of
			movwf		CCPR1L			; duty cycle
			banksel		CCP1CON			;
			movf		DSL,W			; And low 2 bits
			movwf		CCP1CON			;
;			banksel		PORTA			; CCP1CON in bank0 

			goto		Loop

			end
