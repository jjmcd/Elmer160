/*!  \file tsdcc88.c

    \brief Little program to exercise SDCC

    Program flashes the 3 PIC-EL LEDs and an LED plugged into the transmitter
    port in an erratic fashion.  The PIC-EL LEDs are red and get a different
    treatment than the xmit LED.  The LED plugged into the xmit port is white.

    This version uses the PIC16F88 with its internal oscillator set to 31.25 kHz.
    The red LEDs, instead of being more or less randomly toggled, are fed from
    an array of allowable patterns, each of which ensures at least one LED
    is on at all times.

    Ultimately, it is expected that the application will be ported to a board
    with transistors driving the LEDs, capacitors to soften the on-off flashing,
    and run form 3 vots.  As a result, the sense of the LEDs is reversed compared
    to the PIC-EL.

    \author jjmcd - 2009-11-26
*/

/* Include processor file */
#include <pic16f88.h>

/* ----------------------------------------------------------------------- */
/* Configuration bits */
typedef unsigned int word;
//! Configuration word 1
word at 0x2007 CONFIG1 =
	_WDT_OFF & _PWRTE_OFF & _INTRC_CLKOUT & _MCLR_ON &  _BODEN_OFF & 
	_LVP_OFF & _CPD_OFF & _WRT_PROTECT_OFF & _DEBUG_OFF & _CCP1_RB0 & 
	_CP_OFF;
//! Configuration word 2
word at 0x2008 CONFIG2 = 
	_FCMEN_ON & _IESO_ON;

/* Global variables */
//! Select pattern
/*! Target is calculated more or less randomly by the
    mainline.  The interrupt service routine uses Target
    as an index into Patterns[]. */
static int Target;
//! Array of LED patterns
/*! The array is long enough that randomly selecting an index
    will lead to an apparently random pattern.  These patterns
    never allow all 3 LEDs to be off  The only relevant bits
    are 1, 2, and 3, so 0x0e is the not allowed pattern.  The
    allowed patterns are 0x00, 0x02, 0x04, 0x06, 0x08,0x0a
    and 0x0c. */
static const unsigned char Patterns[32] = {
    0x06, 0x08, 0x00, 0x08, 0x0a, 0x02, 0x02, 0x04,
    0x0a, 0x06, 0x02, 0x08, 0x06, 0x0c, 0x00, 0x02,
    0x04, 0x04, 0x08, 0x04, 0x02, 0x06, 0x04, 0x00,
    0x02, 0x00, 0x06, 0x08, 0x00, 0x00, 0x06, 0x00
    };

//! Interrupt Service Routine
/*! The interrupt service routine first checks that it was the timer interrupt
    that brought us here.  If so, all the LEDs are turned off and the timer
    interrupt flag cleared.  There is then a delay to give the LEDs some off
    time (to reduce current consumption).

    Then the global Target is used to select a pattern from the
    LED pattern array.  This way a pattern is selected which
    ensures that at least one LED is always on.
*/
void isr() interrupt 0	/* interrupt service routine */
{
     int i;
	
	if ( TMR0IF )		/* Was it the timer that brought us here? */
	{
		TMR0IF = 0;	/* Turn off the timer interrupt flag */

		// Turn off the LEDs
		PORTB = (PORTB & 0xf1) | 0x0e;
		/* Now hang around a while with the LEDs off to reduce the
		   average current consumption.
		   sdcc is (thankfully) not smart enough to optimize this
		   out of existence.  This results in 5 + 9 * loop count
		   instructions of wasted time with the LEDs off. */
		for ( i=0; i<25; i++ ) ;
		
		/* Select the 3 bits connected to the LEDs
		   and change them based on the value in Patterns[] */
		PORTB = (PORTB & 0xf1) | Patterns[Target&0x1f];
	}
}

//! Initialization
/*! Initialize() sets the internal oscillator clock, sets up the
    timer and ports.

    The oscillator is set to 31.25 kHz.  The timer will use the internal
    oscillator with a 1:4 prescaler.  PORTB is set to all outputs.
*/
void Initialize( void )
{
	/* Set the internal clock to 31.25 kHz */
	OSCCON = 0x0e;
	/* Mask all interrupts */
	INTCON = 0;
	/* Enable timer, use rising edge, prescaler to timer, 1:4 */
	OPTION_REG = 0xc1;
	/* PORTB all outputs */
	TRISB = 0;
	/* Just to put bank back to 0 to make asm easier to read */
	PORTB = 0;

}

//! Mainline
/*! main() calls Initialize() and then enables the timer.  main() then
    loops, establishing a somewhat random value for the global variable
    Target which will be used by the interrupt service routine to select
    the LED pattern.
*/
void main() 
{
    int a,b,c;

	Initialize();

	/* Initialize brightness counters */
	a = b = c = 0;
	Target = 0;

	/* Enable timer interrupt and global interrupt */
	TMR0IE = 1;
	GIE=1;

	while ( 1 == 1 )
	{
		/* Somewhat leftover, really a little redundant
		   since all we are doing is setting an index.
		   Note that this will get executed many times, 
		   but the result will only be used whenever a
		   timer interrupt occurs. */
		a += 38;
		b += 83;
		c += 134;
		Target = (a + b + c) & 0xff;

	}
}
