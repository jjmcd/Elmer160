; Lesson15a.asm - Encoder
;
;	Give a chance to see how the encoder outputs behave
;
;	In this very simple program, LEDs 1 and 2 simply follow
;	the encoder inputs.  With the soft detents on the Panasonic
;	encoder supplied with the PIC-EL, it would be helpful to
;	use a large knob to see this behavior.
;
; WB8RCR - 4-Aug-04
; $Revision: 1.3 $ $Date: 2011-12-21 10:35:02-04 $
;
;=====================================================================

		processor	pic16f628a
		include		P16F628A.INC
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BODEN_OFF
		list		b=4,n=70

; Port bit assignments
LED1	equ			3	; LED1 on PORTB
LED2	equ			2	; LED2 on PORTB
LED3	equ			1	; LED3 on PORTB
ENC1	equ			0	; Encoder 1 on PORTA
ENC2	equ			1	; Encoder 2 on PORTA

		cblock		H'20'
			Output
		endc
;	Mainline begins here

Start
	; Set the LEDs to be outputs
		banksel		TRISB		; Select bank 1
		errorlevel	-302		; Yes, we know!
		bcf			TRISB,LED1	; Clear the TRIS bits
		bcf			TRISB,LED2	; for each of the LEDs
		bcf			TRISB,LED3	; making them outputs
		errorlevel	+302		; Back on just in case
		banksel		PORTB		; Back to bank 0
		movlw		H'07'
		movwf		CMCON
Loop
	; Turn off all LED's in ouptut word
		movlw		B'00001110'	; LED outputs are HIGH
		movwf		Output		; to turn LED off
	; Set current status into Output
		btfsc		PORTA,ENC1	; ENC1 low?
		bcf			Output,LED1	; No, turn on LED1
		btfsc		PORTA,ENC2	; ENC2 low?
		bcf			Output,LED2	; No, turn on LED2
	; Send the outputs
		movf		Output,W	; Pick up the output word
		movwf		PORTB		; and send it to PORTB
		goto		Loop		; Do it again

		end
