; ****************************************************************************
; *  SerDDS - A serial driver for the NJQRP DDS Daughtercard                 *
; *  Ver 1.0                                                                 *
; *  February 29, 2004                                                       *
; *  by Dave Ek (NK0E) and George Heron (N2APB)                              *
; ****************************************************************************
;    This is a PC application written to control the DDS Daughtercard connected 
; to a Serial CW Sender pc board.  The PC is connected to the Serial Sender
; board via an ordinary 9-pin serial cable.  A terminal program like HyperTerm
; running on the PC displays a menu of commands that allow the user to program
; the DDS Daughtercard to generate a signal, specify start and end frequencies
; for an automatic sweep function, specify a step size for that sweep, save 
; the settings to EEPROM, recall the settings from EEPROM, and reset the settings
; to default values.
;
;    The program is a combination of the NK0E Serial CW Sender project (for the
; serial communications to the PC terminal program), and the "PEgen" DDS Controller
; program written by Craig Johnson, AA0ZZ for the PIC-EL project.
;
;    The "SerDDS" PIC program on the board presents a command line interpretter to 
; the user with which he can select commands from a displayed menu. The most common 
; command will be to generate a specific frequency. This is done by typing the menu 
; letter A and entering up to eight digits.  This number is converted into the proper 
; DDS programming word and is loaded into the DDS Daughtercard riding piggy-back on 
; the pc board.  So all the user would need to do is plug the serial cable into the 
; PC, bring up HyperTerm on the PC, and SerDDS software on the PIC generates the 
; specified frequencies via the DDS Daughtercard. 
;
; COMMANDS 
; ========
;    The PIC16F628 microcontroller is programmed to use the PC screen as its terminal,
; displaying a list of commands available to the user. You can then enter commands and
; data via the PC keyboard to instruct the Serial DDS Controller to output a given 
; frequency, set the start and end points of a range, set the step size, and scan the
; range. All entered settings are automatically saved in the PIC's EEPROM memory, so
; those values are available even after power cycling.
;
;    The menu that gets displayed is shown below.  We'll continue to enhance the features
; and later versions of the SerDDS program will be posted on the project website for you
; to download and reprogram your PIC to get the newer features. If you cannot burn your
; own PIC, contact the AmQRP and we can reprogram your device and mail it back to you for
; a modest price.
; 
; SerDDS v1.0:   
; A: Set Freq (Direct frequency entry from 1 Hz to 30000000 Hz) 
; B: Start Freq (Entry of a start frequency) 
; C: End Freq (Entry of end frequency) 
; D: Step Size (Entry of a step size) 
; E: Scan (from Start to Stop, using step size) 
; F: Show (show settings for start, stop, step) 
; G: Jog Up (or >) (using step size) 
; H: Jog Down (or <) (using step size) 
; M: Help (display this single-word menu, without parentheticals) 
;
;    When entering frequencies (menu items A through D) the program will accept any number
; of digits up to eight and allow use of the backspace key to edit. You must hit a carriage
; return to finish the entry. If fewer than eight digits are entered, they are padded with
; leading zeros to make eight digits. 
;
;    Further Descriptions, photographs and other notes can be found on the Serial DDS 
; project web page at www.amqrp.org/projects/serdds.


;*****************************************************************************
;                                                                             P
; Target Controller -      PIC16F628                                          P 
;                          __________                                         P
;                     RA2 |1       18| RA1---------SEROUT to PC               P
;                     RA3 |2       17| RA0                                    P
;                     RA4 |3       16| OSC1--------XTAL                       P
;     +5V-----------!MCLR |4       15| OSC2--------XTAL                       P
;     Ground----------Vss |5       14| VDD---------+5 V                       P
;     SERIN from PC---RB0 |6       13| RB7---------DDS_LOAD                   P
;                     RB1 |7       12| RB6                                    P
;           DDS_CLK---RB2 |8       11| RB5                                    P  
;           DDS_DATA--RB3 |9       10| RB4                                    P
;                          ----------                                         P
;                                                                             P
; ****************************************************************************
; * Device type and options.                                                 *
; ****************************************************************************

	include "P16f628.inc" 
	processor       PIC16F628
        __config 	_XT_OSC & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _LVP_OFF     
	radix           dec
	errorlevel	-302	; suppress message 302 from list file

; ****************************************************************************
; * General equates.  These may be changed to accommodate the reference clock* 
; * frequency, the desired upper frequency limit, and the default startup    *
; * frequency.                                                               *
; ****************************************************************************
;
; ref_osc represents the change in the frequency control word which results 
; in a 1 Hz change in output frequency.  It is interpreted as a fixed point
; integer in the format <ref_osc_3>.<ref_osc_2><ref_osc_1><ref_osc_0>
;
; The values for common oscillator frequencies are as follows:
;
; Frequency    ref_osc_3    ref_osc_2    ref_osc_1    ref_osc_0              
; 100.00 MHz     0x2A         0xF3         0x1D         0xC4                              
;
; To calculate other values: 
;    ref_osc_3 = (2^32 / oscillator_freq_in_Hertz).                           
;    ref_osc_2, ref_osc_1, and ref_osc_0 are the fractional part of           
;     (2^32 / oscillator_freq_in_Hertz) times 2^24.                           
;    Note:   2^32 = 4294967296 and 2^24 = 16777216
;
;==== Currently set for 100 MHz Oscillator =======
ref_osc_3   equ 0x2A              ; Most significant osc byte
ref_osc_2   equ 0xF3              ; Next byte
ref_osc_1   equ 0x1D              ; Next byte
ref_osc_0   equ 0xC4              ; Least significant byte
;
; Default contains the default startup frequency as a 32 bit integer.
;
default_3 equ 0x00                ; Most significant byte for 14.025 MHz
default_2 equ 0xD6                ; Next byte
default_1 equ 0x01                ; Next byte
default_0 equ 0x28                ; Least significant byte 
;
band_end equ    0x28              ; The offset to the last band table entry 
;
; ****************************************************************************
; * Assign names to IO pins.                                                 *
; ****************************************************************************
;   B register bits:
;
DDS_clk equ     0x02              ; AD9850 write clock
DDS_dat equ     0x03              ; AD9850 serial data input
DDS_load equ    0x07              ; Update pin on AD9850

; ****************************************************************************
; * Assign names for Serial Port Driver.                                     *
; ****************************************************************************
; These are used by the serial comm routines for timing. Note that
; slower speeds may not work well because the delays might be larger
; than 255, requiring the use of the prescalar.

_Clkspd		equ	1000000			;external clock / 4
_BaudRate	equ	9600			;desired baud rate
_Period		equ	(_Clkspd/_BaudRate)	;clock cycles / bit

_StartRxDelay	equ	(_Period/2 - 15)/3	;this is how long to
						;wait to get to the
						;middle of the start
						;bit. This is loops,
						;not clock cycles.

_BitRxDelay	equ	277 - _Period		;this is what to load
						;into TMR0 for correct
						;interval between bits
						;on RX

_BitTxDelay	equ	285 - _Period		;this is what to load
						;into TMR0 for correct
						;interval between bits
						;on TX

_StopTxDelay	equ	272 - _Period		;this is what to load
						;into TMR0 for correct
						;interval betweeen last
						;bit and stop bit on TX

; constants for timing the CW:

;_MSDelay	equ	(_Clkspd/10000)		;number of times to execute the
						;delay loop to get a MS delay.
						;assumes 10 clock cycles per
						;trip through the delay loop.

; constants for PORTA:

_TX		equ	1			;serial output is PORTA,1

; constants for PORTB:

_RX		equ	0			;PORTB,0 receives the serial input

; constants for ascii to binary conversion of input frequency:
; defines for hex equivalent of each of the eight ascii digits to be received:

; 10 millions
_Digit7_byte2	equ 0x98
_Digit7_byte1	equ	0x96
_Digit7_byte0	equ	0x80

; millions
_Digit6_byte2	equ	0x0F
_Digit6_byte1	equ	0x42
_Digit6_byte0	equ	0x40

; 100 thousands
_Digit5_byte2	equ	0x01
_Digit5_byte1	equ	0x86
_Digit5_byte0	equ	0xA0

; 10 thousands
_Digit4_byte1	equ	0x27
_Digit4_byte0	equ	0x10

; thousands
_Digit3_byte1	equ	0x03
_Digit3_byte0	equ	0xE8

; hundreds
_Digit2_byte0	equ	0x64

; tens
_Digit1_byte0	equ	0x0A

; ones
_Digit0_byte0	equ	0x01

; Defines for the EEPROM memory locations:

_EEPROM_Freq	equ	0x00
_EEPROM_Start	equ	0x04
_EEPROM_End	equ	0x08
_EEPROM_Step	equ	0x0C

; ****************************************************************************
; *           Allocate variables in general purpose register space           *
; ****************************************************************************
;
	CBLOCK  0x20	; Start Data Block

	; note: freq_* doesn't always hold the current frequency of the dds.
	; call Get_Frequency to load freq_* with the value stored in EEPROM
	; (EEPROM should always be updated whenever frequency is changed)
        freq_0                    ; Display frequency (hex) 
          freq_1                  ;  (4 bytes) 
          freq_2
          freq_3         
        AD9850_0                  ; AD9850 control word 
          AD9850_1                ;  (5 bytes)
          AD9850_2
          AD9850_3
          AD9850_4
        mult_count                ; Used in calc_dds_word 
        bit_count                 ;   "
        byte2send                 ;
        osc_0                     ; Current oscillator 
          osc_1                   ;  (4 bytes)
          osc_2
          osc_3
        osc_temp_0                ; Oscillator frequency 
          osc_temp_1              ;  (4 bytes)
          osc_temp_2        
          osc_temp_3
        timer1                    ; Used in delay routines
        timer2                    ;   "
        count                     ; loop counter  (gets reused)

	BitCount	;number of bits left to send or
			;receive, not including start & stop
			;bits

	RXChar		;received character while being received
	RXBuff		;most recently received character

	TXChar		;character to transmit

	SerialReg	;status register:
			;bit 0: on if character has been
			;       received
			;bit 1: on if busy with RX/TX
			;bit 2: on if sending, off if receiving
			;bit 3: on if next bit to send is stop bit

	WSave		;copy of W register

	SSave		;copy of the Status register

	Digit_val	; the value of the current frequency digit being processed
			; (not the ASCII value)

	Add_0		; a four-byte number to add using the Add_DWord subroutine
	Add_1		; (Add_3 is high byte)
	Add_2
	Add_3

	ASCII_Buf:8	; eight-character ASCII buffer

        ENDC                      ; End of Data Block

; ****************************************************************************
; * The 16F628 resets to 0x00.                                      * 
; ****************************************************************************             
;
        ORG     0x0000                
reset_entry
	movlw	h'07'
	movwf	CMCON	; Turn off Comparator

        goto	start	; Jump around the band table to main program

; ****************************************************************************             
; * The Interrupt vector is at 0x04.                                         *
; ****************************************************************************             
	org	0x04
;--------------------------------------------------------------------
;-----Serial Communication Routines----------------------------------
;--------------------------------------------------------------------
; The serial comm routines generate 1 start bit, 8 data bits, 1 stop bit, 
; no parity. The baud rate is determined by the delay programmed
; into the onboard timer. The sending and receiving is interrupt driven,
; meaning other tasks can be carried on while the characters are being
; sent and received.
;
;-----Main Interrupt Routine-----------------------------------------
;
; for timing: 4 cycles from interrupt time to get here.

; Save the W and STATUS registers:

Int
	movwf	WSave
	swapf	STATUS,W	;use swapf to prevent any
	movwf	SSave		;status flags from being changed

; cycles so far since interrupt occurred: 7

; Okay, I'm doing something goofy here. Instead of actually checking
; the overflow bits themselves, I'm using the enable bits to determine
; which interrupt occurred. I can do this because there should only
; ever be one type of interrupt active at a time. The problem with
; checking the overflow bits is that the T0IF bit can get set even
; if that interrupt is disabled.

; Check first for a timer overflow interrupt. The overflow bit gets
; set even if the interrupt is disabled.

	btfsc	INTCON,T0IE
	goto	DoBit		;we're in the middle of sending or
				;receiving

; 10 cycles executed on entry to DoBit

; If not a timer overflow interrupt, check for external interrupt:

	btfsc	INTCON,INTE	;RB0 is our receive line and it
	goto	StartRX		;generates an interrupt on a high-
				;to-low transition

; 12 cycles executed on entry to StartRX

; Else, must be something we don't care about:

	;do nothing for now

; Restore the W and STATUS registers:

Restore	swapf	SSave,W
	movwf	STATUS
	swapf	WSave,F
	swapf	WSave,W

	retfie

;------Subroutine SerSetup-------------------------------------------

SerSetup

; set up the option register for internal counting, WDT disabled,
; no prescaler.

	clrf	TMR0
	bsf	STATUS,RP0
	clrwdt			;set bits in OPTION_REG to
	movlw	b'10001000'	;enable internal clock counting,
	movwf	OPTION_REG	;disable watchdog timer.
	bcf	STATUS,RP0	;switch to bank 0

; set the output line to idle (high)

	bsf	PORTA,_TX	;set the output line to idle(high) state
;	movlw	b'00000001'
;	movwf	PORTB

; enable the external interrupt via RB0

	movlw	b'10010000'	;set bits in INTCON to enable
	movwf	INTCON		;external interrupt

; initialize the SerialReg:

	clrf	SerialReg

	return

;------Subroutine StartRX--------------------------------------------
;
; This subroutine is called by the main interrupt routine when an
; external interrupt on RB0 occurs. This means we're receiving the
; start bit for a character. We want to enable the external TMR0
; interrupt and prepare to receive the character.

StartRX

; wait halfway through the bit to see if it's real:

	bcf	INTCON,INTF	;clear the interrupt
	movlw	_StartRxDelay
	movwf	BitCount	;this is the 15th instruction since
				;the interrupt. Note--we're using
				;BitCount for this loop purely for
				;convenience. Usually it's used to
				;actually count the bits we TX/RX.

RXWait	decfsz	BitCount,F	;this loop takes 3 times the initial
	goto	RXWait		;value of BitCount clock cycles
	
; now we should be at the middle of the start bit. Is the input still
; low? If not, goto Restore and ignore this interrupt.

	btfsc	PORTB,_RX
	goto	Restore

; if we get to here it must really be the start bit. Load TMR0,
; disable the external interrupt, and enable the TMR0 interrupt. 

; load up the appropriate delay to get us to the middle of the
; first bit:

	movlw	_BitRxDelay
	movwf	TMR0		;4 cycles from read of PORTB
	movlw	b'00100000'
	movwf	INTCON

; set the SerialReg to indicate that the routines are busy getting
; a character:

	movlw	b'00000010'
	movwf	SerialReg

; initialize BitCount:

	movlw	8
	movwf	BitCount

; okay, now we return.

	goto	Restore

;------DoBit---------------------------------------------------------
;
; sends or receives the next bit. Bits are sent/received from least
; to most significant bit.

DoBit

; clear the TMR0 overflow interrupt flag:

	bcf	INTCON,T0IF

; Are we receiving?

	btfsc	SerialReg,2
	goto	Sending

; check to see if we're receiving the stop bit:

	movf	BitCount,F
	btfsc	STATUS,Z
	goto	GetStopBit

; if we get to here, we're in the middle of receiving. Get the next
; bit: (16 cycles to get to the next instruction from the start of
; the interrupt).

	rrf	PORTB,W		;rrf PORTB into W. This sets
				;the carry bit if RB0 was high.
	rrf	RXChar,F	;doing a rrf on RXChar brings
				;in the carry bit to the MSB.

; Decrement the bit counter.

	decf	BitCount,F

; reload TMR0 for the next interrupt, and
; go to the end of the interrupt routine.

	movlw	_BitRxDelay	
	movwf	TMR0		;21 cycles from start of interrupt
	goto	Restore

; if we get to here it's because we need to check for the stop bit.

GetStopBit
	btfss	PORTB,_RX	;is the RX line low? If so, it's not
	goto	Done		;the stop bit. Otherwise, set the
	movlw	b'00000001'	;SerialReg to show a character has
	movwf	SerialReg	;been received
	movf	RXChar,W	;copy the received character to RXBuff
	movwf	RXBuff
	goto	Done
		
; We got here because we're sending.
; check to see if we're finished sending the stop bit:

Sending
	btfsc	SerialReg,3
	goto	Done

; check to see if we need to send the stop bit:

	movf	BitCount,F
	btfsc	STATUS,Z	;18th cycle
	goto	SendStopBit

; if we get to here, we're in the middle of sending. Send the next
; bit: (16 cycles to get to the next instruction from the start of
; the interrupt).

	rrf	TXChar,F	;doing rrf on TXChar puts the
	btfss	STATUS,C	;least significant bit in the
	goto	SendZero	;carry flag.
	nop
	bsf	PORTA,_TX	;if carry is set, send a one.
	goto	EndDoBit	;PORTA,_TX is set on the 24th cycle

SendZero
	bcf	PORTA,_TX	;otherwise, send a zero. (24th cycle)
	nop			;nop's are for taking the same time
	nop			;to get to reloading TMR0 as for when
				;a one is sent.

; Decrement the bit counter.

EndDoBit
	decf	BitCount,F

; reload TMR0 for the next interrupt, and
; go to the end of the interrupt routine.

	movlw	_BitTxDelay	
	movwf	TMR0		;29th cycle
	goto	Restore


; Here we need to send the stop bit, turn off the TMR0 interrupt,
; turn on the external interrupt, and set the SerStatus register
; flags appropriately.

SendStopBit
	nop
	nop
	nop
	bsf	PORTA,_TX		;no. Send the stop bit. (24th cycle)
	bsf	SerialReg,3	;set the "sending stop bit" flag

; reload TMR0 for the next interrupt, and
; go to the end of the interrupt routine.

	movlw	_StopTxDelay
	movwf	TMR0		;27th cycle
	goto	Restore

; we're completely done sending or receiving. Clean up.

Done	movlw	b'00010000'	;set bits in INTCON to enable
	movwf	INTCON		;external interrupt
	movlw	b'00000001'
	andwf	SerialReg,F	;clear the busy bits in SerialReg
	goto	Restore

;------Subroutine SendChar-------------------------------------------
;
; This is not called by the interrupt handler. Rather, it activates 
; the interrupts needed to send it. Put the character to be sent in
; the TXChar file register before calling this subroutine.
;

SendChar
	
; send the start bit:

	bcf	PORTA,_TX

; set the SerStatus to indicate that the routines are busy sending
; a character:

	movlw	b'00000110'
	movwf	SerialReg

; load up TMR0 so it overflows at the right time.

	nop			;for timing
	movlw	_BitTxDelay
	movwf	TMR0		;5th cycle after write to PORTA

; clear the external interrupt flag, disable the external interrupt,
; and enable the TMR0 interrupt.

	movlw	b'10100000'
	movwf	INTCON

; set the BitCount for the eight bits to send:

	movlw	8
	movwf	BitCount

	return

;------GetAChar------------------------------------------------

GetAChar
	call	Idle
	btfss	SerialReg,0	;wait for a character to be received
	goto	GetAChar
	bcf	SerialReg,0
	return

;------SendAChar-----------------------------------------------

SendAChar
	call	SendChar

WaitToFinish
	call	Idle
	btfsc	SerialReg,1	;wait for the character to be sent
	goto	WaitToFinish
	return

; ------Dispatch_Table---------------------------------------
;
; This is a table jump to dispatching commands entered by the
; user. Also using this table to store the characters needed 
; for the command prompts.
;
;DO NOT MOVE THIS ROUTINE WITHOUT CHECKING TO MAKE SURE
; IT DOESN'T CROSS A 256-BYTE BOUNDARY!

Dispatch_Table
	addwf	PCL,F
	goto	Handle_A
	goto	Handle_B
	goto	Handle_C
	goto	Handle_D
	goto	Handle_E
	goto	Handle_F
	goto	Handle_G
	goto	Handle_H
	goto	Handle_I

Signon
	retlw	'S'
	retlw	'e'
	retlw	'r'
	retlw	'D'
	retlw	'D'
	retlw	'S'
	retlw	' '
	retlw	'v'
	retlw	'1'
	retlw	'.'
	retlw	'0'
	retlw	0

Prompt_A		;Freq
	retlw	'F'
	retlw	'r'
	retlw	'e'
	retlw	'q'
	retlw	0

Prompt_B		;Start Freq
	retlw	'S'
	retlw	't'
	retlw	'a'
	retlw	'r'
	retlw	't'
	retlw	0

Prompt_C		;End Freq
	retlw	'E'
	retlw	'n'
	retlw	'd'
	retlw	0

Prompt_D		;Step
	retlw	'S'
	retlw	't'
	retlw	'e'
	retlw	'p'
	retlw	0

Prompt_E		;Scan
	retlw	'S'
	retlw	'c'
	retlw	'a'
	retlw	'n'
	retlw	0

Prompt_F		;Show
	retlw	'S'
	retlw	'h'
	retlw	'o'
	retlw	'w'
	retlw	0

Prompt_G		;Jog Up
	retlw	'U'
	retlw	'p'
	retlw	' '
	retlw	'('
	retlw	'o'
	retlw	'r'
	retlw	' '
	retlw	'>'
	retlw	')'
	retlw	0

Prompt_H		;Jog Down
	retlw	'D'
	retlw	'o'
	retlw	'w'
	retlw	'n'
	retlw	' '
	retlw	'('
	retlw	'o'
	retlw	'r'
	retlw	' '
	retlw	'<'
	retlw	')'
	retlw	0

Prompt_I		;Help
	retlw	'H'
	retlw	'e'
	retlw	'l'
	retlw	'p'
	retlw	0

;---------------------------------------------------------------


; ------Sub_DWord-----------------------------------------------
; subtracts Add_* from freq_*. Stores the result in freq_*. Does
; subtraction using two's complement addition.

Sub_DWord

	comf	Add_0,F		;complement the four bytes
	comf	Add_1,F
	comf	Add_2,F
	comf	Add_3,F
	incf	Add_0,F		;add one
	btfss	STATUS,Z	;handle carry in byte 0
	goto	Add_DWord
	incf	Add_1,F		;handle carry in byte 1
	btfss	STATUS,Z
	goto	Add_DWord	;handle carry in byte 2
	incf	Add_2,F
	btfss	STATUS,Z	;handle carry in byte 3
	goto	Add_DWord
	incf	Add_3,F

	; falls through to Add_DWord now to finish the subtraction

; -------------------------------------------------------------

; ------Add_DWord----------------------------------------------
; adds freq_* to Add_*. Stores the result in freq_*.

Add_DWord

	movf	freq_3,W
	addwf	Add_3,W
	movwf	freq_3

	movf	freq_2,W
	addwf	Add_2,W
	btfsc	STATUS,C
	call	inc_3
	movwf	freq_2

	movf	freq_1,W
	addwf	Add_1,W
	btfsc	STATUS,C
	call	inc_2
	movwf	freq_1

	movf	freq_0,W
	addwf	Add_0,W
	btfsc	STATUS,C
	call	inc_1
	movwf	freq_0

	return

; inc_1, inc_2, and inc_3 provide a convenient way to increment on carries
; during the add above, in case multiple carries occur on an add

inc_1
	incf	freq_1,F
	btfss	STATUS,Z
	return
inc_2
	incf	freq_2,F
	btfss	STATUS,Z
	return
inc_3
	incf	freq_3,F
	return

; --------Loop_Add------------------------------------------------
; Loop_Add is called by ASCII_to_Bin to repeatedly add one to the current
; digit. It assumes that Digit_val has been loaded with the ASCII character
; for the digit and Add_3, Add_2, Add_1, Add_0 are the value to add to the
; buffer repeatedly. For example, if Digit_val is '5' and we're working on the
; tens digit, ten is added to the buffer five times. Loop_Add skips the add
; process if Digit_val is '0'.

Loop_Add
	movlw	'0'		;skip if the digit is zero
	subwf	Digit_val,F
	btfsc	STATUS,Z
	return

Loop_Add_Start
	call	Add_DWord
	decfsz	Digit_val,F
	goto	Loop_Add_Start
	return

;--------ASCII_to_Bin-----------------------------------------------
; ASCII_to_Bin converts an 8-character ASCII numeric string to a binary value
; and stores it in buf_3, buf_2, buf_1, buf_0 (buf_3 is high byte).

ASCII_to_Bin

; Ten Millions
	movf	ASCII_Buf,W
	movwf	Digit_val

	clrf	Add_3
	movlw	_Digit7_byte2
	movwf	Add_2
	movlw	_Digit7_byte1
	movwf	Add_1
	movlw	_Digit7_byte0
	movwf	Add_0

	call	Loop_Add

; Millions
	movf	ASCII_Buf+1,W
	movwf	Digit_val

	movlw	_Digit6_byte2
	movwf	Add_2
	movlw	_Digit6_byte1
	movwf	Add_1
	movlw	_Digit6_byte0
	movwf	Add_0

	call	Loop_Add

; Hundred Thousands
	movf	ASCII_Buf+2,W
	movwf	Digit_val

	movlw	_Digit5_byte2
	movwf	Add_2
	movlw	_Digit5_byte1
	movwf	Add_1
	movlw	_Digit5_byte0
	movwf	Add_0

	call	Loop_Add

; Ten Thousands
	movf	ASCII_Buf+3,W
	movwf	Digit_val

	clrf	Add_2
	movlw	_Digit4_byte1
	movwf	Add_1
	movlw	_Digit4_byte0
	movwf	Add_0

	call	Loop_Add

; Thousands
	movf	ASCII_Buf+4,W
	movwf	Digit_val

	movlw	_Digit3_byte1
	movwf	Add_1
	movlw	_Digit3_byte0
	movwf	Add_0

	call	Loop_Add

; Hundreds
	movf	ASCII_Buf+5,W
	movwf	Digit_val

	clrf	Add_1
	movlw	_Digit2_byte0
	movwf	Add_0

	call	Loop_Add

; Tens
	movf	ASCII_Buf+6,W
	movwf	Digit_val

	movlw	_Digit1_byte0
	movwf	Add_0

	call	Loop_Add

; Ones
	movf	ASCII_Buf+7,W
	movwf	Digit_val

	movlw	_Digit0_byte0
	movwf	Add_0

	call	Loop_Add
	
	return


;------Loop_Subtract-------------------------------------------
; used by Bin_To_ASCII
; continues to subtract the contents of Add_* from freq_* until
; an underflow is detected, then adds Add_* back once to reverse
; the underflow. For each successful subtraction, increments
; INDF (which should point to a digit in ASCII_Buf).

Loop_Subtract
	movlw	'0'
	movwf	INDF

	; make the first subtraction. After this call, Add_*
	; contains the two's complement of the original entry.
	; Thus, subsequent subtractions (in the loop below)
	; should be performed using Add_DWord, since adding the
	; two's complement is the same as subtracting the original
	; value and this saves us the trouble of reloading the
	; original value.

	call	Sub_DWord

Loop_Subtract_Loop
	btfsc	freq_3,7		; test for negative result
	goto	Loop_Subtract_End	; jump out of the loop if negative
	incf	INDF,F
	call	Add_DWord	;see explanation above for why
				;we call Add_DWord and not Sub_DWord
	goto	Loop_Subtract_Loop

Loop_Subtract_End

	; add Add_* back to freq_* to make it positive again. Use Sub_DWord
	; since Add_* contains the two's complement of the value to add back.

	call	Sub_DWord
	return

;--------------------------------------------------------------

;------Bin_To_ASCII--------------------------------------------
;
; takes the value in freq_*, converts it to ASCII, and stores it
; in ASCII_Buf. NOTE: freq_* contents get blown away in the process.

Bin_To_ASCII

; Ten Millions
	movlw	ASCII_Buf
	movwf	FSR

	clrf	Add_3
	movlw	_Digit7_byte2
	movwf	Add_2
	movlw	_Digit7_byte1
	movwf	Add_1
	movlw	_Digit7_byte0
	movwf	Add_0

	call	Loop_Subtract

; Millions
	incf	FSR,F
	clrf	Add_3
	movlw	_Digit6_byte2
	movwf	Add_2
	movlw	_Digit6_byte1
	movwf	Add_1
	movlw	_Digit6_byte0
	movwf	Add_0

	call	Loop_Subtract

; Hundred Thousands
	incf	FSR,F
	clrf	Add_3
	movlw	_Digit5_byte2
	movwf	Add_2
	movlw	_Digit5_byte1
	movwf	Add_1
	movlw	_Digit5_byte0
	movwf	Add_0

	call	Loop_Subtract

; Ten Thousands
	incf	FSR,F
	clrf	Add_3
	clrf	Add_2
	movlw	_Digit4_byte1
	movwf	Add_1
	movlw	_Digit4_byte0
	movwf	Add_0

	call	Loop_Subtract

; Thousands
	incf	FSR,F
	clrf	Add_3
	clrf	Add_2
	movlw	_Digit3_byte1
	movwf	Add_1
	movlw	_Digit3_byte0
	movwf	Add_0

	call	Loop_Subtract

; Hundreds
	incf	FSR,F
	clrf	Add_3
	clrf	Add_2
	clrf	Add_1
	movlw	_Digit2_byte0
	movwf	Add_0

	call	Loop_Subtract

; Tens
	incf	FSR,F
	clrf	Add_3
	clrf	Add_2
	clrf	Add_1
	movlw	_Digit1_byte0
	movwf	Add_0

	call	Loop_Subtract

; Ones
	incf	FSR,F
	clrf	Add_3
	clrf	Add_2
	clrf	Add_1
	movlw	_Digit0_byte0
	movwf	Add_0

	call	Loop_Subtract
	
	return

;--------------------------------------------------------------

;------GetFrequencyFromASCII------------------------------------
; GetFrequencyFromASCII converts the character string to binary and stores it in
; freq_*

GetFrequencyFromASCII

	clrf	freq_0
	clrf	freq_1
	clrf	freq_2
	clrf	freq_3

	call	ASCII_to_Bin

	return


;------Idle----------------------------------------------------
;
; Idle should be called whenever the chip is waiting for something
; to happen (waiting for a character to be sent or received, for
; example). Currently, Idle doesn't do anything.

Idle
	return

; get_char waits for a serial character to arrive from the controlling PC
; and then echos it.

get_char
	btfss	SerialReg,0		;has character been received?
	goto	get_char		;no, loop again
	bcf	SerialReg,0		;got a char, so clear the flag
	movf	RXBuff,W		;move the rx char into W
	movwf	TXChar		
	call	SendAChar		;echo the char
	movf	RXBuff,w
	return

; *****************************************************************************
; *                                                                           *
; * Purpose:  Multiply the 32 bit number for oscillator frequency times the   *
; *           32 bit number for the displayed frequency.                      *
; *                                                                           *
; *   Input:  The reference oscillator value in osc_3 ... osc_0 and the       *
; *           current frequency stored in freq_3 ... freq_0.  The reference   *
; *           oscillator value is treated as a fixed point real, with a 24    *
; *           bit mantissa.                                                   *
; *                                                                           *
; *  Output:  The result is stored in AD9850_3 ... AD9850_0.                  *
; *                                                                           *
; *****************************************************************************
;
calc_dds_word
        clrf    AD9850_0          ; Clear the AD9850 control word bytes
        clrf    AD9850_1          ; 
        clrf    AD9850_2          ; 
        clrf    AD9850_3          ; 
        clrf    AD9850_4          ; 
        movlw   0x20              ; Set count  to 32   (4 osc bytes of 8 bits)
        movwf   mult_count        ; Keep running count
        movf    osc_0,w           ; Move the four osc bytes
        movwf   osc_temp_0        ;   to temporary storage for this multiply
        movf    osc_1,w           ; (Don't disturb original osc bytes)
        movwf   osc_temp_1        ; 
        movf    osc_2,w           ; 
        movwf   osc_temp_2        ; 
        movf    osc_3,w           ; 
        movwf   osc_temp_3        ; 
mult_loop
        bcf     STATUS,C        ; Start with Carry clear
        btfss   osc_temp_0,0      ; Is bit 0 (Least Significant bit) set?
        goto    noAdd             ; No, don't need to add freq term to total
        movf    freq_0,w          ; Yes, get the freq_0 term
        addwf   AD9850_1,f        ;   and add it in to total
        btfss   STATUS,C        ; Does this addition result in a carry?
        goto    add7              ; No, continue with next freq term
        incfsz  AD9850_2,f        ; Yes, add one and check for another carry
        goto    add7              ; No, continue with next freq term
        incfsz  AD9850_3,f        ; Yes, add one and check for another carry
        goto    add7              ; No, continue with next freq term
        incf    AD9850_4,f        ; Yes, add one and continue
add7
        movf    freq_1,w          ; Use the freq_1 term
        addwf   AD9850_2,f        ; Add freq term to total in correct position
        btfss   STATUS,C        ; Does this addition result in a carry?
        goto    add8              ; No, continue with next freq term
        incfsz  AD9850_3,f        ; Yes, add one and check for another carry
        goto    add8              ; No, continue with next freq term
        incf    AD9850_4,f        ; Yes, add one and continue
add8
        movf    freq_2,w          ; Use the freq_2 term
        addwf   AD9850_3,f        ; Add freq term to total in correct position
        btfss   STATUS,C        ; Does this addition result in a carry?
        goto    add9              ; No, continue with next freq term
        incf    AD9850_4,f        ; Yes, add one and continue
add9
        movf    freq_3,w          ; Use the freq_3 term
        addwf   AD9850_4,f        ; Add freq term to total in correct position
noAdd
        rrf     AD9850_4,f        ; Shift next multiplier bit into position
        rrf     AD9850_3,f        ; Rotate bits to right from byte to byte
        rrf     AD9850_2,f        ; 
        rrf     AD9850_1,f        ; 
        rrf     AD9850_0,f        ; 
        rrf     osc_temp_3,f      ; Shift next multiplicand bit into position
        rrf     osc_temp_2,f      ; Rotate bits to right from byte to byte
        rrf     osc_temp_1,f      ; 
        rrf     osc_temp_0,f      ; 
        decfsz  mult_count,f      ; One more bit has been done.  Are we done?
        goto    mult_loop         ; No, go back to use this bit
        clrf    AD9850_4          ; Yes, clear _4.  Answer is in bytes _3 .. _0
        return                    ; Done.
;
; *****************************************************************************
; *                                                                           *
; * Purpose:  This routine sends the AD9850 control word to the DDS chip      *
; *           using a serial data transfer.                                   *
; *                                                                           *
; *   Input:  AD9850_4 ... AD9850_0                                           *
; *                                                                           *
; *  Output:  The DDS chip register is updated.                               *
; *                                                                           *
; *****************************************************************************
;
send_dds_word
        movlw   AD9850_0          ; Point FSR at AD9850
        movwf   FSR               ; 
next_byte
        movf    INDF,w            ; 
        movwf   byte2send         ; 
        movlw   0x08              ; Set counter to 8
        movwf   bit_count         ; 
next_bit
        rrf     byte2send,f       ; Test if next bit is 1 or 0
        btfss   STATUS,C        ; Was it zero?
        goto    send0             ; Yes, send zero
        bsf     PORTB,DDS_dat     ; No, send one                              P
        bsf     PORTB,DDS_clk     ; Toggle write clock                        P
        bcf     PORTB,DDS_clk     ;                                           P
        goto    break             ; 
send0
        bcf     PORTB,DDS_dat     ; Send zero                                 P
        bsf     PORTB,DDS_clk     ; Toggle write clock                        P
        bcf     PORTB,DDS_clk     ;                                           P
break
        decfsz  bit_count,f       ; Has the whole byte been sent?
        goto    next_bit          ; No, keep going.
        incf    FSR,f             ; Start the next byte unless finished
        movlw   AD9850_4+1        ; Next byte (past the end)
        subwf   FSR,w             ; 
        btfss   STATUS,C        ;
        goto    next_byte         ;
        bsf     PORTB,DDS_load    ; Send load signal to the AD9850            P
        bcf     PORTB,DDS_load    ;                                           P
        return                    ;
;
;
; *****************************************************************************
; *                                                                           *
; * Purpose:  Wait for a specified number of milliseconds.                    *
; *                                                                           *
; *           Entry point wait_a_sec:  Wait for 1 second                      P
; *           Entry point wait_256ms:  Wait for 256 msec                      P
; *           Entry point wait_128ms:  Wait for 128 msec                      *
; *           Entry point wait_64ms :  Wait for 64 msec                       *
; *           Entry point wait_32ms :  Wait for 32 msec                       *
; *           Entry point wait_16ms :  Wait for 16 msec                       *
; *           Entry point wait_8ms  :  Wait for 8 msec                        *
; *                                                                           *
; *   Input:  None                                                            *
; *                                                                           *
; *  Output:  None                                                            *
; *                                                                           *
; *****************************************************************************
;
wait_a_sec  ; ****** Entry point ******    
        call    wait_256ms        ;       
        call    wait_256ms        ;       
        call    wait_256ms        ;       
        call    wait_256ms        ;       
        return
wait_256ms  ; ****** Entry point ******    
        call    wait_128ms        ;
        call    wait_128ms        ;
        return
wait_128ms  ; ****** Entry point ******    
        movlw   0xFF              ; Set up outer loop 
        movwf   timer1            ;   counter to 255
        goto    outer_loop        ; Go to wait loops
wait_64ms  ; ****** Entry point ******     
        movlw   0x80              ; Set up outer loop
        movwf   timer1            ;   counter to 128
        goto    outer_loop        ; Go to wait loops
wait_32ms   ; ****** Entry point ******    
        movlw   0x40              ; Set up outer loop
        movwf   timer1            ;   counter to 64
        goto    outer_loop        ; Go to wait loops
wait_16ms   ; ****** Entry point ******    
        movlw   0x20              ; Set up outer loop
        movwf   timer1            ;   counter to 32  
        goto    outer_loop        ; Go to wait loops
wait_8ms   ; ****** Entry point ******     
        movlw   0x10              ; Set up outer loop
        movwf   timer1            ;   counter to 16
                                  ; Fall through into wait loops
;
; Wait loops used by other wait routines
;  - 1 microsecond per instruction (with a 4 MHz microprocessor crystal)
;  - 510 instructions per inner loop
;  - (Timer1 * 514) instructions (.514 msec) per outer loop
;  - Round off to .5 ms per outer loop
;
outer_loop                        
        movlw   0xFF              ; Set up inner loop counter
        movwf   timer2            ;   to 255
inner_loop
        decfsz  timer2,f          ; Decrement inner loop counter
        goto    inner_loop        ; If inner loop counter not down to zero, 
                                  ;   then go back to inner loop again
        decfsz  timer1,f          ; Yes, Decrement outer loop counter
        goto    outer_loop        ; If outer loop counter not down to zero,
                                  ;   then go back to outer loop again
        return                    ; Yes, return to caller
;       
; *****************************************************************************
;
;
; *****************************************************************************
; *                                                                           *
; * Purpose:  This is the start of the program.  It initializes variables and *
; *                                                                           *
; *   Input:  The start up frequency is defined in the default_3 ...          *
; *           definitions above, and relies on the reference oscillator       *
; *           constant defined in ref_osc_3 ... ref_osc_0.                    *
; *                                                                           *
; *  Output:  Normal VFO operation.                                           *
; *                                                                           *
; *****************************************************************************
;
start
	clrf	INTCON            ; No interrupts ... for now
	bsf	STATUS,RP0      ; Switch to bank 1
	bcf	0x01,7            ; Enable weak pullups
	movlw	0xF5              ; Setup PortA 
	movwf	TRISA             ; Set port A to all Inputs except RA1 and RA3
	movlw	0x01              ; Setup PORTB
	movwf	TRISB             ; Set port B to all outputs except RB0
	bcf	STATUS,RP0      ; Switch back to bank 0
;
;       Set the power on frequency to the defined value (14.025 MHz).
;
	movlw	ref_osc_3
	movwf	osc_3
	movlw	ref_osc_2
	movwf	osc_2
	movlw	ref_osc_1
	movwf	osc_1
	movlw	ref_osc_0
	movwf	osc_0

	movlw	freq_0
	call	Get_Frequency	; get frequency from EEPROM and into freq_*

	call	calc_dds_word     ; Convert to delta value
	call	send_dds_word     ; Send the power-on frequency to the DDS
	call	send_dds_word     ; Send the power-on frequency to the DDS (to be sure)

	call	SerSetup	  	  ;set up serial comm routines & int.

	call	wait_128ms	; a short delay in case the oscillator is slow
				; getting up to speed
	call	Send_CRLF
	call	Send_CRLF
	movlw	Signon-Dispatch_Table-1		  ; Send Signon Message to the terminal
	call	Send_Prompt
	call	Send_CRLF
	call	I_List			  ; list the menu items

; This is the Command Line Interpreter:

MainLoop
	call	Send_CRLF
	movlw	'>'
	movwf	TXChar
	call	SendAChar
	movlw	' '
	movwf	TXChar
	call	SendAChar

	call	GetAChar	; get char from user
	movf	RXBuff,W	; move the rx char into W

	; SPECIAL CASES: > for jog up, < for jog down: if one of those
	; is entered, change to G or H.

	sublw	'>'
	btfss	STATUS,Z
	goto	MainLoop_CheckSpecial
	movlw	'G'
	movwf	RXBuff
	goto	MainLoop_CheckLowerCase

MainLoop_CheckSpecial
	movf	RXBuff,W
	sublw	'<'
	btfss	STATUS,Z
	goto	MainLoop_CheckLowerCase
	movlw	'H'
	movwf	RXBuff

	; is it potentially lowercase? Add 159 to it. If the addition
	; causes the Carry bit in the Status register to be set, its
	; ASCII value is greater than 96, making it possibly lowercase.

MainLoop_CheckLowerCase
	addlw	0x9F
	btfss	STATUS,C
	goto	CheckUpperCase	; not lowercase--skip converting to upper

	; convert the lowercase value to uppercase:
	movlw	0x20
	subwf	RXBuff,F

CheckUpperCase
	; now check to see if it's less than 'A'. Subtract 'A' and see if
	; the result is negative.

	movlw	'A'
	subwf	RXBuff,W
	btfss	STATUS,C	;Carry bit will be clear if result is negative!
	goto	BadChar 	;Yes, negative. Display menu by default.

	; final check: see if it's greater than 'I', our last command. Subtract
	; 'J',and if the result is negative it's in range.

	movlw	'J'
	subwf	RXBuff,W
	btfsc	STATUS,C	;Carry bit will be clear if result is negative
	goto	BadChar 	;Not negative--out of range. Display menu by default

	; Now load the command into W and subtract 'A' from it so that
	; A=0, B=1, etc. in preparation for table dispatch.

	movlw	'A'
	subwf	RXBuff,W

	call	Dispatch_Table

	goto	MainLoop

	; Unrecognized command entered.  Display menu and go get another command
	; from the user

BadChar
	call	Handle_I	;Display the menu
	goto	MainLoop

; These are the menu handlers:

; -------Handle_A-------------------------------------------
; gets a new frequency from the user and sets the frequency.

Handle_A	;set frequency
	; show the prompt "Freq: "
	movlw	Prompt_A-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get the input from the user:
	call	Get_Digits

	; convert it to binary and store it in freq_*
	call	GetFrequencyFromASCII

	; command the DDS to change frequency:
        call    calc_dds_word
        call    send_dds_word

	; save the frequency in EEPROM:
	call	Save_Frequency

	; send the ok--we're done:
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_B---------------------------------------------
; gets the scan start frequency from the user and stores it.

Handle_B	;set start frequency for scanning
	; show the prompt "Start: "
	movlw	Prompt_B-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get the frequency from the user:
	call	Get_Digits

	; convert it to binary and store it in freq_*
	call	GetFrequencyFromASCII

	; save in EEPROM
	movlw	freq_0
	movwf	FSR
	movlw	_EEPROM_Start
	call	Write_EEPROM

	; send ok--we're done:
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_C---------------------------------------------
; gets the scan end frequency from the user and stores it.

Handle_C	;set end frequency for scanning
	; show prompt "End: "
	movlw	Prompt_C-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get frequency from user:
	call	Get_Digits

	; convert it to binary and store it in freq_*
	call	GetFrequencyFromASCII

	; save in EEPROM
	movlw	freq_0
	movwf	FSR
	movlw	_EEPROM_End
	call	Write_EEPROM

	; send ok--we're done:
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_D---------------------------------------------
; gets the scan step frequency from the user and stores it.

Handle_D	;set step size for scanning
	; show prompt "Step: "
	movlw	Prompt_D-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get frequency from user:
	call	Get_Digits

	; convert to binary and store in freq_0:
	call	GetFrequencyFromASCII

	; save in EEPROM
	movlw	freq_0
	movwf	FSR
	movlw	_EEPROM_Step
	call	Write_EEPROM

	; send ok--we're done:
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_E---------------------------------------------
; starts the scan. NOT IMPLEMENTED

Handle_E	;start scanning

	;show "scan:"
	movlw	Prompt_E-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon
	call	Send_CRLF

	; get the scan start and end frequencies:
	movlw	freq_0		;start freq in freq_*
	call	Get_Scan_Start
	movlw	Add_0
	call	Get_Scan_End

	; set the frequency to the start frequency:

	call	calc_dds_word
	call	send_dds_word

	call	Save_Frequency

	; subtract the end from the start, to see if we
	; need to scan up or down:

	call	Sub_DWord
	btfss	freq_3,7	; bit 7 will be set if result is negative
	goto	Scan_Down

Scan_Up
	; show the frequency:
	call	Show_Frequency
	movlw	0x0D		; follow it with a CR but no LF
	movwf	TXChar
	call	SendAChar

	call	wait_64ms	; wait a little between steps

	; get the current frequency and the step size
	movlw	freq_0
	call	Get_Frequency
	movlw	Add_0
	call	Get_Scan_Step

	; add them:
	call	Add_DWord

	; now get the scan end frequency and subtract it from the result:
	movlw	Add_0
	call	Get_Scan_End
	call	Sub_DWord

	; is the result positive? If so, we've reached the scan end.
	btfss	freq_3,7
	goto	Scan_End_Reached

	call	Jog_Up

	; check for a character from the user. If we get one, stop.

	btfss	SerialReg,0	;bit zero will be set if a character
	goto	Scan_Up
	call	GetAChar	;empty the char buffer of the key the
				;user pressed.
	goto	Scan_Finished	;has been received

Scan_End_Reached

	; set the frequency to the scan end frequency:
	movlw	freq_0
	call	Get_Scan_End
	call	calc_dds_word
	call	send_dds_word
	call	Save_Frequency

	; show the frequency:
	call	Show_Frequency
	movlw	0x0D		; follow it with a CR but no LF
	movwf	TXChar
	call	SendAChar

	goto	Scan_Finished	; start the scan over
	
Scan_Down
	; show the frequency:
	call	Show_Frequency
	movlw	0x0D		; follow it with a CR but no LF
	movwf	TXChar
	call	SendAChar

	call	wait_64ms	; wait a little between steps

	; get the current frequency and the step size
	movlw	freq_0
	call	Get_Frequency
	movlw	Add_0
	call	Get_Scan_Step

	; Subtract the step from the frequency:
	call	Sub_DWord

	; now get the scan end frequency and subtract it from the result:
	movlw	Add_0
	call	Get_Scan_End
	call	Sub_DWord

	; is the result negative? If so, we've reached the scan end.
	btfsc	freq_3,7
	goto	Scan_End_Reached

	call	Jog_Down

	; check for a character from the user. If we get one, stop.

	btfss	SerialReg,0	;bit zero will be set if a character
	goto	Scan_Down
	call	GetAChar	;empty the char buffer of the key the
				;user pressed.
	goto	Scan_Finished	;has been received


Scan_Finished
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_F---------------------------------------------
; shows current frequency and the scan start, end, and step.

Handle_F	;show scan parameters
	; show "Show"
	movlw	Prompt_F-Dispatch_Table-1
	call	Send_Prompt
	call	Send_CRLF

	; show current frequency and scan parameters:
	call	Show_Frequency
	call	Send_CRLF
	call	Show_Scan_Start
	call	Send_CRLF
	call	Show_Scan_End
	call	Send_CRLF
	call	Show_Scan_Step
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_G---------------------------------------------
; increases the frequency by the scan step size.

Handle_G	;jog up by one scan step
	; show "Up"
	movlw	Prompt_G-Dispatch_Table-1
	call	Send_Prompt
	call	Send_CRLF

	call	Jog_Up

	; show the new frequency to the user:
	call	Show_Frequency
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_H---------------------------------------------
; decreases the frequency by the scan step size.

Handle_H	;jog down by one scan step
	; show "Down"
	movlw	Prompt_H-Dispatch_Table-1
	call	Send_Prompt
	call	Send_CRLF

	call	Jog_Down

	; show the new frequency to the user:
	call	Show_Frequency
	call	Send_CRLF
	call	Send_OK
	return

;-----------------------------------------------------------

;------Handle_I---------------------------------------------
; Help: show list of commands and meanings

Handle_I	;help
	; show "Help"
	movlw	Prompt_I-Dispatch_Table-1
	call	Send_Prompt

	; loop through commands. Print letter, colon, space
	; then the prompt that it corresponds to.
I_List
	movlw	'A'
	movwf	Digit_val	;reusing Digit_val for other
				;than original purpose
	movlw	Prompt_A-Dispatch_Table-1
	movwf	count		

Next_Help_Line

	; send "A: " (or B:, etc.)
	call	Send_CRLF
	movf	Digit_val,W
	movwf	TXChar
	call	SendAChar
	call	Send_Colon
	call	Help_Loop

	; get ready for the next letter. If we're done, send CRLF and
	; return. Check for done by comparing Digit_val to 'J' after
	; the incf. If equal (subtraction gives zero), we're done.
	incf	Digit_val,F
	movlw	'J'
	subwf	Digit_val,W
	btfss	STATUS,Z
	goto	Next_Help_Line
	call	Send_CRLF
	call	Send_OK
	return

; Help_Loop goes through the entire table and outputs all the command
; prompts. When it encounters a zero it returns to Next_Help_Line, which
; does a CRLF and outputs the next character command and prompt line.

Help_Loop					
	movf	count,W
	incf	count,F
	call	Dispatch_Table ; get the next character in the prompt
	andlw	0xFF		; is it zero?
	btfsc	STATUS,Z	; check Zero status bit
	return			; is zero--finished so return
	movwf	TXChar
	call	SendAChar
	goto	Help_Loop

;-----------------------------------------------------------

;------Send_CRLF--------------------------------------------
; Send_CRLF sends a carriage return followed by a line feed.

Send_CRLF
	movlw	0x0D
	movwf	TXChar
	call	SendAChar
	movlw	0x0A
	movwf	TXChar
	call	SendAChar
	return

;-----------------------------------------------------------

;------Send_Prompt------------------------------------------
; Send_Prompt sends the prompt for the current command. W must
; be loaded with the correct offset to the right prompt string
; in Dispatch_Table. Send_Prompt gets subsequent characters from
; the table until it gets a zero, at which point it returns.

Send_Prompt
	movwf	count
Send_Prompt_Loop
	movf	count,W
	call	Dispatch_Table ; get the next character in the prompt
	andlw	0xFF		; is it zero?
	btfsc	STATUS,Z	; check Zero status bit
	return			; is zero--finished so return
	movwf	TXChar
	call	SendAChar
	incf	count,F
	goto	Send_Prompt_Loop

;-----------------------------------------------------------

;------Send_Colon------------------------------------------
; sends a colon and a space.

Send_Colon
	; send the colon and space
	movlw	':'
	movwf	TXChar
	call	SendAChar
	movlw	' '
	movwf	TXChar
	call	SendAChar

	return

;-----------------------------------------------------------

;------Send_OK----------------------------------------------
; Send_OK sends  'ok' followed by a CRLF

Send_OK
	movlw	'o'
	movwf	TXChar
	call	SendAChar
	movlw	'k'
	movwf	TXChar
	call	SendAChar
	call	Send_CRLF

	return

;-----------------------------------------------------------

;------Send_Hz----------------------------------------------
; Send_Hz sends a space followed by 'Hz'

Send_Hz
	; send " Hz"
	movlw	' '
	movwf	TXChar
	call	SendAChar
	movlw	'H'
	movwf	TXChar
	call	SendAChar
	movlw	'z'
	movwf	TXChar
	call	SendAChar

	return

;-----------------------------------------------------------

;------Jog_Up-----------------------------------------------
; increases frequency by one step.

Jog_Up
	; get frequency and step size from EEPROM
	movlw	freq_0
	call	Get_Frequency		; stored in freq_*
	movlw	Add_0
	call	Get_Scan_Step	; stored in Add_*

	; add the step to the current frequency
	call	Add_DWord

	; command the DDS to change frequency
	call	calc_dds_word
	call	send_dds_word

	; save the new frequency in EEPROM:
	call	Save_Frequency

	return

;------------------------------------------------------------

;------Jog_Down----------------------------------------------
; increases frequency by one step.

Jog_Down
	; get frequency and step size from EEPROM
	movlw	freq_0
	call	Get_Frequency		; stored in freq_*
	movlw	Add_0
	call	Get_Scan_Step	; stored in Add_*

	; subtract the step from the current frequency
	call	Sub_DWord

	; command the DDS to change frequency
	call	calc_dds_word
	call	send_dds_word

	; save the new frequency in EEPROM:
	call	Save_Frequency

	return

;------------------------------------------------------------

;-----Save_Frequency----------------------------------------
; gets the current frequency from freq_* and stores it in EEPROM

Save_Frequency
	movlw	freq_0
	movwf	FSR
	movlw	_EEPROM_Freq
	call	Write_EEPROM
	
	return

;-----------------------------------------------------------

;------Get_Frequency----------------------------------------
; Gets the current frequency from EEPROM and stores it in
; address given in W.

Get_Frequency
	movwf	FSR
	movlw	_EEPROM_Freq
	call	Read_EEPROM

	return

;-----------------------------------------------------------

;------Get_Scan_Start---------------------------------------
; Gets the scan start frequency from EEPROM and stores it in
; address given in W.

Get_Scan_Start
	movwf	FSR
	movlw	_EEPROM_Start
	call	Read_EEPROM

	return

;-----------------------------------------------------------

;------Get_Scan_Step-----------------------------------
; Gets the frequency step from EEPROM and stores it in
; address given in W.

Get_Scan_Step
	movwf	FSR
	movlw	_EEPROM_Step
	call	Read_EEPROM

	return

;-----------------------------------------------------------

;------Get_Scan_End-----------------------------------------
; Gets the scan end frequency from EEPROM and stores it in
; address given in W.

Get_Scan_End
	movwf	FSR
	movlw	_EEPROM_End
	call	Read_EEPROM

	return

;-----------------------------------------------------------

;------Show_Frequency---------------------------------------
; grabs the frequency from EEPROM, converts it to ASCII,
; and displays it

Show_Frequency

	movlw	Prompt_A-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	movlw	freq_0
	call	Get_Frequency

	; convert to ASCII and display:
	call	Bin_To_ASCII
	call	Dump_ASCII_Buffer
	call	Send_Hz

	return

;-----------------------------------------------------------

;------Show_Scan_Start---------------------------------------
; grabs the scan start frequency from EEPROM, converts it to ASCII,
; and displays it

Show_Scan_Start

	movlw	Prompt_B-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get the frequency from EEPROM:
	movlw	freq_0
	call	Get_Scan_Start

	; convert to ASCII and display:
	call	Bin_To_ASCII
	call	Dump_ASCII_Buffer
	call	Send_Hz

	return

;-----------------------------------------------------------

;------Show_Scan_End---------------------------------------
; grabs the scan end frequency from EEPROM, converts it to ASCII,
; and displays it

Show_Scan_End

	movlw	Prompt_C-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get the frequency from EEPROM:
	movlw	freq_0
	call	Get_Scan_End

	; convert to ASCII and display:
	call	Bin_To_ASCII
	call	Dump_ASCII_Buffer
	call	Send_Hz

	return

;-----------------------------------------------------------

;------Show_Scan_End---------------------------------------
; grabs the scan step frequency from EEPROM, converts it to ASCII,
; and displays it

Show_Scan_Step

	movlw	Prompt_D-Dispatch_Table-1
	call	Send_Prompt
	call	Send_Colon

	; get the frequency from EEPROM:
	movlw	freq_0
	call	Get_Scan_Step

	; convert to ASCII and display:
	call	Bin_To_ASCII
	call	Dump_ASCII_Buffer
	call	Send_Hz

	return

;-----------------------------------------------------------

;------Get_Digits--------------------------------------------
; Get_Digits gets up to eight digits from the serial port.
; it allows backspacing to correct errors.

Get_Digits
	; prefill ASCII_Buf with 0s
	movlw	0x08
	movwf	count
	movlw	ASCII_Buf
	movwf	FSR

Prefill_Buf_Loop
	clrf	INDF
	incf	FSR,F	
	decfsz	count,F
	goto	Prefill_Buf_Loop
	
	; count will keep track of space remaining in buffer
	movlw	0x08
	movwf	count
	movlw	ASCII_Buf
	movwf	FSR

Get_Digits_Loop
	call	GetAChar

	; is it a backspace?
	movlw	0x08
	subwf	RXBuff,W
	btfsc	STATUS,Z
	goto	Backspace

	; is it a CR?
	movlw	0x0D
	subwf	RXBuff,W
	btfsc	STATUS,Z
	goto	CarriageReturn

	; check to see that it's a valid digit.
	movlw	'0'
	subwf	RXBuff,W	; is the gotten character < '0'?
	btfss	STATUS,C	; Carry bit is *clear* if so
	goto	Get_Digits_Loop	; if out of range, skip and
				; get another char
	movlw	'9'+1
	subwf	RXBuff,W	; is the gotten character > '9'?
	btfsc	STATUS,C	; Carry bit is *set* if so
	goto	Get_Digits_Loop	; if out of range, skip and
				; get another char
	
	; it's a valid digit. Check to see if there's room in the buffer:

	movf	count,F		; will set the Z flag if zero
	btfsc	STATUS,Z
	goto	Get_Digits_Loop

	; there's room in the buffer. Store it.
	movf	RXBuff,W
	movwf	INDF
	movwf	TXChar
	call	SendAChar
	incf	FSR,F
	decf	count,F
	goto	Get_Digits_Loop

Backspace
	;got a backspace. Is the buffer empty? If so, ignore

	btfsc	count,3		;check to see if the "eight" bit is on
	goto	Get_Digits_Loop	;if eight bit is on, buffer's empty, so ignore

	incf	count,F
	decf	FSR,F
	clrf	INDF
	movf	RXBuff,W
	movwf	TXChar
	call	SendAChar
	movlw	' '
	movwf	TXChar
	call	SendAChar
	movf	RXBuff,W
	movwf	TXChar
	call	SendAChar

	goto	Get_Digits_Loop

CarriageReturn
	;got a carriage return. Stop getting digits, and right-justify
	;the digits in the ASCII buffer

	;is the buffer full?
	movf	count,F	;will set the Z flag if zero
	btfsc	STATUS,Z
	return

	;not full. Loop to move the characters to the end of the buffer

Loop_Shift_Digits
	
	movlw	ASCII_Buf+6
	movwf	FSR
	movlw	7
	movwf	Digit_val

Inner_Loop_Shift_Digits
	movf	INDF,W
	incf	FSR,F
	movwf	INDF
	decf	FSR,F
	decf	FSR,F
	decfsz	Digit_val,F
	goto	Inner_Loop_Shift_Digits
	movlw	'0'
	movwf	ASCII_Buf

	decfsz	count,F
	goto	Loop_Shift_Digits

	return

;-----------------------------------------------------------

;------Dump_ASCII_Buffer------------------------------------
; sends the contents of ASCII_Buf over the serial port. Used
; to display frequencies to the user.

Dump_ASCII_Buffer

	movlw	8
	movwf	count
	movlw	ASCII_Buf
	movwf	FSR

Loop_Dump_ASCII_Buffer
	movf	INDF,W
	movwf	TXChar
	call	SendAChar
	incf	FSR,F
	decfsz	count,F
	goto	Loop_Dump_ASCII_Buffer

	return

;-----------------------------------------------------------

; --------Read_EEPROM----------------------------------------------
; gets a four byte word starting at the index given in W, and stores
; it starting at INDF.

Read_EEPROM
	bsf	STATUS,RP0
	movwf	EEADR
	bcf	STATUS,RP0
	movlw	4
	movwf	count

Read_EEPROM_Loop
	bsf	STATUS,RP0
	bsf	EECON1,RD
	movf	EEDATA,W
	incf	EEADR,F
	movwf	INDF
	incf	FSR,F
	bcf	STATUS,RP0
	decfsz	count,F
	goto	Read_EEPROM_Loop
	return

;-----------------------------------------------------------

;--------Write_EEPROM------------------------------------------------
; writes a four byte word starting at the index given in W, reading it
; from INDF.

Write_EEPROM
	bsf	STATUS,RP0
	movwf	EEADR
	bcf	STATUS,RP0
	movlw	4
	movwf	count
	bcf	INTCON,GIE

Write_EEPROM_Loop
	bsf	STATUS,RP0
	movf	INDF,W
	movwf	EEDATA
	clrf	EECON1
	bsf	EECON1,WREN
	movlw	0x55
	movwf	EECON2
	movlw	0xAA
	movwf	EECON2
	bsf	EECON1,WR
	btfsc	EECON1,WR	; End of writing test
	goto	$-1		; Loop until end
	bcf	EECON1,EEIF	; Clear EEIF bit telling end of writing sequence
	incf	EEADR,F
	bcf	STATUS,RP0
	bcf	PIR1,EEIF	; ditto in PIR1 register
	incf	FSR,F
	decfsz	count,F
	goto	Write_EEPROM_Loop
	bsf	INTCON,GIE
	return

;-----------------------------------------------------------

; initialize EEPROM to startup values:

	org	0x2100

	; currently-set values for frequency and scanning
	de	0x28, 0x01, 0xD6, 0x00	; current frequency (lo to hi byte)
	de	0x80, 0x9F, 0xD5, 0x00	; lower band edge for scan
	de	0xB0, 0xF6, 0xDA, 0x00	; upper band edge for scan
	de	0x64, 0x00, 0x00, 0x00	; step size for scan & step

	END
