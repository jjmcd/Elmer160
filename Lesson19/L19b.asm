			title		'L19b - Example of analog input'
			subtitle	'Part of Lesson 19'
			list		b=4,c=132,n=77,x=Off

;------------------------------------------------------------------------
;**
;	L19b
;
;	This program reads the voltage on AN4, and turns off RC2 if
;	the voltage exceeds half-scale. It is expected that
;	a pot allows adjusting the voltage on AN4 and an LED is 
;	connected to RC2 so that turning the pot results in turning
;	the LED on and off.
;
;**
;	WB8RCR - 8-Feb-06
;	$Revision: 1.1 $ $State: Exp $ $Date: 2006-02-08 19:51:04-05 $

			include		p16f876.inc

			__config	_WDT_OFF&_PWRTE_ON&_BODEN_OFF&_LVP_OFF&_DEBUG_OFF
			errorlevel	-302

#define LED 2						; Bit for the LED
#define PORTCMASK B'11111011'		; TRIS mask for port C

#define ADCOSC		B'11000000'		; ADC use internal RC
#define CHANNEL4	B'00100000'		; ADC channel 4 (RA5/AN4)
#define ADCON		B'00000001'		; ADC power on

			udata
c1			res			1	; Counter for ADC delay
LEDstate	res			1	; Current LED state
ADCval		res			1	; Pot position

STARTUP		code
			goto		Start
PROG1		code
Start
	; ------------------------------------------------------
	; Initialize the A/D converter
	; ------------------------------------------------------
	; Set the A/D to left justified, use Vdd, Vss as refs
			banksel		ADCON1
			clrf		ADCON1
			bcf			ADCON1,ADFM
			banksel		ADCON0
	; Select channel etc.
	;	7-6 = 11 Frc
	;	5-3 = 100 channel 4
	;	2 = 0 conversion not started
	;	1 = don't care
	;	0 = 1 A/D converter turned on
			movlw		ADCOSC | CHANNEL4 | ADCON
			movwf		ADCON0

	; ------------------------------------------------------
	; Set the LED pin to output
	; ------------------------------------------------------
			banksel		TRISC
			movlw		PORTCMASK
			movwf		TRISC
			banksel		PORTC
			clrf		LEDstate

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
	; Now set the LED state depending on the ADC result
	; ------------------------------------------------------
			clrf		LEDstate		; Initially set to on
			movlw		H'80'			; Compare ADC value
			subwf		ADCval,W		; to midscale
			btfss		STATUS,C		; Greater?
			bsf			LEDstate,LED	; No, turn off LED
			movf		LEDstate,W		; Pick up LED state
			movwf		PORTC			; and send to LED

			goto		Loop			; Go do it again

			end
