/* ----------------------------------------------------------------------- */
/*  tsdcc.c

    Little program to exercise SDCC
    
    Program flashes the 3 PIC-EL LEDs and an LED plugged into the transmitter
    port in an erratic fashion.  The PIC-EL LEDs are treated as one, and
    happen to be red.  The LED plugged into the xmit port is white.
    
    jjmcd - 2009-11-26
*/

#include <pic16f84a.h>

/* ----------------------------------------------------------------------- */
/* Configuration bits */
typedef unsigned int word;
word at 0x2007 CONFIG = _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF;

/* Global variables */
static int Bright;	/* Counter for ISR */
static int Target;	/* External to ISR to determine behavior */
static const char Patterns[8] = { 0x6, 0x2, 0x0, 0x4, 0xc, 0x0, 0xa, 0x8 };

void isr() interrupt 0 {                      /* interrupt service routine */
	
	if ( T0IF )		/* Was it the timer that brought us here? */
	{
		T0IF = 0;	/* Turn off the timer interrupt flag */
		
		/* Increment Bright and limit it to 8 bits */
		Bright++;
		Bright &= 0xff;
		
		if ( Bright > Target )
			/* White LED on PORTB,7 */
			PORTB^=0x80;
		else
			/* Red LEDs on PORTB,1-3 */
			/* PORTB^=Patterns[Target&0x7]; */
			PORTB = (PORTB & 0xf1) | Patterns[Target&0x7];
	}
}

void main() {
    int i, j;
	int a,b,c;

	/* Mask all interrupts */
	INTCON = 0;
	/* Enable timer, use rising edge, prescaler to timer, 1:4 */
	OPTION_REG = 0xc2;
	/* PORTB all outputs */
	TRISB = 0;
	/* Just to put bank back to 0 to make asm easier to read */
	PORTB = 0;
	/* Avoid message about used before assignment */
	j = 0;
	/* Initialize brightness counters */
	a = b = c = 0;
	/* Enable timer interrupt and global interrupt */
	T0IE = 1;
	GIE=1;
	Target = 0;
	while ( 1 == 1 )
	{
		/* Simply to waste time */
		for ( i=0; i<100; i++ )
			j++;
		
		/* Making Target the sum of three variables that increase, but are
		   limited to values that are not related should make the brightness
		   appear to change erratically.  This takes over 400K cycles to
		   repeat, so it should appear fairly random.
		*/
		a++;
		if ( a>38 )
			a=0;
		b++;
		if ( b>83 )
			b = 0;
		c++;
		if ( c > 134 )
			c = 0;
		Target = a + b + c;
	}
}
