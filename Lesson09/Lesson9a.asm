		processor	pic16f84a
		include		"p16f84a.inc"
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

a		equ			0172o
aa		equ			B'01111010'
abc		equ			0172O
c		equ			172o
e		equ			07a
f		equ			A'z'
g		equ			'z'
h		equ			.122
i		equ			7ah
j		equ			0x7a
		radix		oct
l		equ			172
#define debug
		ifdef debug
		messg		"**Watch out, debug code**"
count	equ			H'03'
		else
count	equ			H'7a'
		endif
		errorlevel	2
		movwf		TRISA
		z
		end
