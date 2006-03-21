			title		'L19b - Example of analog input'
			subtitle	'Part of Lesson 19'
			list		b=4,c=132,n=77,x=Off

;------------------------------------------------------------------------
;**
;	L19b
;
;	This program reads the voltage on AN0, and turns off RC2 if
;	the voltage exceeds half-scale. It is expected that
;	a pot allows adjusting the voltage on AN0 and an LED is 
;	connected to RC2 so that turning the pot results in turning
;	the LED on and off.
;
;**
;	WB8RCR - 8-Feb-06
;	$Revision: 1.2 $ $State: Exp $ $Date: 2006-03-21 19:48:20-04 $

			include		p16f873.inc

			__config	_WDT_OFF&_PWRTE_ON&_BODEN_OFF&_LVP_OFF&_DEBUG_OFF

#define LED 2						; Bit for the LED
#define PORTCMASK B'11111011'		; TRIS mask for port C

#define ADCOSC		B'11000000'		; ADC use internal RC
#define CHANNEL0	B'00000000'		; ADC channel 0 (RA0/AN0)
#define CHANNEL4	B'00100000'		; ADC channel 4 (RA5/AN4)
#define ADCON		B'00000001'		; ADC power on

			udata_shr
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
			errorlevel	-302
			banksel		ADCON1		; Set all to analog since
			clrf		ADCON1		; AN1-4 all disconnected
			bcf			ADCON1,ADFM
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
	; Set the LED pin to output
	; ------------------------------------------------------
			banksel		TRISC
			movlw		PORTCMASK
			movwf		TRISC
			banksel		PORTC
			errorlevel	+302
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
