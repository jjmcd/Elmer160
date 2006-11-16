			title		'InitTMR0 - Initialize timer 0'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		Processor.inc

;------------------------------------------------------------------------
;**
;	InitTmr0
;
;	This function initializes the timer for use by the Lesson 20
;	exercises.
;
;**
;	WB8RCR - 19-May-06
;	$Revision: 1.10 $ $State: Stab $ $Date: 2006-11-16 13:51:28-05 $

			global		InitTMR0

MYLIB		code
InitTMR0:
			errorlevel	-302
		IF (PROC == 819) || (PROC == 88)
			bcf			INTCON,TMR0IE
		ELSE
			bcf			INTCON,T0IE		; Mask timer interrupt
		ENDIF

	; IRL, we would have simply loaded a constant, but the
	; code below makes it explicit what we are doing
			banksel		OPTION_REG
			bcf			OPTION_REG,T0CS	; Enable timer
			bcf			OPTION_REG,T0SE	; Use rising edge
			bcf			OPTION_REG,PSA	; Prescaler to timer
			bsf			OPTION_REG,PS2	; \
			bsf			OPTION_REG,PS1	;  >- 1:256 prescale
			bsf			OPTION_REG,PS0	; /
			banksel		PORTA
			return
			end
