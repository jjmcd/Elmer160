;	Elmer 160 Lesson 14e - 9 June 2004
;
;	Read a message in EEPROM and send it out as Morse.
;

		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON
		list		b=4,n=72

;	Morse speed adjust, higher values mean slower code
SPEED	equ			H'47'

;	Bits in PORTB used:
XMTR	equ			H'02'	; Transmit LED bit
KEY		equ			H'07'	; Key transmitter bit

;	FIle register usage
		cblock		H'20'
			L1				; Outer timing counter
			L2				; Inner timing counter
			LtrToSend		; Letter currently being sent
			BitCount		; How far we are decoding Morse
			LetterNum		; Current location in message
		endc

		goto		Start	; Skip to mainline

;   Morse table for characters with 5 or fewer elements and
;	a select few with six.
;
;	High 6 bits are elements, right 3 are count.  A 1 bit means
;	a dah, a 0 bit means a dit.  Six element characters are
;	included here if the last element is a dah.  Otherwise, they
;	are coded with a count of zero.  In that case, the left 5
;	bits are the index into Morse2.

Morse							;  ASCII  Morse
		addwf		PCL,F		; graphic  sent
		dt			B'00000000'	;	 		sp
		dt			B'10101110'	;	!		!
		dt			B'10110110'	;	"		"
		dt			B'01000101'	;	#		AS
		dt			B'01000000'	;	$		$
		dt			B'01010101'	;	%		AR
		dt			B'00010110'	;	&		SK
		dt			B'00001000'	;	'		'
		dt			B'10110101'	;	(		(
		dt			B'10110110'	;	)		)
		dt			B'01010100'	;	*		AA
		dt			B'01010101'	;	+		+
		dt			B'11001110'	;	,		,
		dt			B'10000110'	;	-		-
		dt			B'00010000'	;	.		.
		dt			B'10010101'	;	/		/
		dt			B'11111101'	;	0		0
		dt			B'01111101'	;	1		1
		dt			B'00111101'	;	2		2
		dt			B'00011101'	;	3		3
		dt			B'00001101'	;	4		4
		dt			B'00000101'	;	5		5
		dt			B'10000101'	;	6		6
		dt			B'11000101'	;	7		7
		dt			B'11100101'	;	8		8
		dt			B'11110101'	;	9		9
		dt			B'00011000'	;	:		:
		dt			B'00100000'	;	;		;
		dt			B'00000000'	;	<		sp
		dt			B'10001101'	;	=		=
		dt			B'00000000'	;	>		sp
		dt			B'00101000'	;	?		?
		dt			B'00110000'	;	@		@
		dt			B'01000010'	;	A		A
		dt			B'10000100'	;	B		B
		dt			B'10100100'	;	C		C
		dt			B'10000011'	;	D		D
		dt			B'00000001'	;	E		E
		dt			B'00100100'	;	F		F
		dt			B'11000011'	;	G		G
		dt			B'00000100'	;	H		H
		dt			B'00000010'	;	I		I
		dt			B'01110100'	;	J		J
		dt			B'10100011'	;	K		K
		dt			B'01000100'	;	L		L
		dt			B'11000010'	;	M		M
		dt			B'10000010'	;	N		N
		dt			B'11100011'	;	O		O
		dt			B'01100100'	;	P		P
		dt			B'11010100'	;	Q		Q
		dt			B'01000011'	;	R		R
		dt			B'00000011'	;	S		S
		dt			B'10000001'	;	T		T
		dt			B'00100011'	;	U		U
		dt			B'00010100'	;	V		V
		dt			B'01100011'	;	W		W
		dt			B'10010100'	;	X		X
		dt			B'10110100'	;	Y		Y
		dt			B'11000100'	;	Z		Z
		dt			B'00000000'	;	[		sp
		dt			B'00000000'	;	\		sp
		dt			B'00000000'	;	]		sp
		dt			B'00000000'	;	^		sp
		dt			B'00110110'	;	_		_
;
;	Morse table for characters with 6 or 7 elements, no count in table
;
Morse2
		addwf		PCL,F
		dt			H'00'		;	
		dt			B'01111000'	;	'		'
		dt			B'01010100'	;	.		.
		dt			B'11100000'	;	:		:
		dt			B'10101000'	;	;		;
		dt			B'00110000'	;	?		?
		dt			B'01101000'	;	@		@
		dt			H'00'		;	unused
		dt			B'00010010'	;	$		$  (7 elements)

;	Send a Morse letter.  ASCII codes 32 through 95 are handled
;   although some codes where there is no Morse character have been
;	commandeered for prosigns as follows:
;
;		#	AS
;		%	AR
;		&	SK
;		*	AA
;
;	The following characters are sent as a space:
;		space, <, >, [, \, ], ^
;
;	Lower case letters in the input will be translated improperly

SendLtr
		movwf		LtrToSend		; Save off the ASCII code
		movlw		D'32'			; Subtract 32 since low codes
		subwf		LtrToSend,W		; are nonprinting
		andlw		H'3f'			; Force into range 0-3f
		call		Morse			; Look up char in table
		movwf		LtrToSend		; Save off result from table
		andlw		H'7'			; Mask off the count bits
		movwf		BitCount		; and save off the count
		btfsc		STATUS,Z		; If the element count was zero
		goto		Special			; character needs special handling
EleLoop
		rlf			LtrToSend,F		; Rotate the next element to carry
		btfsc		STATUS,C		; Set?
		goto		SendDah			; Yes, it's a dah
		call		Dit				; No, it's a dit
		goto		EndLoop			;
SendDah
		call		Dah
EndLoop
		decfsz		BitCount,F		; Count down bit counter
		goto		EleLoop			; Not done yet, go do next element
		goto		LetSpc			; Inter-character space

;	Special character here
;
;	If count in table was zero, then the high 5 bits are
;	used as an index into table 2.  If the index is zero,
;	the character is a space.  If the index is 8, the character
;	is a dollar sign (7 elements).  All others have 6 elements.
;
Special
		rrf			LtrToSend,F		; Move count off right
		rrf			LtrToSend,F
		rrf			LtrToSend,F
		movf		LtrToSend,W		; Pick up character
		btfsc		STATUS,Z		; Zero?
		goto		DoAspace
		xorlw		H'08'			; Test for dollar sign
		btfsc		STATUS,Z
		goto		DoAdollar
		movlw		H'06'			; Otherwise it's a 6 ele
GoSpecial
		movwf		BitCount
		movf		LtrToSend,W		; Pick up new index
		call		Morse2			; Get new 6 element code
		movwf		LtrToSend		; Save it off
		goto		EleLoop			; And continue processing
DoAdollar
		movlw		H'07'			; Dollar sign is 7 elements
		goto		GoSpecial
DoAspace
		call		DahTime			; We already have 3 dit times
		goto		DitTime			; from prev char so need only 4

;	Delay a dit time
DitTime
		movlw		SPEED
		movwf		L1
DitTime1
		movlw		H'00'
		movwf		L2
DitTime2
		decfsz		L2,F
		goto		DitTime2
		decfsz		L1,F
		goto		DitTime1
		return
;	Delay a dah time
DahTime
		call		DitTime
		call		DitTime
		call		DitTime
		return
;	Delay a letter space
LetSpc
		call		DitTime		; Already have a dit for
		call		DitTime		; the element space so only
		return					; need 2, not 3.
;	Delay a word space
WordSpace
		call		DahTime
		call		DahTime
		return
;	Turn on the transmitter
XmitOn
		bcf			PORTB,XMTR
		bsf			PORTB,KEY
		return
;	Turn off the transmitter
XmitOff
		bsf			PORTB,XMTR
		bcf			PORTB,KEY
		return
;	Send a Dah
Dah
		call		XmitOn
		call		DahTime
		call		XmitOff
		call		DitTime
		return
;	Send a Dit
Dit
		call		XmitOn
		call		DitTime
		call		XmitOff
		call		DitTime
		return

;	Main program starts here
;
;	Initialization
Start
		
		movlw		B'00001110'	; Turn off all LEDs initially
		movwf		PORTB
		errorlevel	-302
		banksel		TRISB
		movlw		B'01110001'	; Set LEDs and Xmtr transistor
		movwf		TRISB		; as outputs
		banksel		PORTB
		errorlevel	+302

;	Main loop here
Loop
		clrf		LetterNum	; Assume msg starts at 0 in EEPROM
LLoop
		movf		LetterNum,W	; Pick up EEPROM address to read
		movwf		EEADR		; and put it in EEPROM addr register
		errorlevel	-302
		banksel		EECON1
		bsf			EECON1,RD	; Set the EEPROM read bit
		banksel		EEDATA
		errorlevel	+302
		movf		EEDATA,W	; and pick up the character
		call		SendLtr		; Send the character
		incf		LetterNum,F	; Point to the next letter in message
		movlw		EndMsg		; Subtract the end address of the 
		subwf		LetterNum,W	; message.  If the result is zero
		btfss		STATUS,Z	; We are done
		goto		LLoop		; Not zero, go do next letter
		clrf		LetterNum	; Point to first letter
		goto		Loop		; and continue

;	Message Text here
		org			h'2100'
		de			"THE RAIN, IN SPAIN, STAYS MAINLY IN THE PLAIN.  "
EndMsg	equ			$&h'ff'
		end

