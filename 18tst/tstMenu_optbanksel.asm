;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Jul 28 2006)
; This file generated Sun Feb 18 13:43:15 2007
;--------------------------------------------------------
; PIC16 port for the Microchip 16-bit core micros
;--------------------------------------------------------
	list	p=18f1320

	radix dec

;--------------------------------------------------------
; public variables in this module
;--------------------------------------------------------
	global _stack
	global _stack_end
	global _ShowFreq
	global _FreqUp
	global _FreqDn
	global _ReadEncoder
	global _ShowWeight
	global _WeightUp
	global _WeightDown
	global _ShowSpeed
	global _SpeedUp
	global _SpeedDown
	global _ShowPower
	global _PowerUp
	global _PowerDown
	global _ButtonActive
	global _Message
	global _main
	global _menuText
	global _stateMsg
	global _nextPB1
	global _nextPB2
	global _nextPB3
	global _nextTimer

;--------------------------------------------------------
; extern variables in this module
;--------------------------------------------------------
	extern __divuchar
	extern __moduchar
	extern __gptrget1
	extern _PORTAbits
	extern _PORTBbits
	extern _LATAbits
	extern _LATBbits
	extern _TRISAbits
	extern _TRISBbits
	extern _PIE1bits
	extern _PIR1bits
	extern _IPR1bits
	extern _PIE2bits
	extern _PIR2bits
	extern _IPR2bits
	extern _EECON1bits
	extern _RCSTAbits
	extern _TXSTAbits
	extern _T3CONbits
	extern _ECCPASbits
	extern _CCP1CONbits
	extern _ADCON2bits
	extern _ADCON1bits
	extern _ADCON0bits
	extern _T2CONbits
	extern _T1CONbits
	extern _RCONbits
	extern _WDTCONbits
	extern _LVDCONbits
	extern _OSCCONbits
	extern _STATUSbits
	extern _INTCON3bits
	extern _INTCON2bits
	extern _INTCONbits
	extern _STKPTRbits
	extern _PORTA
	extern _PORTB
	extern _LATA
	extern _LATB
	extern _TRISA
	extern _TRISB
	extern _PIE1
	extern _PIR1
	extern _IPR1
	extern _PIE2
	extern _PIR2
	extern _IPR2
	extern _EECON1
	extern _EECON2
	extern _EEDATA
	extern _EEADR
	extern _BAUDCTL
	extern _RCSTA
	extern _TXSTA
	extern _TXREG
	extern _RCREG
	extern _SPBRG
	extern _SPBRGH
	extern _T3CON
	extern _TMR3L
	extern _TMR3H
	extern _ECCPAS
	extern _CCP1CON
	extern _CCPR1L
	extern _CCPR1H
	extern _ADCON2
	extern _ADCON1
	extern _ADCON0
	extern _ADRESL
	extern _ADRESH
	extern _T2CON
	extern _PR2
	extern _TMR2
	extern _T1CON
	extern _TMR1L
	extern _TMR1H
	extern _RCON
	extern _WDTCON
	extern _LVDCON
	extern _OSCCON
	extern _T0CON
	extern _TMR0L
	extern _TMR0H
	extern _STATUS
	extern _FSR2L
	extern _FSR2H
	extern _PLUSW2
	extern _PREINC2
	extern _POSTDEC2
	extern _POSTINC2
	extern _INDF2
	extern _BSR
	extern _FSR1L
	extern _FSR1H
	extern _PLUSW1
	extern _PREINC1
	extern _POSTDEC1
	extern _POSTINC1
	extern _INDF1
	extern _WREG
	extern _FSR0L
	extern _FSR0H
	extern _PLUSW0
	extern _PREINC0
	extern _POSTDEC0
	extern _POSTINC0
	extern _INDF0
	extern _INTCON3
	extern _INTCON2
	extern _INTCON
	extern _PRODL
	extern _PRODH
	extern _TABLAT
	extern _TBLPTRL
	extern _TBLPTRH
	extern _TBLPTRU
	extern _PCL
	extern _PCLATH
	extern _PCLATU
	extern _STKPTR
	extern _TOSL
	extern _TOSH
	extern _TOSU
	extern _strcat
	extern _strcpy
	extern _itoa
	extern _ltoa
	extern _LCDinit
	extern _LCDletr
	extern _LCDclear
	extern _LCDaddr
	extern _LCDzero
	extern _Del2ms
	extern _Delay
	extern _Delay4
;--------------------------------------------------------
;	Equates to used internal registers
;--------------------------------------------------------
STATUS	equ	0xfd8
PCL	equ	0xff9
PCLATH	equ	0xffa
PCLATU	equ	0xffb
WREG	equ	0xfe8
TBLPTRL	equ	0xff6
TBLPTRH	equ	0xff7
TBLPTRU	equ	0xff8
TABLAT	equ	0xff5
FSR0L	equ	0xfe9
FSR1L	equ	0xfe1
FSR2L	equ	0xfd9
INDF0	equ	0xfef
POSTDEC1	equ	0xfe5
PREINC1	equ	0xfe4
PLUSW2	equ	0xfdb
PRODL	equ	0xff3


; Internal registers
.registers	udata_ovr	0x0000
r0x00	res	1
r0x01	res	1
r0x02	res	1
r0x03	res	1
r0x04	res	1
r0x05	res	1
r0x06	res	1


tm_udata	udata
_nPower	res	1
_nSpeed	res	1
_nKeyWeight	res	1
_nStep	res	1
_nFreq	res	4
_nButtonLast	res	4
_szMsg	res	16
_nEncDirty	res	1
_nEnc	res	2


ustat_tstMenu_00	udata	0X00E0
_stack	res	31
_stack_end	res	1

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
; I code from now on!
; ; Starting pCode block
S_tstMenu__main	code
_main:
;	.line	220; tstMenu.c	nButtonLast[1] = nButtonLast[2] = nButtonLast[3] = 1;
	MOVLW	0x01
	BANKSEL	(_nButtonLast + 3)
	MOVWF	(_nButtonLast + 3), B
; removed redundant BANKSEL
	MOVWF	(_nButtonLast + 2), B
; removed redundant BANKSEL
	MOVWF	(_nButtonLast + 1), B
;	.line	221; tstMenu.c	nPower = 25;                 // Start power at 2.5 watts
	MOVLW	0x19
	BANKSEL	_nPower
	MOVWF	_nPower, B
;	.line	222; tstMenu.c	nSpeed = 30;                 // Start speed at 30 WPM
	MOVLW	0x1e
	BANKSEL	_nSpeed
	MOVWF	_nSpeed, B
;	.line	223; tstMenu.c	nKeyWeight = 33;             // Start weight at 3.3
	MOVLW	0x21
	BANKSEL	_nKeyWeight
	MOVWF	_nKeyWeight, B
;	.line	224; tstMenu.c	nStep = 10;                  // Start step at 10
	MOVLW	0x0a
	BANKSEL	_nStep
	MOVWF	_nStep, B
;	.line	225; tstMenu.c	nFreq = 14060000;            // Start freq @ QRP calling freq
	MOVLW	0xe0
	BANKSEL	_nFreq
	MOVWF	_nFreq, B
	MOVLW	0x89
; removed redundant BANKSEL
	MOVWF	(_nFreq + 1), B
	MOVLW	0xd6
; removed redundant BANKSEL
	MOVWF	(_nFreq + 2), B
; removed redundant BANKSEL
	CLRF	(_nFreq + 3), B
;	.line	228; tstMenu.c	ADCON1 = 0x3b;
	MOVLW	0x3b
	MOVWF	_ADCON1
;	.line	230; tstMenu.c	TRISA = 0x13;
	MOVLW	0x13
	MOVWF	_TRISA
;	.line	231; tstMenu.c	TRISB = 0x0c;
	MOVLW	0x0c
	MOVWF	_TRISB
;	.line	234; tstMenu.c	LCDinit();
	CALL	_LCDinit
;	.line	236; tstMenu.c	nState = 0;
	CLRF	r0x00
;	.line	237; tstMenu.c	nDirty = 1;                  // Show frequency first pass
	MOVLW	0x01
	MOVWF	r0x01
_00133_DS_:
;	.line	242; tstMenu.c	switch ( ButtonActive() )
	CALL	_ButtonActive
	MOVWF	r0x02
	MOVLW	0x01
	SUBWF	r0x02, W
	BTFSS	STATUS, 0
	BRA	_00109_DS_
	MOVLW	0x04
	SUBWF	r0x02, W
	BTFSC	STATUS, 0
	BRA	_00109_DS_
	DECF	r0x02, F
	MOVFF	r0x03, POSTDEC1
	MOVFF	r0x04, POSTDEC1
	CLRF	r0x04
	RLCF	r0x02, W
	RLCF	r0x04, F
	RLCF	WREG, W
	RLCF	r0x04, F
	ANDLW	0xfc
	MOVWF	r0x03
	MOVLW	UPPER(_00149_DS_)
	MOVWF	PCLATU
	MOVLW	HIGH(_00149_DS_)
	MOVWF	PCLATH
	MOVLW	LOW(_00149_DS_)
	ADDWF	r0x03, F
	MOVF	r0x04, W
	ADDWFC	PCLATH, F
	BTFSC	STATUS, 0
	INCF	PCLATU, F
	MOVF	r0x03, W
	MOVFF	PREINC1, r0x04
	MOVFF	PREINC1, r0x03
	MOVWF	PCL
_00149_DS_:
	GOTO	_00105_DS_
	GOTO	_00106_DS_
	GOTO	_00107_DS_
_00105_DS_:
;	.line	245; tstMenu.c	nState = nextPB1[nState];
	MOVLW	LOW(_nextPB1)
	ADDWF	r0x00, W
	MOVWF	r0x02
	CLRF	r0x03
	MOVLW	HIGH(_nextPB1)
	ADDWFC	r0x03, F
	CLRF	r0x04
	MOVLW	UPPER(_nextPB1)
	ADDWFC	r0x04, F
	MOVFF	r0x02, TBLPTRL
	MOVFF	r0x03, TBLPTRH
	MOVFF	r0x04, TBLPTRU
	TBLRD*+	
	MOVFF	TABLAT, r0x00
;	.line	246; tstMenu.c	nDirty = 1;
	MOVLW	0x01
	MOVWF	r0x01
;	.line	247; tstMenu.c	break;
	BRA	_00109_DS_
_00106_DS_:
;	.line	249; tstMenu.c	nState = nextPB2[nState];
	MOVLW	LOW(_nextPB2)
	ADDWF	r0x00, W
	MOVWF	r0x02
	CLRF	r0x03
	MOVLW	HIGH(_nextPB2)
	ADDWFC	r0x03, F
	CLRF	r0x04
	MOVLW	UPPER(_nextPB2)
	ADDWFC	r0x04, F
	MOVFF	r0x02, TBLPTRL
	MOVFF	r0x03, TBLPTRH
	MOVFF	r0x04, TBLPTRU
	TBLRD*+	
	MOVFF	TABLAT, r0x00
;	.line	250; tstMenu.c	nDirty = 1;
	MOVLW	0x01
	MOVWF	r0x01
;	.line	251; tstMenu.c	break;
	BRA	_00109_DS_
_00107_DS_:
;	.line	253; tstMenu.c	nState = nextPB3[nState];
	MOVLW	LOW(_nextPB3)
	ADDWF	r0x00, W
	MOVWF	r0x02
	CLRF	r0x03
	MOVLW	HIGH(_nextPB3)
	ADDWFC	r0x03, F
	CLRF	r0x04
	MOVLW	UPPER(_nextPB3)
	ADDWFC	r0x04, F
	MOVFF	r0x02, TBLPTRL
	MOVFF	r0x03, TBLPTRH
	MOVFF	r0x04, TBLPTRU
	TBLRD*+	
	MOVFF	TABLAT, r0x00
;	.line	254; tstMenu.c	nDirty = 1;
	MOVLW	0x01
	MOVWF	r0x01
_00109_DS_:
;	.line	260; tstMenu.c	if ( !nDirty )
	MOVF	r0x01, W
	BNZ	_00113_DS_
;	.line	261; tstMenu.c	if ( !nState )
	MOVF	r0x00, W
	BNZ	_00113_DS_
;	.line	262; tstMenu.c	nDirty = ReadEncoder();
	CALL	_ReadEncoder
	MOVWF	r0x01
_00113_DS_:
;	.line	263; tstMenu.c	if ( nDirty )
	MOVF	r0x01, W
	BTFSC	STATUS, 2
	BRA	_00133_DS_
;	.line	265; tstMenu.c	LCDclear();
	CALL	_LCDclear
;	.line	266; tstMenu.c	if ( nState )
	MOVF	r0x00, W
	BZ	_00115_DS_
;	.line	267; tstMenu.c	Message( menuText[stateMsg[nState]] );
	MOVLW	LOW(_stateMsg)
	ADDWF	r0x00, W
	MOVWF	r0x02
	CLRF	r0x03
	MOVLW	HIGH(_stateMsg)
	ADDWFC	r0x03, F
	CLRF	r0x04
	MOVLW	UPPER(_stateMsg)
	ADDWFC	r0x04, F
	MOVFF	r0x02, TBLPTRL
	MOVFF	r0x03, TBLPTRH
	MOVFF	r0x04, TBLPTRU
	TBLRD*+	
	MOVFF	TABLAT, r0x02
; ;multiply lit val:0x09 by variable r0x02 and store in r0x02
; ;Unrolled 8 X 8 multiplication
; ;FIXME: the function does not support result==WREG
	MOVF	r0x02, W
	MULLW	0x09
	MOVFF	PRODL, r0x02
	MOVLW	LOW(_menuText)
	ADDWF	r0x02, F
	MOVLW	HIGH(_menuText)
	CLRF	r0x03
	ADDWFC	r0x03, F
	MOVLW	UPPER(_menuText)
	CLRF	r0x04
	ADDWFC	r0x04, F
	MOVF	r0x04, W
	MOVWF	POSTDEC1
	MOVF	r0x03, W
	MOVWF	POSTDEC1
	MOVF	r0x02, W
	MOVWF	POSTDEC1
	CALL	_Message
	MOVLW	0x03
	ADDWF	FSR1L, F
	BRA	_00116_DS_
_00115_DS_:
;	.line	269; tstMenu.c	ShowFreq();
	CALL	_ShowFreq
_00116_DS_:
;	.line	270; tstMenu.c	nDirty = 0;
	CLRF	r0x01
;	.line	273; tstMenu.c	if ( nState > 20 )
	MOVLW	0x15
	SUBWF	r0x00, W
	BTFSS	STATUS, 0
	BRA	_00133_DS_
;	.line	275; tstMenu.c	switch ( nState )
	MOVLW	0x15
	SUBWF	r0x00, W
	BTFSS	STATUS, 0
	BRA	_00126_DS_
	MOVLW	0x1e
	SUBWF	r0x00, W
	BTFSC	STATUS, 0
	BRA	_00126_DS_
	MOVLW	0xeb
	ADDWF	r0x00, W
	MOVWF	r0x02
	MOVFF	r0x05, POSTDEC1
	MOVFF	r0x06, POSTDEC1
	CLRF	r0x06
	RLCF	r0x02, W
	RLCF	r0x06, F
	RLCF	WREG, W
	RLCF	r0x06, F
	ANDLW	0xfc
	MOVWF	r0x05
	MOVLW	UPPER(_00153_DS_)
	MOVWF	PCLATU
	MOVLW	HIGH(_00153_DS_)
	MOVWF	PCLATH
	MOVLW	LOW(_00153_DS_)
	ADDWF	r0x05, F
	MOVF	r0x06, W
	ADDWFC	PCLATH, F
	BTFSC	STATUS, 0
	INCF	PCLATU, F
	MOVF	r0x05, W
	MOVFF	PREINC1, r0x06
	MOVFF	PREINC1, r0x05
	MOVWF	PCL
_00153_DS_:
	GOTO	_00117_DS_
	GOTO	_00118_DS_
	GOTO	_00119_DS_
	GOTO	_00120_DS_
	GOTO	_00121_DS_
	GOTO	_00122_DS_
	GOTO	_00123_DS_
	GOTO	_00124_DS_
	GOTO	_00125_DS_
_00117_DS_:
;	.line	278; tstMenu.c	nStep = 1;
	MOVLW	0x01
	BANKSEL	_nStep
	MOVWF	_nStep, B
;	.line	279; tstMenu.c	break;
	BRA	_00127_DS_
_00118_DS_:
;	.line	281; tstMenu.c	nStep = 10;
	MOVLW	0x0a
	BANKSEL	_nStep
	MOVWF	_nStep, B
;	.line	282; tstMenu.c	break;
	BRA	_00127_DS_
_00119_DS_:
;	.line	284; tstMenu.c	nStep = 100;
	MOVLW	0x64
	BANKSEL	_nStep
	MOVWF	_nStep, B
;	.line	285; tstMenu.c	break;
	BRA	_00127_DS_
_00120_DS_:
;	.line	287; tstMenu.c	SpeedUp();
	CALL	_SpeedUp
;	.line	288; tstMenu.c	break;
	BRA	_00127_DS_
_00121_DS_:
;	.line	290; tstMenu.c	SpeedDown();
	CALL	_SpeedDown
;	.line	291; tstMenu.c	break;
	BRA	_00127_DS_
_00122_DS_:
;	.line	293; tstMenu.c	WeightUp();
	CALL	_WeightUp
;	.line	294; tstMenu.c	break;
	BRA	_00127_DS_
_00123_DS_:
;	.line	296; tstMenu.c	WeightDown();
	CALL	_WeightDown
;	.line	297; tstMenu.c	break;
	BRA	_00127_DS_
_00124_DS_:
;	.line	299; tstMenu.c	PowerUp();
	CALL	_PowerUp
;	.line	300; tstMenu.c	break;
	BRA	_00127_DS_
_00125_DS_:
;	.line	302; tstMenu.c	PowerDown();
	CALL	_PowerDown
;	.line	303; tstMenu.c	break;
	BRA	_00127_DS_
_00126_DS_:
;	.line	305; tstMenu.c	Delay4();
	CALL	_Delay4
_00127_DS_:
;	.line	307; tstMenu.c	LCDclear();
	CALL	_LCDclear
;	.line	308; tstMenu.c	nState = nextTimer[nState];
	MOVLW	LOW(_nextTimer)
	ADDWF	r0x00, W
	MOVWF	r0x02
	CLRF	r0x03
	MOVLW	HIGH(_nextTimer)
	ADDWFC	r0x03, F
	CLRF	r0x04
	MOVLW	UPPER(_nextTimer)
	ADDWFC	r0x04, F
	MOVFF	r0x02, TBLPTRL
	MOVFF	r0x03, TBLPTRH
	MOVFF	r0x04, TBLPTRU
	TBLRD*+	
	MOVFF	TABLAT, r0x00
;	.line	309; tstMenu.c	Message( menuText[stateMsg[nState]] );
	MOVLW	LOW(_stateMsg)
	ADDWF	r0x00, W
	MOVWF	r0x02
	CLRF	r0x03
	MOVLW	HIGH(_stateMsg)
	ADDWFC	r0x03, F
	CLRF	r0x04
	MOVLW	UPPER(_stateMsg)
	ADDWFC	r0x04, F
	MOVFF	r0x02, TBLPTRL
	MOVFF	r0x03, TBLPTRH
	MOVFF	r0x04, TBLPTRU
	TBLRD*+	
	MOVFF	TABLAT, r0x02
; ;multiply lit val:0x09 by variable r0x02 and store in r0x02
; ;Unrolled 8 X 8 multiplication
; ;FIXME: the function does not support result==WREG
	MOVF	r0x02, W
	MULLW	0x09
	MOVFF	PRODL, r0x02
	MOVLW	LOW(_menuText)
	ADDWF	r0x02, F
	MOVLW	HIGH(_menuText)
	CLRF	r0x03
	ADDWFC	r0x03, F
	MOVLW	UPPER(_menuText)
	CLRF	r0x04
	ADDWFC	r0x04, F
	MOVF	r0x04, W
	MOVWF	POSTDEC1
	MOVF	r0x03, W
	MOVWF	POSTDEC1
	MOVF	r0x02, W
	MOVWF	POSTDEC1
	CALL	_Message
	MOVLW	0x03
	ADDWF	FSR1L, F
	BRA	_00133_DS_
	RETURN	

; ; Starting pCode block
S_tstMenu__Message	code
_Message:
;	.line	529; tstMenu.c	void Message( char *p )
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
	MOVFF	r0x03, POSTDEC1
	MOVFF	r0x04, POSTDEC1
	MOVLW	0x02
	MOVFF	PLUSW2, r0x00
	MOVLW	0x03
	MOVFF	PLUSW2, r0x01
	MOVLW	0x04
	MOVFF	PLUSW2, r0x02
;	.line	533; tstMenu.c	LCDzero();                       // Position cursor
	CALL	_LCDzero
;	.line	535; tstMenu.c	while ( *p )                     // Until we reach the end
	CLRF	r0x03
_00266_DS_:
	MOVFF	r0x00, FSR0L
	MOVFF	r0x01, PRODL
	MOVF	r0x02, W
	CALL	__gptrget1
	MOVWF	r0x04
	MOVF	r0x04, W
	BZ	_00269_DS_
;	.line	537; tstMenu.c	LCDletr( *p );               // Display the character
	MOVF	r0x04, W
	CALL	_LCDletr
;	.line	538; tstMenu.c	p++;                         // Point to the next character
	INCF	r0x00, F
	BTFSC	STATUS, 0
	INCF	r0x01, F
	BTFSC	STATUS, 0
	INCF	r0x02, F
;	.line	539; tstMenu.c	nCharCount++;                // Increase the count
	INCF	r0x03, F
;	.line	543; tstMenu.c	if ( nCharCount == 8 )
	MOVF	r0x03, W
	XORLW	0x08
	BNZ	_00266_DS_
;	.line	544; tstMenu.c	LCDaddr(0x40);
	MOVLW	0x40
	CALL	_LCDaddr
	BRA	_00266_DS_
_00269_DS_:
	MOVFF	PREINC1, r0x04
	MOVFF	PREINC1, r0x03
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_tstMenu__ButtonActive	code
_ButtonActive:
;	.line	497; tstMenu.c	byte ButtonActive( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
;	.line	501; tstMenu.c	nCurrentButton = 0;                // Set nothing currently active
	CLRF	r0x00
	BANKSEL	(_nButtonLast + 1)
;	.line	502; tstMenu.c	if (!nButtonLast[1])               // If PB1 was previously pressed
	MOVF	(_nButtonLast + 1), W, B
	BNZ	_00245_DS_
;	.line	503; tstMenu.c	if ( PB1 )                     // And it is no longer pressed
	BTFSS	_PORTAbits, 4
	BRA	_00245_DS_
;	.line	504; tstMenu.c	nCurrentButton = 1;          // Then the active PB is 1
	MOVLW	0x01
	MOVWF	r0x00
_00245_DS_:
	BANKSEL	(_nButtonLast + 3)
;	.line	505; tstMenu.c	if (!nButtonLast[3])               // If PB3 was previously pressed
	MOVF	(_nButtonLast + 3), W, B
	BNZ	_00249_DS_
;	.line	506; tstMenu.c	if ( PB3 )                     // And it is no longer pressed
	BTFSS	_PORTAbits, 0
	BRA	_00249_DS_
;	.line	507; tstMenu.c	nCurrentButton = 3;          // Then the active PB is 3
	MOVLW	0x03
	MOVWF	r0x00
_00249_DS_:
	BANKSEL	(_nButtonLast + 2)
;	.line	509; tstMenu.c	if (!nButtonLast[2])               // If PB2 was previously pressed
	MOVF	(_nButtonLast + 2), W, B
	BNZ	_00253_DS_
;	.line	510; tstMenu.c	if ( PB2 )                     // And it is no longer pressed
	BTFSS	_PORTAbits, 1
	BRA	_00253_DS_
;	.line	511; tstMenu.c	nCurrentButton = 2;          // Then the active PB is 2
	MOVLW	0x02
	MOVWF	r0x00
_00253_DS_:
;	.line	513; tstMenu.c	nButtonLast[1] = (byte) PB1;
	CLRF	r0x01
	BTFSC	_PORTAbits, 4
	INCF	r0x01, F
	LFSR	0x00, (_nButtonLast + 1)
	MOVFF	r0x01, INDF0
;	.line	514; tstMenu.c	nButtonLast[2] = (byte) PB2;
	CLRF	r0x01
	BTFSC	_PORTAbits, 1
	INCF	r0x01, F
	LFSR	0x00, (_nButtonLast + 2)
	MOVFF	r0x01, INDF0
;	.line	515; tstMenu.c	nButtonLast[3] = (byte) PB3;
	CLRF	r0x01
	BTFSC	_PORTAbits, 0
	INCF	r0x01, F
	LFSR	0x00, (_nButtonLast + 3)
	MOVFF	r0x01, INDF0
;	.line	519; tstMenu.c	if ( !PB1 ) Blink( LED1 );         // This will light the LED
	BTFSC	_PORTAbits, 4
	BRA	_00255_DS_
	BCF	_PORTBbits, 1
	CALL	_Del2ms
	BSF	_PORTBbits, 1
	CALL	_Del2ms
_00255_DS_:
;	.line	520; tstMenu.c	if ( !PB2 ) Blink( LED2 );         // as long as the corresponding
	BTFSC	_PORTAbits, 1
	BRA	_00257_DS_
	BCF	_PORTBbits, 0
	CALL	_Del2ms
	BSF	_PORTBbits, 0
	CALL	_Del2ms
_00257_DS_:
;	.line	521; tstMenu.c	if ( !PB3 ) Blink( LED3 );         // PB is pressed.
	BTFSC	_PORTAbits, 0
	BRA	_00259_DS_
	BCF	_PORTAbits, 3
	CALL	_Del2ms
	BSF	_PORTAbits, 3
	CALL	_Del2ms
_00259_DS_:
;	.line	522; tstMenu.c	return nCurrentButton;
	MOVF	r0x00, W
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__PowerDown	code
_PowerDown:
;	.line	487; tstMenu.c	nPower = nPower - 5;               // Decrease the power level
	MOVLW	0xfb
	BANKSEL	_nPower
	ADDWF	_nPower, F, B
;	.line	488; tstMenu.c	if ( nPower < 5 )                  // and limit it to 0.5 watts
	MOVLW	0x05
; removed redundant BANKSEL
	SUBWF	_nPower, W, B
	BC	_00237_DS_
;	.line	489; tstMenu.c	nPower = 5;
	MOVLW	0x05
; removed redundant BANKSEL
	MOVWF	_nPower, B
_00237_DS_:
;	.line	490; tstMenu.c	ShowPower();                       // Show the result
	CALL	_ShowPower
	RETURN	

; ; Starting pCode block
S_tstMenu__PowerUp	code
_PowerUp:
;	.line	475; tstMenu.c	nPower = nPower + 5;             // Increase the power level
	MOVLW	0x05
	BANKSEL	_nPower
	ADDWF	_nPower, F, B
;	.line	476; tstMenu.c	if ( nPower > 50 )               // and limit it to 5 watts
	MOVLW	0x33
; removed redundant BANKSEL
	SUBWF	_nPower, W, B
	BNC	_00231_DS_
;	.line	477; tstMenu.c	nPower = 50;
	MOVLW	0x32
; removed redundant BANKSEL
	MOVWF	_nPower, B
_00231_DS_:
;	.line	478; tstMenu.c	ShowPower();                     // Display it
	CALL	_ShowPower
	RETURN	

; ; Starting pCode block
S_tstMenu__ShowPower	code
_ShowPower:
;	.line	456; tstMenu.c	void ShowPower( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
;	.line	458; tstMenu.c	strcpy(szMsg,"Power=");
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	r0x02
	MOVLW	UPPER(__str_3)
	MOVWF	POSTDEC1
	MOVLW	HIGH(__str_3)
	MOVWF	POSTDEC1
	MOVLW	LOW(__str_3)
	MOVWF	POSTDEC1
	MOVF	r0x02, W
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_strcpy
	MOVLW	0x06
	ADDWF	FSR1L, F
;	.line	459; tstMenu.c	LCDclear();
	CALL	_LCDclear
;	.line	461; tstMenu.c	szMsg[6] = '0'+(byte)(nPower/10);
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVFF	_nPower, POSTDEC1
	CALL	__divuchar
	MOVWF	r0x00
	MOVF	PREINC1, W
	MOVF	PREINC1, W
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	BANKSEL	(_szMsg + 6)
	MOVWF	(_szMsg + 6), B
;	.line	462; tstMenu.c	szMsg[7] = '.';
	MOVLW	0x2e
; removed redundant BANKSEL
	MOVWF	(_szMsg + 7), B
;	.line	463; tstMenu.c	szMsg[8] = '0'+(byte)(nPower%10);
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVFF	_nPower, POSTDEC1
	CALL	__moduchar
	MOVWF	r0x00
	MOVF	PREINC1, W
	MOVF	PREINC1, W
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	BANKSEL	(_szMsg + 8)
	MOVWF	(_szMsg + 8), B
; removed redundant BANKSEL
;	.line	464; tstMenu.c	szMsg[9] = '\0';
	CLRF	(_szMsg + 9), B
;	.line	465; tstMenu.c	Message(szMsg);
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_Message
	MOVLW	0x03
	ADDWF	FSR1L, F
;	.line	466; tstMenu.c	Delay();
	CALL	_Delay
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__SpeedDown	code
_SpeedDown:
	BANKSEL	_nSpeed
;	.line	446; tstMenu.c	nSpeed--;                      // Decrease the speed
	DECF	_nSpeed, F, B
;	.line	447; tstMenu.c	if ( nSpeed < 5 )              // and limit it to 5 WPM
	MOVLW	0x05
; removed redundant BANKSEL
	SUBWF	_nSpeed, W, B
	BC	_00221_DS_
;	.line	448; tstMenu.c	nSpeed = 5;
	MOVLW	0x05
; removed redundant BANKSEL
	MOVWF	_nSpeed, B
_00221_DS_:
;	.line	449; tstMenu.c	ShowSpeed();                   // Show the result
	CALL	_ShowSpeed
	RETURN	

; ; Starting pCode block
S_tstMenu__SpeedUp	code
_SpeedUp:
	BANKSEL	_nSpeed
;	.line	434; tstMenu.c	nSpeed++;                      // Increase the speed
	INCF	_nSpeed, F, B
;	.line	435; tstMenu.c	if ( nSpeed > 50 )             // and limit it to 50 WPM
	MOVLW	0x33
; removed redundant BANKSEL
	SUBWF	_nSpeed, W, B
	BNC	_00215_DS_
;	.line	436; tstMenu.c	nSpeed = 50; 
	MOVLW	0x32
; removed redundant BANKSEL
	MOVWF	_nSpeed, B
_00215_DS_:
;	.line	437; tstMenu.c	ShowSpeed();                   // Show the result
	CALL	_ShowSpeed
	RETURN	

; ; Starting pCode block
S_tstMenu__ShowSpeed	code
_ShowSpeed:
;	.line	418; tstMenu.c	void ShowSpeed( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
;	.line	420; tstMenu.c	strcpy(szMsg,"Keyer Speed=");  // Start string with what we are
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	r0x02
	MOVLW	UPPER(__str_2)
	MOVWF	POSTDEC1
	MOVLW	HIGH(__str_2)
	MOVWF	POSTDEC1
	MOVLW	LOW(__str_2)
	MOVWF	POSTDEC1
	MOVF	r0x02, W
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_strcpy
	MOVLW	0x06
	ADDWF	FSR1L, F
;	.line	421; tstMenu.c	LCDclear();                    // displaying and clear display
	CALL	_LCDclear
;	.line	422; tstMenu.c	itoa(nSpeed,&szMsg[12],10);    // Convert to decimal ASCII
	MOVFF	_nSpeed, r0x00
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVLW	HIGH(_szMsg + 12)
	MOVWF	POSTDEC1
	MOVLW	LOW(_szMsg + 12)
	MOVWF	POSTDEC1
	CLRF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_itoa
	MOVLW	0x05
	ADDWF	FSR1L, F
	BANKSEL	(_szMsg + 14)
;	.line	423; tstMenu.c	szMsg[14] = '\0';              // and be sure of terminating NULL
	CLRF	(_szMsg + 14), B
;	.line	424; tstMenu.c	Message( szMsg );              // Then display it
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_Message
	MOVLW	0x03
	ADDWF	FSR1L, F
;	.line	425; tstMenu.c	Delay();                       // Chance to view display
	CALL	_Delay
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__WeightDown	code
_WeightDown:
	BANKSEL	_nKeyWeight
;	.line	408; tstMenu.c	nKeyWeight--;                  // Decrease the keyer weight
	DECF	_nKeyWeight, F, B
;	.line	409; tstMenu.c	if ( nKeyWeight < 29 )         // and limit it to 2.9
	MOVLW	0x1d
; removed redundant BANKSEL
	SUBWF	_nKeyWeight, W, B
	BC	_00205_DS_
;	.line	410; tstMenu.c	nKeyWeight = 29;
	MOVLW	0x1d
; removed redundant BANKSEL
	MOVWF	_nKeyWeight, B
_00205_DS_:
;	.line	411; tstMenu.c	ShowWeight();
	CALL	_ShowWeight
	RETURN	

; ; Starting pCode block
S_tstMenu__WeightUp	code
_WeightUp:
	BANKSEL	_nKeyWeight
;	.line	397; tstMenu.c	nKeyWeight++;                  // Increase the keyer weight
	INCF	_nKeyWeight, F, B
;	.line	398; tstMenu.c	if ( nKeyWeight > 37 )         // and limit it to 3.7
	MOVLW	0x26
; removed redundant BANKSEL
	SUBWF	_nKeyWeight, W, B
	BNC	_00199_DS_
;	.line	399; tstMenu.c	nKeyWeight = 37;
	MOVLW	0x25
; removed redundant BANKSEL
	MOVWF	_nKeyWeight, B
_00199_DS_:
;	.line	400; tstMenu.c	ShowWeight();
	CALL	_ShowWeight
	RETURN	

; ; Starting pCode block
S_tstMenu__ShowWeight	code
_ShowWeight:
;	.line	377; tstMenu.c	void ShowWeight( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
;	.line	379; tstMenu.c	strcpy(szMsg,"Key Weight=");
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	r0x02
	MOVLW	UPPER(__str_1)
	MOVWF	POSTDEC1
	MOVLW	HIGH(__str_1)
	MOVWF	POSTDEC1
	MOVLW	LOW(__str_1)
	MOVWF	POSTDEC1
	MOVF	r0x02, W
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_strcpy
	MOVLW	0x06
	ADDWF	FSR1L, F
;	.line	380; tstMenu.c	LCDclear();
	CALL	_LCDclear
;	.line	384; tstMenu.c	szMsg[11] = '0'+(byte)(nKeyWeight/10);
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVFF	_nKeyWeight, POSTDEC1
	CALL	__divuchar
	MOVWF	r0x00
	MOVF	PREINC1, W
	MOVF	PREINC1, W
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	BANKSEL	(_szMsg + 11)
	MOVWF	(_szMsg + 11), B
;	.line	385; tstMenu.c	szMsg[12] = '.';
	MOVLW	0x2e
; removed redundant BANKSEL
	MOVWF	(_szMsg + 12), B
;	.line	386; tstMenu.c	szMsg[13] = '0'+(byte)(nKeyWeight%10);
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVFF	_nKeyWeight, POSTDEC1
	CALL	__moduchar
	MOVWF	r0x00
	MOVF	PREINC1, W
	MOVF	PREINC1, W
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	BANKSEL	(_szMsg + 13)
	MOVWF	(_szMsg + 13), B
; removed redundant BANKSEL
;	.line	387; tstMenu.c	szMsg[14] = '\0';
	CLRF	(_szMsg + 14), B
;	.line	388; tstMenu.c	Message(szMsg);
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_Message
	MOVLW	0x03
	ADDWF	FSR1L, F
;	.line	389; tstMenu.c	Delay();
	CALL	_Delay
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__ReadEncoder	code
_ReadEncoder:
;	.line	353; tstMenu.c	byte ReadEncoder( void )
	MOVFF	r0x00, POSTDEC1
	BANKSEL	_nEncDirty
;	.line	355; tstMenu.c	nEncDirty = 0;               // Assume no change
	CLRF	_nEncDirty, B
	BANKSEL	_nEnc
;	.line	356; tstMenu.c	if ( nEnc[0] )               // If pin 0 used to be high
	MOVF	_nEnc, W, B
	BZ	_00185_DS_
;	.line	357; tstMenu.c	if ( !ENC0 )               // and it's not high now
	BTFSC	_PORTBbits, 3
	BRA	_00185_DS_
;	.line	359; tstMenu.c	FreqUp();              // decrease the frequency
	CALL	_FreqUp
;	.line	360; tstMenu.c	nEncDirty = 1;         // and remember we need to display
	MOVLW	0x01
	BANKSEL	_nEncDirty
	MOVWF	_nEncDirty, B
_00185_DS_:
	BANKSEL	(_nEnc + 1)
;	.line	362; tstMenu.c	if ( nEnc[1] )               // If pin 1 used to be high
	MOVF	(_nEnc + 1), W, B
	BZ	_00189_DS_
;	.line	363; tstMenu.c	if ( !ENC1 )               // and it's not high now
	BTFSC	_PORTBbits, 2
	BRA	_00189_DS_
;	.line	365; tstMenu.c	FreqDn();              // Decrease the frequency
	CALL	_FreqDn
;	.line	366; tstMenu.c	nEncDirty = 1;         // and remember we changed it
	MOVLW	0x01
	BANKSEL	_nEncDirty
	MOVWF	_nEncDirty, B
_00189_DS_:
;	.line	368; tstMenu.c	nEnc[0] = (byte) ENC0;       // Now remember the current encoder
	CLRF	r0x00
	BTFSC	_PORTBbits, 3
	INCF	r0x00, F
	LFSR	0x00, _nEnc
	MOVFF	r0x00, INDF0
;	.line	369; tstMenu.c	nEnc[1] = (byte) ENC1;       // state for next time
	CLRF	r0x00
	BTFSC	_PORTBbits, 2
	INCF	r0x00, F
	LFSR	0x00, (_nEnc + 1)
	MOVFF	r0x00, INDF0
	BANKSEL	_nEncDirty
;	.line	370; tstMenu.c	return nEncDirty;            // Return true if changed
	MOVF	_nEncDirty, W, B
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__FreqDn	code
_FreqDn:
;	.line	342; tstMenu.c	void FreqDn( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
	MOVFF	r0x03, POSTDEC1
;	.line	344; tstMenu.c	nFreq = nFreq - nStep;       // Decrease by selected step size
	MOVFF	_nStep, r0x00
	CLRF	r0x01
	CLRF	WREG
	BTFSC	r0x01, 7
	MOVLW	0xff
	MOVWF	r0x02
	MOVWF	r0x03
	MOVF	r0x00, W
	BANKSEL	_nFreq
	SUBWF	_nFreq, F, B
	MOVF	r0x01, W
; removed redundant BANKSEL
	SUBWFB	(_nFreq + 1), F, B
	MOVF	r0x02, W
; removed redundant BANKSEL
	SUBWFB	(_nFreq + 2), F, B
	MOVF	r0x03, W
; removed redundant BANKSEL
	SUBWFB	(_nFreq + 3), F, B
;	.line	345; tstMenu.c	if ( nFreq < 14000000 )      // And limit the lower frequency
	MOVF	(_nFreq + 3), W, B
	ADDLW	0x80
	ADDLW	0x80
	BNZ	_00177_DS_
	MOVLW	0xd5
; removed redundant BANKSEL
	SUBWF	(_nFreq + 2), W, B
	BNZ	_00177_DS_
	MOVLW	0x9f
; removed redundant BANKSEL
	SUBWF	(_nFreq + 1), W, B
	BNZ	_00177_DS_
	MOVLW	0x80
; removed redundant BANKSEL
	SUBWF	_nFreq, W, B
_00177_DS_:
	BC	_00174_DS_
;	.line	346; tstMenu.c	nFreq = 14000000;          // to the band edge
	MOVLW	0x80
	BANKSEL	_nFreq
	MOVWF	_nFreq, B
	MOVLW	0x9f
; removed redundant BANKSEL
	MOVWF	(_nFreq + 1), B
	MOVLW	0xd5
; removed redundant BANKSEL
	MOVWF	(_nFreq + 2), B
; removed redundant BANKSEL
	CLRF	(_nFreq + 3), B
_00174_DS_:
	MOVFF	PREINC1, r0x03
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__FreqUp	code
_FreqUp:
;	.line	331; tstMenu.c	void FreqUp( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
	MOVFF	r0x03, POSTDEC1
;	.line	333; tstMenu.c	nFreq = nFreq + nStep;       // Bump the freq up by the setpsize
	MOVFF	_nStep, r0x00
	CLRF	r0x01
	CLRF	WREG
	BTFSC	r0x01, 7
	MOVLW	0xff
	MOVWF	r0x02
	MOVWF	r0x03
	MOVF	r0x00, W
	BANKSEL	_nFreq
	ADDWF	_nFreq, F, B
	MOVF	r0x01, W
; removed redundant BANKSEL
	ADDWFC	(_nFreq + 1), F, B
	MOVF	r0x02, W
; removed redundant BANKSEL
	ADDWFC	(_nFreq + 2), F, B
	MOVF	r0x03, W
; removed redundant BANKSEL
	ADDWFC	(_nFreq + 3), F, B
;	.line	334; tstMenu.c	if ( nFreq > 14100000 )      // Limit the upper frequency to
	MOVF	(_nFreq + 3), W, B
	ADDLW	0x80
	ADDLW	0x80
	BNZ	_00167_DS_
	MOVLW	0xd7
; removed redundant BANKSEL
	SUBWF	(_nFreq + 2), W, B
	BNZ	_00167_DS_
	MOVLW	0x26
; removed redundant BANKSEL
	SUBWF	(_nFreq + 1), W, B
	BNZ	_00167_DS_
	MOVLW	0x21
; removed redundant BANKSEL
	SUBWF	_nFreq, W, B
_00167_DS_:
	BNC	_00164_DS_
;	.line	335; tstMenu.c	nFreq = 14100000;          // the common CW portion
	MOVLW	0x20
	BANKSEL	_nFreq
	MOVWF	_nFreq, B
	MOVLW	0x26
; removed redundant BANKSEL
	MOVWF	(_nFreq + 1), B
	MOVLW	0xd7
; removed redundant BANKSEL
	MOVWF	(_nFreq + 2), B
; removed redundant BANKSEL
	CLRF	(_nFreq + 3), B
_00164_DS_:
	MOVFF	PREINC1, r0x03
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block
S_tstMenu__ShowFreq	code
_ShowFreq:
;	.line	319; tstMenu.c	void ShowFreq( void )
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
;	.line	321; tstMenu.c	ltoa(nFreq,szMsg,10);        // Convert to ASCII text
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVLW	HIGH(_szMsg)
	MOVWF	POSTDEC1
	MOVLW	LOW(_szMsg)
	MOVWF	POSTDEC1
	BANKSEL	(_nFreq + 3)
	MOVF	(_nFreq + 3), W, B
	MOVWF	POSTDEC1
; removed redundant BANKSEL
	MOVF	(_nFreq + 2), W, B
	MOVWF	POSTDEC1
; removed redundant BANKSEL
	MOVF	(_nFreq + 1), W, B
	MOVWF	POSTDEC1
; removed redundant BANKSEL
	MOVF	_nFreq, W, B
	MOVWF	POSTDEC1
	CALL	_ltoa
	MOVLW	0x07
	ADDWF	FSR1L, F
;	.line	322; tstMenu.c	strcat(szMsg," Hz");         // Add "Hz" to the string
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	r0x02
	MOVLW	UPPER(__str_0)
	MOVWF	POSTDEC1
	MOVLW	HIGH(__str_0)
	MOVWF	POSTDEC1
	MOVLW	LOW(__str_0)
	MOVWF	POSTDEC1
	MOVF	r0x02, W
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_strcat
	MOVLW	0x06
	ADDWF	FSR1L, F
;	.line	323; tstMenu.c	LCDclear();                  // Clear the display
	CALL	_LCDclear
;	.line	324; tstMenu.c	Message(szMsg);              // and show the frequency
	MOVLW	HIGH(_szMsg)
	MOVWF	r0x01
	MOVLW	LOW(_szMsg)
	MOVWF	r0x00
	MOVLW	0x80
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_Message
	MOVLW	0x03
	ADDWF	FSR1L, F
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	

; ; Starting pCode block for Ival
	code
_menuText:
	DB	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00, 0x20, 0x20, 0x53
	DB	0x74, 0x65, 0x70, 0x00, 0x00, 0x00, 0x20, 0x4b, 0x65, 0x79, 0x65, 0x72
	DB	0x00, 0x00, 0x00, 0x20, 0x50, 0x6f, 0x77, 0x65, 0x72, 0x00, 0x00, 0x00
	DB	0x20, 0x20, 0x42, 0x61, 0x63, 0x6b, 0x00, 0x00, 0x00, 0x20, 0x20, 0x20
	DB	0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x31, 0x30, 0x00, 0x00
	DB	0x00, 0x00, 0x00, 0x20, 0x20, 0x31, 0x30, 0x30, 0x00, 0x00, 0x00, 0x00
	DB	0x20, 0x53, 0x70, 0x65, 0x65, 0x64, 0x00, 0x00, 0x00, 0x20, 0x57, 0x65
	DB	0x69, 0x67, 0x68, 0x74, 0x00, 0x00, 0x20, 0x20, 0x20, 0x55, 0x70, 0x00
	DB	0x00, 0x00, 0x00, 0x20, 0x20, 0x44, 0x6f, 0x77, 0x6e, 0x00, 0x00, 0x00
	DB	0x50, 0x72, 0x6f, 0x63, 0x73, 0x73, 0x6e, 0x67, 0x00
; ; Starting pCode block for Ival
_stateMsg:
	DB	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x04, 0x08, 0x09, 0x04
	DB	0x0a, 0x0b, 0x04, 0x0a, 0x0b, 0x04, 0x0a, 0x0b, 0x04, 0x0c, 0x0c, 0x0c
	DB	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c
; ; Starting pCode block for Ival
_nextPB1:
	DB	0x01, 0x04, 0x01, 0x02, 0x03, 0x08, 0x05, 0x06, 0x07, 0x0b, 0x09, 0x0a
	DB	0x0e, 0x0c, 0x0d, 0x11, 0x0f, 0x10, 0x14, 0x12, 0x13, 0x15, 0x16, 0x17
	DB	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d
; ; Starting pCode block for Ival
_nextPB2:
	DB	0x01, 0x06, 0x09, 0x0d, 0x00, 0x15, 0x16, 0x17, 0x01, 0x0f, 0x12, 0x02
	DB	0x1c, 0x1d, 0x03, 0x18, 0x19, 0x09, 0x1a, 0x1b, 0x0a, 0x15, 0x16, 0x17
	DB	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d
; ; Starting pCode block for Ival
_nextPB3:
	DB	0x01, 0x02, 0x03, 0x04, 0x01, 0x06, 0x07, 0x08, 0x05, 0x0a, 0x0b, 0x09
	DB	0x0d, 0x0e, 0x0c, 0x10, 0x11, 0x0f, 0x13, 0x14, 0x12, 0x15, 0x16, 0x17
	DB	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d
; ; Starting pCode block for Ival
_nextTimer:
	DB	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	DB	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x06, 0x07
	DB	0x0f, 0x10, 0x12, 0x13, 0x0c, 0x0d
; ; Starting pCode block
__str_0:
	DB	0x20, 0x48, 0x7a, 0x00
; ; Starting pCode block
__str_1:
	DB	0x4b, 0x65, 0x79, 0x20, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x3d, 0x00
; ; Starting pCode block
__str_2:
	DB	0x4b, 0x65, 0x79, 0x65, 0x72, 0x20, 0x53, 0x70, 0x65, 0x65, 0x64, 0x3d
	DB	0x00
; ; Starting pCode block
__str_3:
	DB	0x50, 0x6f, 0x77, 0x65, 0x72, 0x3d, 0x00


; Statistics:
; code size:	 2102 (0x0836) bytes ( 1.60%)
;           	 1051 (0x041b) words
; udata size:	   63 (0x003f) bytes (98.44%)
; access size:	    7 (0x0007) bytes


	end
