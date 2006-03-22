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
;	$Revision: 1.3 $ $State: Exp $ $Date: 2006-03-22 12:35:30-04 $

			include		p16f873.inc
			__config	_RC_OSC&_WDT_OFF&_PWRTE_ON&_BODEN_OFF&_LVP_OFF&_DEBUG_OFF

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
			errorlevel	-302		; Turn off message
			banksel		TRISC		; Select TRIS bank
			movlw		PORTCMASK	; Pick up port mask
			movwf		TRISC		; and send it to TRISC
			banksel		PORTC		; Back to bank 0
			errorlevel	+302		; Message back on
			clrf		LEDstate	; Clear out shadow register

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
			movlw		DELAY		; Initialize outer
			movwf		c3			; loop counter
			clrf		c1			; Middle and inner loops
			clrf		c2			; will go full 256
Snore1		incfsz		c1,F		; Increment inner loop counter
			goto		Snore1		; No wrap? Do it again
			incfsz		c2,F		; Inner wrapped, incr middle
			goto		Snore1		; and do it again
			incfsz		c3,F		; Finally, the outer
			goto		Snore1		; Do it again unless
			return					; it expired, then quit.

			end
