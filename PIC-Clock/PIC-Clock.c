/* PIC-Clock.c
 *
 * Display the time on the PIC-EL.  No provision at this time
 * for actually setting the clock, just a simple de,o.
 *
 * John J. McDonough, WB8RCR
 * 4-March-2010
 *
 */

#include <pic16f88.h>

// ****** SET THE FOLLOWING VALUE TO ADJUST FOR YOUR CRYSTAL ******
#define CLOCKSET 1954

// External functions
void LCDinit( void );   // Initialize the LCD
void LCDchar( char );   // Send a character to the LCD
void LCDclear( void );  // Erase the LCD
void Del1s( void );     // Hang around for a second

// Global variables
unsigned char hours;    // Hours into the day, 0..23
unsigned char minutes;  // Minutes into the hour 0..59
unsigned char seconds;  // Seconds into the minute 0..59
unsigned char dirty;    // Flag set by ISR whenever timer expires
unsigned int fracsecs;  // Partial seconds

/* Interrupt Service Routine
 *
 * Whenever the timer expires, the value fracsecs is incremented.
 * When it has been incremented enough times that a second has
 * elapsed (based on a 4 MHz crystal), the value is zeroed and
 * the dirty flag is set.
 */
void isr() interrupt 0
{
  int i;
	
  if ( TMR0IF )		/* Was it the timer that brought us here? */
    {
      TMR0IF = 0;	/* Turn off the timer interrupt flag */

      fracsecs++;
      if ( fracsecs > CLOCKSET )
	{
	  fracsecs = 0;

	  /* Set the dirty flag */
	  dirty = 1;
	}
    }
}

// showDigits - send a value between 0 and 99 to the LCD
void showDigits( unsigned char n )
{
    unsigned char d1, d2;
    d1 = n / 10 + '0';
    LCDchar( d1 );
    d2 = n % 10 + '0';
    LCDchar( d2 );
}

// showTime - Display hours, minutes, seconds on the LCD
void showTime( void )
{
  showDigits( hours );
  LCDchar(':');
  showDigits( minutes );
  LCDchar(':');
  showDigits( seconds );
}

// Mainline for the clock
void main( void )
{
  // Initilize to a time that will allow quick checking
  hours = 23;
  minutes = 58;
  seconds = 50;

  /* Mask all interrupts */
  INTCON = 0;
  /* Enable timer, use rising edge, prescaler to timer, 1:2 */
  OPTION_REG = 0xc0;

  // This initialization will result in a couple seconds of
  // a clear display before the clock actually starts.
  // Note that LCDinit sets PORTB appropriately
  LCDinit();  // Initialize the LCD
  Del1s();    // Wait a bit
  LCDclear(); // Clear the display

  // Now enable interrupts so the timer can start
  dirty=0;
  TMR0IE = 1;
  GIE = 1;

  while ( 1 )
    {
      if ( dirty )  // Whenever the time has changed
	{
	  dirty = 0;  // Reset the flag
	  seconds++;  // New seconds
	  if ( seconds > 59 ) // Minute?
	    {
	      seconds = 0;
	      minutes++;
	      if ( minutes > 59 ) // Hour?
		{
		  minutes = 0;
		  hours++;
		  if ( hours > 23 )   // Day?
		    {
		      hours = 0;
		    }
		}
	    }
	  LCDclear();      // Clear the display
	  showTime();      // and show the time
	}
    }
}

