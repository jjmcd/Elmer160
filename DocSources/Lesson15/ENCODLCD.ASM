; ENCODLCD.asm
; Select digit with Encoder
; Display on LCD
; Button PB-3 advances cursor position

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
ENA		equ			H'00'			; PORTA bit number for encoder
ENB		equ			H'01'			; PORTA bit number for encoder
MASKA	equ			B'11111111'		; PORTA all inputs
MASKB	equ			B'00000000'		; PORTB all outputs

;=====================================================================
;	File register use
;=====================================================================
		cblock		H'20'
			Count					; Storage
			store					; Storage for outputs
			Letter				; Letter to transmit to LCD
			Index				; Which letter to send
			position			; Cursor position on LCD
			LetHi				; High order nybble of letter
			J					; delay outer loop counter
			K					; delay inner loop counter
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
		call		InitLCD			; Initialize LCD
		clrf		position		; LCD position zero
		movlw		A'A'			; Start with letter A
		movwf		Index
		call		Show			;Display initial "A"

;=====================================================================
; Main program loop here
;=====================================================================

main

	call	detent	;Make sure encoder is at detent
	call	detent	;make double sure

	bcf		PORTB,LED2	;LED ON when at detent

L5	call	delay		;debounce & read PORT A
	btfss	store,ENA	;wait for negative transition
	goto 	right		;on either input
	btfss	store,ENB
	goto	left
	btfss	store,2		;test for button 3 pressed
	goto 	Button
	goto 	L5

left					;Turned LEFT
	incf	Index,f		;Back up one letter
	call	Show		;Show it on LCD
	bsf		PORTB,LED3	;Turn off LED 3
	bcf		PORTB,LED1
	goto	L3

right					;Turned RIGHT
	decf	Index,f		;Advance one letter
	call 	Show
	bcf		PORTB,LED3	;Turn on LED 3
	bsf		PORTB,LED1

L3	bsf		PORTB,LED2	;LED OFF
	goto main

Show		;Set cursor and display character in LCD
	movlw	H'80'		; Set LCD cursor position
	addwf	position,w
	call 	ComOut		; h'80' + cursor position
	movlw	H'7F'
	andwf	Index,w		;Get character & mask high bit
	call	LetterOut	;Send to LCD
	return

delay	;Read encoder then waste some time
	movlw	h'ff'		;delay counter
	movwf	Count
	movf	PORTA,w		;get encoder data
	movwf	store		;save it
	decfsz	Count,f
	goto	$-1
	return

Button		;Handle button 3 press
	incf	position,w		;move cursor to right
	andlw	H'07'			;limit to position 7
	movwf	position		;current writing position
L8	call	delay
	btfss	store,2			;wait for button release
	goto	L8
	goto	main

detent ; Wait until encoder is at detent
	call	delay
	btfss	store,ENA	;If Encoder A or B is low, recycle
	goto	$-2
	btfss	store,ENB
	goto	$-4
	return


; LCD Driver Routines
;	Initialize counters and ports

Start1:
	; Send a command nybble to the LCD
SendI:
		andlw	00fh		; only use low order 4 bits
							; FALL THROUGH to SendLCD
	; Send data to the LCD
SendLCD:
		movwf	PORTB		; Send data to PORTB
		bsf		PORTB,H'04'	; turn on enable bit RB4
		nop
		nop
		nop
		bcf		PORTB,H'04'	; clear enable bit  RB4
		call	ShortDelay
		return


	; Send a letter to the LCD
LetterOut:
		movwf	Letter		; save off the letter
		andlw	0f0h		; high nybble
		movwf	LetHi		; Save hi nybble
		rrf		LetHi,F		; And move it to the right
		rrf		LetHi,F		;
		rrf		LetHi,F		;
		rrf		LetHi,F		;
		movfw	LetHi		; Pick it up
		iorlw	H'40'		; RB6 hi - LCD data mode
		call	SendLCD

		movfw	Letter		; get it
		andlw	00fh		; Mask off high stuff
		iorlw	H'40'		; RB6 hi - LCD data mode
		call	SendLCD
		return

	; Send a Command to the LCD
ComOut:
		movwf	Letter		; save the letter
		andlw	0f0h		; high nibble
		movwf	LetHi		; Save hi nibble
		rrf		LetHi,F		; And move it to the right
		rrf		LetHi,F		;
		rrf		LetHi,F		;
		rrf		LetHi,F		;
		movfw	LetHi		; Pick it up
		call	SendLCD
		call 	MedDelay
		movfw	Letter		; get it
		andlw	00fh		; Mask off high stuff
		call	SendLCD
		call	MedDelay
		return

; ------------------------------------------------------------------------
	; Initialize the LCD
InitLCD:
		
		clrf		PORTB			; port B itself

		movlw		B'00000000'		; All bits as output
		tris		PORTB

		;wait 200ms after power up 
		call	LongDelay

		; Initialize the LCD to 4 bits
		; send 0x03 3 times followed by 0x02 
		; to wake up LCD and get it into 4 bit data mode

		movlw	H'3'
		call 	SendI		;set 8 bit mode
		call 	MedDelay
		call 	MedDelay
		call 	SendI		;set 8 bit mode again
		call 	MedDelay
		call	SendI		;set 8 bit mode again
		call	MedDelay
		movlw	H'2'
		call	SendI		;set 4 bit mode
		call	MedDelay

		; Now set up the display the way we want it

		movlw	H'20'	; Function set  001a bxxx
		call	ComOut	; a=data length 0=4 1=8
						; b=Lines on Display 0=1 1=2

		movlw	H'06'	; Entry Mode 0000 01ab
		call ComOut		; a=1 increment shift  b=1 shift on

		movlw   H'0C'	; display on, cursor off, blink off
		call ComOut		; 0000 1abc a=on  b=cursor off c=blink off

		movlw	H'01'	; Clear Display & home cursor
		call ComOut

		movlw	H'80'	; Set LCD cursor to position 0
		call ComOut		; h'80' + cursor position

		return

LongDelay:
		; Waste time 3 Inst/loop * 255 * 255 = 200 ms approx
		movlw		D'255'			; w := 255 decimal
		goto kk

MedDelay:   
		; Waste time 3 Inst/loop * 40 * 40 = 5 ms approx
		movlw		D'40'			; w := 40 decimal
		goto kk

ShortDelay:
		; Waste some   3 inst/loop * 6 * 6 = 100 us
		movlw		D'6'		; w =6 decimal
kk		movwf		J			; J = w
jloop:	movwf		K			; K = w
kloop:	decfsz		K,F			; K = K-1, skip next if zero
		goto 		kloop
		decfsz		J,F			; J = J-1, skip next if zero
		goto		jloop
		return

		end
