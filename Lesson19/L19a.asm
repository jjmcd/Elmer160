			title		'L19a - Blink an LED'
			subtitle	'Part of Lesson 19'
			list		b=4,c=132,n=77,x=Off

;------------------------------------------------------------------------
;**
;	L19b
;
;	This program simply blinks an LED on PORTC<2>.
;	It is intended to be a simple way to satisfy ourselves that
;	ICSP is working.
;
;**
;	WB8RCR - 8-Feb-06
;	$Revision: 1.2 $ $State: Exp $ $Date: 2006-03-14 15:49:20-04 $

			include		p16f873.inc

			__config	_WDT_OFF&_PWRTE_ON&_BODEN_OFF&_LVP_OFF&_DEBUG_OFF

#define PORTCMASK B'11111011'		; TRIS mask for port C
#define DELAY H'fc'					; Delay counter - higher=shorter

			udata_shr
c1			res			1			; Counter for
c2			res			1			; long delay
c3			res			1			; Really long
LEDstate	res			1			; Current LED state

STARTUP		code
			goto		Start
PROG1		code
Start
	; ------------------------------------------------------
	; Set the LED pin to output
	; ------------------------------------------------------
			errorlevel	-302
			banksel		TRISC
			movlw		PORTCMASK
			movwf		TRISC
			banksel		PORTC
			errorlevel	+302
			clrf		LEDstate

	; ------------------------------------------------------
	; Main program loop
	; ------------------------------------------------------
Loop
			movf		LEDstate,W	; Check and see if the
			btfsc		STATUS,Z	; LEDstate is zero
			goto		SetHi		; Yes, set it
			clrf		LEDstate	; No, clear it
			goto		SetLED		; skip over set
SetHi		movlw		D'4'		; Set the LED bit
			movwf		LEDstate	; to turn LED off
SetLED		movf		LEDstate,W	; Pick up the LED state
			movwf		PORTC		; and send it to PORTC
			call		Snore		; Wait a long while
			goto		Loop		; Go do it again

	; ------------------------------------------------------
	; Routine to hang around a while (~2 s @ 1.4 MHz)
	; ------------------------------------------------------
Snore
			movlw		DELAY
			movwf		c3
			clrf		c1
			clrf		c2
Snore1		incfsz		c1,F
			goto		Snore1
			incfsz		c2,F
			goto		Snore1
			incfsz		c3,F
			goto		Snore1
			return

			end
