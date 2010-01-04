/*!  \file Candle04.c

    \brief Simulate a candle using three LEDs

    Program flashes the 3 PIC-EL LEDs in an erratic fashion.

    This version uses the PIC16F88 with its internal oscillator set to 31.25 kHz.
    The LEDs, instead of being more or less randomly toggled, are fed from an
    array of allowable patterns, each of which ensures at least one LED is on
    at all times.
    \addindex PIC-EL

    Ultimately, it is expected that the application will be ported to a board
    with transistors driving the LEDs, capacitors to soften the on-off flashing,
    and run from 3 volts.
    \addindex LED

    \image latex Candle-Schematic.eps "Target Board Schematic"

    The presumption is that the application is powered by a battery, so current
    consumption is an issue.  The low clock speed ensures that the current 
    consumed by the PIC is minimal.
    \addindex Battery
    \addindex Oscillator

    \date 2009-11-26 - Initial version
    \date 2009-12-27 - Latest revision
    \author John J. McDonough, WB8RCR
*/

/* Include processor file */
#include <pic16f88.h>

/* ----------------------------------------------------------------------- */
/* Configuration bits */
//! Define an unsigned 16-bit type to be used for configuration bits
typedef unsigned int word;
//! Configuration word 1
/*! Watchdog timer off, Power-up timer on, internal RC timer with clock
    out of clock pins, <tt>MCLR</tt> not used as an IO, brown out detection
    off, low voltage programming off, EEPROM memory protection off, debug
    off, <tt>CCP1</tt> on <tt>RB0</tt> pin, code protection off.
    \addindex Oscillator
*/
word at 0x2007 CONFIG1 =
	_WDT_OFF & _PWRTE_OFF & _INTRC_CLKOUT & _MCLR_ON &  _BODEN_OFF & 
	_LVP_OFF & _CPD_OFF & _WRT_PROTECT_OFF & _DEBUG_OFF & _CCP1_RB0 & 
	_CP_OFF;
//! Configuration word 2
/*! Internal/external switchover mode enabled, fail-safe clock monitor
    enabled. */
word at 0x2008 CONFIG2 = 
	_FCMEN_ON & _IESO_ON;

/* Global variables */
//! Select pattern
/*! <tt>Target</tt> is calculated more or less randomly by the
    mainline.  The interrupt service routine uses Target
    as an index into <tt>Patterns[]</tt>. */
static int Target;
//! Array of LED patterns
/*! The array is long enough that randomly selecting an index
    will lead to an apparently random pattern.  These patterns
    never allow all 3 LEDs to be off.  The only relevant bits
    are 1, 2, and 3, and a true bit represents an LED off, so
    0x0e is the not allowed pattern.  The allowed patterns are
    0x00, 0x02, 0x04, 0x06, 0x08, 0x0a and 0x0c. 
    \addindex LED
*/
static const unsigned char Patterns[32] = {
    0x06, 0x08, 0x00, 0x08, 0x0a, 0x02, 0x02, 0x04,
    0x0a, 0x06, 0x02, 0x08, 0x06, 0x0c, 0x00, 0x02,
    0x04, 0x04, 0x08, 0x04, 0x02, 0x06, 0x04, 0x00,
    0x02, 0x00, 0x06, 0x08, 0x00, 0x00, 0x06, 0x00
    };

//! Interrupt Service Routine
/*! The interrupt service routine first checks that it was the timer interrupt
    that brought us here.  If not, nothing is done.

    If it was the timer interrupt, the global <tt>Target</tt> is used to select
    a pattern from the <tt>Patterns</tt> array.  This way a pattern is selected which
    ensures that at least one LED is always on.

    An attempt was made to turn off the LEDs for a short time each interrupt to
    reduce the duty cycle, and hence the current consumption.  This actually
    increased the power consumption, presumably because of the capacitors wanting
    to stay charged.
    \addindex Interrupt
    \addindex Timer
    \addindex Target
    \addindex Patterns
*/
void isr() interrupt 0
{
     int i;
	
	if ( TMR0IF )		/* Was it the timer that brought us here? */
	{
		TMR0IF = 0;	/* Turn off the timer interrupt flag */

		/* Select the 3 bits connected to the LEDs
		   and change them based on the value in Patterns[] */
		PORTB = (PORTB & 0xf1) | Patterns[Target&0x1f];

		/* Reload the timer register */
		TMR0 = 128;
	}
}

//! Initialization
/*! <tt>Initialize()</tt> sets the internal oscillator clock, sets up the
    timer and ports.

    The oscillator is set to 31.25 kHz.  The timer will use the internal
    oscillator with a 1:4 prescaler.  <tt>PORTB</tt> is set to all outputs.
    \addindex Timer
    \addindex Oscillator
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

//! Mainline for the candle simulator
/*! <tt>main()</tt> calls <tt>Initialize()</tt> and then enables the timer.
    <tt>main()</tt> then loops, establishing a somewhat random value for
    the global variable <tt>Target</tt> which will be used by the interrupt
    service routine to select the LED pattern.
    \addindex Interrupt
    \addindex Target
    \addindex Initialize
*/
void main() 
{
    int a,b,c;

	/* Processor and port initializations */
	Initialize();

	/* Initialize pattern counters */
	a = b = c = 0;
	Target = 0;

	/* Enable timer interrupt and global interrupt */
	TMR0IE = 1;
	GIE=1;

	while ( 1 == 1 )
	{
		/* Calculate the index into the Pattern[] array.  Really a
                   little redundant since all we are doing is setting an
                   index. Note that this will get executed many times, but
                   the result will only be used whenever a timer interrupt
                   occurs. */
		a += 38;
		b += 83;
		c += 134;
		Target = (a + b + c) & 0xff;
	}
}
