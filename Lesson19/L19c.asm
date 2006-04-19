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
;	$Revision: 1.7 $ $State: Exp $ $Date: 2006-04-19 16:23:08-04 $

			include		p16f873.inc
			__config	_RC_OSC&_WDT_OFF&_PWRTE_ON&_BODEN_OFF&_LVP_OFF&_DEBUG_OFF

#define PORTCMASK	B'11111011'		; TRIS mask for port C
#define ADCOSC		B'11000000'		; ADC use internal RC
#define CHANNEL0	B'00000000'		; ADC channel 0 (RA0/AN0)
#define ADCON		B'00000001'		; ADC power on

RAM0		udata_shr
c1			res			1	; Counter for ADC delay
c2			res			1
AnaH		res			1	
AnaL		res			1

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
			movwf		ADCON1
			errorlevel	+302
	; Select channel etc.
	;	7-6 = 11 Frc
	;	5-3 = 000 channel 0
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
			errorlevel	-302
			banksel		PR2
			movlw		H'fe'			; Setting period to max
			movwf		PR2				; gives max resolution
		; Set PWM pin to be an output
			banksel		TRISC	
			movlw		PORTCMASK		; Clear TRISC<2>
			movwf		TRISC			;
		; TMR2 prescaler scales the period and duty cycle
			banksel		T2CON
			movlw		B'00000101'		; TMR2 on <2>, prescale
			movwf		T2CON			; to 1:4 <0:1>
		; Configure CCP1 for PWM
			banksel		CCP1CON
			movlw		H'0f'			; <3:0> all 1's for PWM
			movwf		CCP1CON			; <5:4> is duty cycle LSB
			banksel		PORTA
			errorlevel	+302

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
			movf		ADRESH,W		; Get top 8 bits
			movwf		AnaH			; Save into hi 8 bits
			movf		ADRESL,W		; Grab low 2 bits and
			movwf		AnaL			; save into low

	; ------------------------------------------------------
	; Now set the duty cycle depending on the ADC result
	; ------------------------------------------------------

		; Move the high two bits of AnaH to bits <5:4>
			movlw		H'c0'			; First mask off low
			andwf		AnaL,F			; bits of AnaL
			bcf			STATUS,C		; Rotate high one bit
			rrf			AnaL,F			; making sure <7> clear
			rrf			AnaL,F			; Here we know <7> clear
		; Set the high 8 bits of the duty cycle
			movf		AnaH,W			; Set high 8 bits of
			movwf		CCPR1L			; duty cycle
		; and now the low 8 bits
			movlw		H'0f'			; Need to keep PWM mode
			iorwf		AnaL,W			; OR in low analog bits
			movwf		CCP1CON			; and send to CCP1CON

		; Spend some time so that PWM actually has a chance
		; to happen before we go changing it
			movlw		.39				; About a ms
			movwf		c2
L1
			decfsz		c1,F			; Give PWM a shot
			goto		L1				; 
			decfsz		c2,F			; Yeah, its a long wait
			goto		L1				;

			goto		Loop			; Play it again, Sam

			end
