;	Emler 160 Lesson 6b - 31 Dec 2003
;	Send TEST in Morse (at very high speed)

		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

XMTR	equ			H'07'
		cblock		H'20'
			Output
		endc

		goto		Start	; Skip to mainline

;	Delay a dit time
DitTime
		nop
		return
;	Delay a dah time
DahTime
		call		DitTime
		call		DitTime
		call		DitTime
		return
;	Delay a letter space
LetSpc
		call		DahTime		; OK, this is a tiny bit long
		return
;	Delay a word space
WordSpace
		call		DahTime
		call		DahTime
		return
;	Turn on the transmitter
XmitOn
		bsf			Output,XMTR
		return
;	Turn off the transmitter
XmitOff
		bcf			Output,XMTR
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
;	Send the letter T
SendT
		call		Dah
		call		LetSpc
		return
;	Send the letter E
SendE
		call		Dit
		call		LetSpc
		return
;	Send the letter S
SendS
		call		Dit
		call		Dit
		call		Dit
		call		LetSpc
		return

;	Main program starts here
;
;	Initialization
Start
		clrf		Output		; Initialize output off
;	Main loop here
Loop
		call		SendT
		call		SendE
		call		SendS
		call		SendT
		call		WordSpace
		goto		Loop

		end
