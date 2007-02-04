;	LCDlib Regression Test
;
;	Exercise the routines in the LCD library
;
;	JJMcD - 17-Mar-05
;	$Revision: 1.40 $ $Date: 2007-02-04 17:46:42-05 $

			include		Processor.inc
			IF			PROC == 627	; For 16F627/628/648A
			__config	_WDT_OFF & _XT_OSC & _PWRTE_ON & _BODEN_OFF & _LVP_OFF
            ENDIF
            IF          PROC == 84
			__config	_WDT_OFF & _XT_OSC & _PWRTE_ON
			ENDIF
            IF          PROC == 54
;			__config	_WDT_OFF & _XT_OSC
			ENDIF
            IF          PROC == 819
			__config	_WDT_OFF & _XT_OSC & _PWRTE_ON & _BODEN_OFF & _LVP_OFF
            ENDIF
            IF          PROC == 716
			__config	_WDT_OFF & _XT_OSC & _PWRTE_ON & _BODEN_OFF & _BOREN_OFF
            ENDIF
            IF          PROC == 88
			__config	_CONFIG1, _XT_OSC & _LVP_OFF & _WDT_OFF & _DEBUG_OFF
            ENDIF

			IF			PROC == 84 || PROC == 819 || PROC == 716 || PROC == 54
			errorlevel	-312
			ENDIF

			extern		LCDinit,LCDdig,LCDclear,LCDaddr,LCDletr
			extern		LCDshift,LCDunshf,LCD8,LCDzero;,LCDmsg
			extern		LCDinsc,LCDsc16
			extern		Del1s,Del128ms,Del256ms

			udata
Index		res			1		; Index into message
IndInd		res			1		; Index into Index
SaveChr		res			1		; Storage for character
;Buffer		res			17		; Buffer to test LCDmsg
;TABSTOR		udata
;SavIdx		res			1			; Temporary storage for index
#define SavIdx SaveChr

    IF PROC == 54
STARTUP     code        H'1ff'
    ELSE
STARTUP		code
    ENDIF
			goto		Start
			code
;	Test scrolling - 16 character display
TstSc6
			lcall		LCDclear	; Clear it out
			lcall		LCDinsc		; Initialize scrolling
			clrf		Index		; Start with zeroth character
TstSc61		movf		Index,W		; Pick up the index
			lcall		TabSc6		; Look up the desired character
			lcall		LCDsc16		; Display it
			lcall		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.31			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstSc61		; No, do it again
			return					;

;	Test the message function - 16-character (2x8) display
;TstMs6
;			lcall		LCDclear	; Clear out the display
;			pagesel		TstMs6
;			clrf		Index		; Start with zeroth character
;			movlw		Buffer		; Pick up address of buffer
;			movwf		IndInd		; And save it
;TstMs61		movf		Index,W		; Pick up the index
;			call		TabM6g		; Look up the desired character
;			movwf		SaveChr		; Save off the character
;			incf		IndInd,F	; Need to add one to index
;			movf		IndInd,W	; Pick up storage location
;			movwf		FSR			; Place it in FSR
;			movf		SaveChr,W	; Get letter back
;			movwf		INDF		; And store it in the buffer
;			incf		Index,1		; Next character
;			movlw		.16			; Message length
;			subwf		Index,W		; WIll be zero when done
;			btfss		STATUS,Z	; Zero?
;			goto		TstMs61		; No, do it again
;			movlw		.16			; Message length
;			movwf		Buffer		; Stuff it in buffer
;			movlw		Buffer		; Message in buffer, can
;			lcall		LCDmsg		; display it with LCDmsg
;			return					; All done
;
;;	Test the message function
;TstMsg
;			lcall		LCDclear	; Clear out the display
;			pagesel		TstMsg
;			clrf		Index		; Start with zeroth character
;			movlw		Buffer		; Pick up address of buffer
;			movwf		IndInd		; And save it
;TstMsg1		movf		Index,W		; Pick up the index
;			call		TabMsg		; Look up the desired character
;			movwf		SaveChr		; Save off the character
;			incf		IndInd,F	; Need to add one to index
;			movf		IndInd,W	; Pick up storage location
;			movwf		FSR			; Place it in FSR
;			movf		SaveChr,W	; Get letter back
;			movwf		INDF		; And store it in the buffer
;			incf		Index,1		; Next character
;			movlw		.8			; Message length
;			subwf		Index,W		; WIll be zero when done
;			btfss		STATUS,Z	; Zero?
;			goto		TstMsg1		; No, do it again
;			movlw		.8			; Message length
;			movwf		Buffer		; Stuff it in buffer
;			movlw		Buffer		; Message in buffer, can
;			lcall		LCDmsg		; display it with LCDmsg
;			return					; All done
;
;	Test scrolling - 8 character only
TstScr
			lcall		LCDclear	; First clear memory
			lcall		LCDshift	; Set to shift mode
			lcall		LCD8		; First char on right
			clrf		Index		; Start with zeroth character
TstScr1		movf		Index,W		; Pick up the index
			lcall		TabScr		; Look up the desired character
			lcall		LCDletr		; Display it
			lcall		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.31			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstScr1		; No, do it again
			lcall		LCDunshf	; Get out of shift mode
			return					;

;	Test digit ... send 1..8 to LCD
TstDig
			lcall		LCDclear	; Clear out old stuff
			clrf		Index		; Start with zeroth character
TstDig1		movf		Index,W		; Pick up the index
			lcall		TabDig		; Look up the desired character
			lcall		LCDdig		; Display it
			incf		Index,F		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstDig1		; No, do it again
			return					; Yes, all done
;	Test address ... will send "Elecraft" slowly, from the ends in
TstAdr
			clrf		Index		; Start with zeroth
TstAd1		movf		Index,W		; Pick up the index
			lcall		TabAd1		; And get the char position
			movwf		IndInd		; Save it
			lcall		LCDaddr		; and position cursor
			movf		IndInd,W	; Get the position again
			lcall		TabAdr		; and get the character
			lcall		LCDletr		; Display it
			movlw		H'11'		; Move cursor out of the way
			lcall		LCDaddr		; for a nicer display
			lcall		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstAd1		; No, do it again
			return					; Yes, all done

;	Test address - 16 char display ... will send "Wilderness Radio" slowly, from the ends in
TstA6r
			lcall		LCDclear	; Clear out prev message
			pagesel		TstA6r
			clrf		Index		; Start with zeroth
TstA61		movf		Index,W		; Pick up the index
			lcall		TabA61		; And get the char position
			movwf		IndInd		; Save it
    IF PROC ==54
            movlw       -.7
            addwf       IndInd,W
    ELSE
			sublw		.7			; Check if second part of LCD
    ENDIF
			btfss		STATUS,C	; Borrow?
			goto		TstA62		; No
			movf		IndInd,W	; Yes
			lcall		LCDaddr		; and position cursor
			pagesel		TstA6r
			goto		TstA63		; Skip over right half
TstA62
    IF PROC==54
            movlw       H'38'
            addwf       IndInd,W
    ELSE
    		movf		IndInd,W	; Pick up position
			addlw		H'38'		; Move to right half
    ENDIF
			lcall		LCDaddr		; of LCD (add 64-8)
			pagesel		TstA6r
TstA63		movf		IndInd,W	; Get the position again
			call		TabAd6		; and get the character
			lcall		LCDletr		; Display it
			movlw		H'11'		; Move cursor out of the way
			lcall		LCDaddr		; for a nicer display
			lcall		Del256ms	; Slow it down
			pagesel		TstA6r
			incf		Index,1		; Next character
			movlw		.16			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstA61		; No, do it again
			return					; Yes, all done

Start
			lcall		Del128ms
	;	Initialize
			lcall		LCDinit
            lcall       Del1s
Loop
	;	Test LCDdig, also uses LCDletr
			lcall		TstDig
	;	Test 1 sec delay
			lcall		Del1s
	;	Test LCDclear
			lcall		LCDclear
			lcall		Del1s
	;	Test LCDaddr
			lcall		TstAdr
			lcall		Del1s
	;	Test scrolling
			lcall		TstScr
			lcall		Del1s
	;	Test LCDmsg
;			lcall		TstMsg
;			lcall		Del1s
	;	Test LCDmsg - 16 char
;			lcall		TstMs6
;			lcall		Del1s
	;	Test scrolling - 16 char
			lcall		TstSc6
			lcall		Del1s
	;	Test LCDaddr - 16 char
			lcall		TstA6r
			lcall		Del1s

	; Get ready to start over
			lcall		LCDclear	; Move cursor to the start
			lcall		LCDzero		; for the next guy
			lgoto		Loop


;	Lookup tables - moved up here to avoid page crossings

    IF PROC != 54
TABLES		code		H'300'		; Start on a page boundary
    ELSE
TABLES      code        H'5'
    ENDIF
;	Table of digits to display
TabDig
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabDig); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			.1,.2,.3,.4,.5,.6,.7,.8
;	Table with message for TstAdr
TabAdr
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAdr); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			"Elecraft"
;	Table with char numbers for TstAdr
TabAd1
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAd1); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			.7,.0,.6,.1,.5,.2,.4,.3
;	Table with message for TstAdr 16-character
TabAd6
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAd6); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			"Wilderness Radio"
;	Table with char numbers for TstAdr 16-char
TabA61
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabA61); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			.15,.0,.14,.1,.13,.2,.12,.3,.11,.4,.10,.5,.9,.6,.8,.7
;	Table with message for TstScr
TabScr
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabScr); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			"Oak Hills Research ...         "
;	Table with message for TstScr - 16 char
TabSc6
    IF PROC != 54
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabSc6); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
    ENDIF
			addwf		PCL,F		; And look it up
			dt			"Small Wonder Labs ...          "
;	Table with message for TstMsg
;TabMsg
;    IF PROC != 54
;    		movwf		SavIdx		; Save off the index
;			movlw		HIGH(TabMsg); Get this page's high byte
;			movwf		PCLATH		; and store it into PCLATH
;			movf		SavIdx,W	; Pick up index
;    ENDIF
;			addwf		PCL,F		; And look it up
;			dt			"QRP Labs"
;;	Table with message for TstMsg (16 character message)
;TabM6g
;    IF PROC != 54
;    		movwf		SavIdx		; Save off the index
;			movlw		HIGH(TabM6g); Get this page's high byte
;			movwf		PCLATH		; and store it into PCLATH
;			movf		SavIdx,W	; Pick up index
;    ENDIF
;			addwf		PCL,F		; And look it up
;			dt			"*Morse Express* "
;
			end
