;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 2.8.0 #5117 (Mar 23 2008) (UNIX)
; This file was generated Fri Jan 16 09:15:11 2009
;--------------------------------------------------------
; PIC16 port for the Microchip 16-bit core micros
;--------------------------------------------------------
	list	p=18f1320

	radix dec

;--------------------------------------------------------
; public variables in this module
;--------------------------------------------------------
	global _Delay2
	global _Delay
	global _Delay4

;--------------------------------------------------------
; extern variables in this module
;--------------------------------------------------------
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
	extern _T0CONbits
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
;--------------------------------------------------------
;	Equates to used internal registers
;--------------------------------------------------------
STATUS	equ	0xfd8
FSR1L	equ	0xfe1
FSR2L	equ	0xfd9
POSTDEC1	equ	0xfe5
PREINC1	equ	0xfe4


; Internal registers
.registers	udata_ovr	0x0000
r0x00	res	1
r0x01	res	1

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
; I code from now on!
; ; Starting pCode block
S_Delay1320__Delay4	code
_Delay4:
;	.line	23; Delay1320.c	Delay();
	CALL	_Delay
;	.line	24; Delay1320.c	Delay();
	CALL	_Delay
;	.line	25; Delay1320.c	Delay();
	CALL	_Delay
;	.line	26; Delay1320.c	Delay();
	CALL	_Delay
	RETURN	

; ; Starting pCode block
S_Delay1320__Delay	code
_Delay:
;	.line	15; Delay1320.c	Delay2();
	CALL	_Delay2
;	.line	16; Delay1320.c	Delay2();
	CALL	_Delay2
;	.line	17; Delay1320.c	Delay2();
	CALL	_Delay2
;	.line	18; Delay1320.c	Delay2();
	CALL	_Delay2
	RETURN	

; ; Starting pCode block
S_Delay1320__Delay2	code
_Delay2:
;	.line	3; Delay1320.c	void Delay2(void)
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
;	.line	9; Delay1320.c	while ( Count != 0 )
	SETF	r0x00
	MOVLW	0x3f
	MOVWF	r0x01
_00105_DS_:
	MOVF	r0x00, W
	IORWF	r0x01, W
	BZ	_00108_DS_
;	.line	10; Delay1320.c	Count--;
	MOVLW	0xff
	ADDWF	r0x00, F
	BTFSS	STATUS, 0
	DECF	r0x01, F
	BRA	_00105_DS_
_00108_DS_:
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	RETURN	



; Statistics:
; code size:	   76 (0x004c) bytes ( 0.06%)
;           	   38 (0x0026) words
; udata size:	    0 (0x0000) bytes ( 0.00%)
; access size:	    2 (0x0002) bytes


	end
