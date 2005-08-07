			title		'Less17 - Test program for LCD routines'
			subtitle	'Part of the Lesson 17 regression test'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;	Less17 - Test program for Lesson 17 on LCDs
;
;	Program to exercise routines in the LCD library.  Program will
;	first display a message on the LCD in the normal fashion.  This
;	tests LCD initialization and proper incrementing of display 
;	location of successive characters.  The program will delay, then
;	clear the display.  Next, a message will be displayed in an
;	unusual order, testing the ability to address the character
;	locations.  After another delay, the display will then be
;	cleared and a message scrolled across the display.  After yet
;	another delay, the display will be cleared and the process
;	repeated.
;
;	All the tests are performed on the first 8 characters of the
;	display.  On older PIC-ELs this is the entire display.  However
;	some PIC-ELs have a 16 character display.  This program does not
;	address the right 8 characters of that display.
;
;**
;	JJMcD - 14-May-05
;	$Revision: 1.7 $ $State: Stab $ $Date: 2005-08-07 13:28:28-04 $

			include		p16f84a.inc
			__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

			extern		Msg1,Msg2,Msg3
			extern		LCDinit,LCDclear
			extern		Del1s

STARTUP		code
			goto		Start

			code
Start
			call		LCDinit			; Initialize the LCD

Loop
			call		Msg1			; Display the 'Pig' message
			call		Del1s			; Wait a second to see it
			call		LCDclear		; Clear the LCD

			call		Msg2			; Display the 'Elecraft' message
			call		Del1s			; Wait a second to see it
			call		LCDclear		; Clear the LCD

			call		Msg3			; Display the 'Watson' message
			call		Del1s			; Wait a second to see it
			call		LCDclear		; Clear the LCD

			goto		Loop			; Do it again

			end
