// $id$
/*
  Blink1320.c - Simple test of sdcc for the pic 18F

  John J. McDonough - 16-Feb-07

  Program exercises the basic LCD library functions and flashes a
  few LEDs on the PIC-EL.  It relies on an external function to
  set the configuration fuses, and on a set of small glue
  routines to interface the C calls to the LCDlib functions.
*/

#include <pic18fregs.h>

// Set aside some stack space ... we need this because the default
// compiler behavior is to put the stack where we ain't got no
// memory! We'll stick 32 bytes at the top of bank 0.
#pragma stack 0xe0 32

// Define the pins holding the LEDs
#define LED1 PORTBbits.RB1
#define LED2 PORTBbits.RB0
#define LED3 PORTAbits.RA3

// Macro to flash a LED
#define Blink(LED) { LED = 0; Delay(); LED = 1; Delay(); }
// Macro to flash a LED for a very short time
#define BlinkS(LED) { LED = 0; Delay2(); LED = 1; Delay2(); }
// Define to clarify single byte used as number vs letter
#define byte unsigned 

// The following functions are included in this file
//
// DIsplay a message on the LCD
void Message( char * );

// The following functions are assembled/compiled externally
//
// Initialize the LCD
void LCDinit(void);
// Display a character on the LCD
void LCDletr( char ) wparam;
// Clear the LCD
void LCDclear( void );
// Set the cursor position on the LCD
void LCDaddr( byte ) wparam;
// Set the LCD cursor to the first position
void LCDzero( void );
// Delay for a short time
void Delay2(void);
// Delay for a long time
void Delay(void);
// Delay even longer
void Delay4(void);

// Saw complaints about const char[] but this does
// generate the same code as an inline literal ...
// not very ANSI-compliant, but a whale of a lot
// more efficient.
const char Message1[] = { "Case 0:" };
const char Message2[] = { "  Case 1:" };
const char Message3[] = { "    Case 2:" };
const char Message4[] = { "      Default:" };

void main()
{
  byte nCaseNumber;
  byte i;

  // Turn off AN3, 4 and 5
  ADCON1 = 0x34;
  // Set all pins output for now
  TRISA = 0x00;
  TRISB = 0x00;		// LEDs only outputs

  // Flash before initializing
  for ( i=0; i<5; i++ )
    {
      BlinkS(LED1);
      BlinkS(LED3);
      BlinkS(LED1);
      BlinkS(LED3);
      BlinkS(LED1);
      BlinkS(LED3);
      BlinkS(LED2);
      BlinkS(LED2);
    }
  for ( i=0; i<5; i++ )
    BlinkS(LED2);

  // Initialize LCD display
  LCDinit();

  // Flash after initializing
  for ( i=0; i<5; i++)
    {
      BlinkS(LED1);
      BlinkS(LED2);
      BlinkS(LED3);
      BlinkS(LED1);
      BlinkS(LED2);
      BlinkS(LED3);
      BlinkS(LED1);
      BlinkS(LED2);
      BlinkS(LED3);
    }
  for ( i=0; i<5; i++ )
    BlinkS(LED2);

  // Flash RB1 - LED1
  Message(" LED #001");
  Blink(LED1);
  Blink(LED1);

  // Flash RB0 - LED2
  LCDclear();
  Message("LED two");
  Blink(LED2);
  Blink(LED2);

  // Flash RA3 - LED3
  LCDclear();
  Message(" LED Three ");
  Blink(LED3);
  Blink(LED3);

  LCDclear();

  // Now loop through pattern
  while ( 1 )  // And do this for quite a long time
    {
      for ( nCaseNumber=0; nCaseNumber<4; nCaseNumber++ )
        {
	  switch ( nCaseNumber )
	  {
	    case 0:
              Message( Message1 );  // Display the message
	      Blink( LED1 );        // Blink the LED
	      Blink( LED1 );
	      break;
	    case 1:
	      Message( Message2 );
	      Blink( LED2 );
	      Blink( LED2 );
	      break;
	    case 2:
	      Message( Message3 );
	      Blink( LED3 );
	      Blink( LED3 );
	      break;
	    default:
	      Message( Message4 );
	      Delay4();
	  }
	  LCDclear();
	}
      LED1 = LED2 = LED3 = 0;    // All LEDs on
      Delay();                   // Wait a bit
      LED1 = LED2 = LED3 = 1;    // All LEDs off
      Delay();
      for ( i=0; i<10; i++ )
	{
	  BlinkS(LED1);
	  BlinkS(LED3);
	}
      for ( i=0; i<5; i++ )
	BlinkS(LED2);
      LED1 = LED2 = LED3 = 1;    // All LEDs off
    }
}

void Message( char *p )
{
  byte nCharCount;

  LCDzero();
  nCharCount = 0;
  while ( *p )
    {
      LCDletr( *p );
      p++;
      nCharCount++;
      //if ( nCharCount == 8 ) // 16 char = 2x8 LCD
	  //LCDaddr(0x40);
    }

}

