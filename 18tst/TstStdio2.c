// $Id: TstStdio2.c,v 1.10 2007-03-25 16:59:54-04 jjmcd Exp jjmcd $
/*
  TstStdio2.c - Simple test of sdcc for the pic 18F

  John J. McDonough - 16-Feb-07

  Program exercises the basic LCD library functions and flashes a
  few LEDs on the PIC-EL.  It relies on an external function to
  set the configuration fuses, and on a set of small glue
  routines to interface the C calls to the LCDlib functions.
*/

#include <pic18fregs.h>
#include <stdio.h>

// Set aside some stack space ... we need this because the default
// compiler behavior is to put the stack where we ain't got no
// memory! We'll stick 48 bytes in bank 0.  Interestingly, if
// we put this in the top 128 of bank 0 printf doesn't work, but
// here it does!
#pragma stack 0x50 48

// Apparently this gets linked in to accomodate parts with
// additional peripherals but is lacking in the 1320
//extern __sfr __at (0xfc9) SSPBUF;
unsigned int SSPBUF;

// Define the pins holding the LEDs
#define LED1 PORTBbits.RB1
#define LED2 PORTBbits.RB0
#define LED3 PORTAbits.RA3

// Macro to flash a LED
#define Blink(LED) { LED = 0; Delay(); LED = 1; Delay(); }
// Define to clarify single byte used as number vs letter
#define byte unsigned char

// The following functions are assembled/compiled externally
//
// Initialize the LCD
void LCDinit(void);
// Display a character on the LCD
void LCDletr( char );
// Clear the LCD
void LCDclear( void );
// Set the cursor position on the LCD
void LCDaddr( byte );
// Set the LCD cursor to the first position
void LCDzero( void );
// Delay for a long time
void Delay(void);
// Delay even longer
void Delay4(void);

// Use printf_tiny to save about a K
#define printf printf_tiny

// Saw complaints about const char[] but this does
// generate the same code as an inline literal ...
// not very ANSI-compliant, but a whale of a lot
// more efficient.
const char Message1[] = { "Case 0:" };
const char Message2[] = { "  Case %d:" };
const char Message3[] = { "    Case %d:" };
const char Message4[] = { "      Default:" };

const char Ms1[] = { "The rain in" };
const char Ms2[] = { "Spain stays" };
const char Ms3[] = { "mainly in the" };
const char Ms4[] = { "plain." };

const char pMs[5][17] = { "In Principio",
			  "erat Verbum et",
			  "Verbum erat apud",
			  "Deum et Deum",
			  "erat Verbum." 
                        };


void main()
{
  byte nCaseNumber;
  int nLEDnumber;

  // Turn off AN3, 4 and 5
  ADCON1 = 0x34;
  // Set all pins output for now
  TRISA = 0x00;
  TRISB = 0x00;		// LEDs only outputs

  // Initialize LCD display
  LCDinit();

  // Use user code rather than serial port
  stdout = STREAM_USER;

  // Signon Banner
  printf("\014TstStdio2.c  ");
  Delay4();
  printf("\014$Revision: 0.10 $");
  Delay4();
  printf("\014%s  ",__DATE__);
  Delay4();

  // Flash RB1 - LED1
  nLEDnumber = 1;
  printf("\014");
  printf("LED #%d",nLEDnumber);
  LCDaddr(20);
  Blink(LED1);
  Blink(LED1);

  // Flash RB0 - LED2
  nLEDnumber = 2;
  printf("\014LED %d",nLEDnumber);
  LCDaddr(20);
  Blink(LED2);
  Blink(LED2);

  // Flash RA3 - LED3
  printf("\014LED 0x%x_012345678",3);
  LCDaddr(20);
  Blink(LED3);
  Blink(LED3);

  printf("\014");

  // Now loop through pattern
  while ( 1 )  // And do this for quite a long time
    {
      for ( nCaseNumber=0; nCaseNumber<5; nCaseNumber++ )
	{
	  printf("\014");
	  if ( nCaseNumber )
	    {
	      printf("%s",pMs[nCaseNumber-1]);
	    }
	  LCDaddr(0x40);
	  printf("%s",pMs[nCaseNumber]);
	  LCDaddr(20);
	  Delay4();
	  Delay4();
	  //Delay();
	}
      printf("\014");
      for ( nCaseNumber=0; nCaseNumber<4; nCaseNumber++ )
        {
	  switch ( nCaseNumber )
	  {
	    case 0:
              printf( Message1 );  // Display the message
	      Blink( LED1 );        // Blink the LED
	      break;
	    case 1:
	      printf( Message2, nCaseNumber );
	      Blink( LED2 );
	      break;
	    case 2:
	      printf( Message3, nCaseNumber );
	      Blink(LED3);
	      break;
	    default:
	      printf( Message4 );
	      Delay();
	  }
	  printf("\014");
	}
      for ( nCaseNumber=0; nCaseNumber<4; nCaseNumber++ )
        {
	  switch ( nCaseNumber )
	  {
	    case 0:
              printf( Message1 );  // Display the message
	      LCDaddr(66);
	      Blink( LED1 );        // Blink the LED
	      LCDaddr(70);
	      Blink( LED2 );
	      LCDaddr(74);
	      Blink( LED3 );
	      break;
	    case 1:
	      printf( Message2, nCaseNumber );
	      LCDaddr(70);
	      Blink( LED2 );
	      LCDaddr(74);
	      Blink( LED3 );
	      LCDaddr(66);
	      Blink( LED1 );
	      break;
	    case 2:
	      printf( Message3, nCaseNumber );
	      LCDaddr(74);
	      Blink( LED3 );
	      LCDaddr(66);
	      Blink( LED1 );
	      LCDaddr(70);
	      Blink( LED2 );
	      break;
	    default:
	      printf( Message4 );
	      LCDaddr(20);
	      Delay();
	  }
	  printf("\014");
	}
      for ( nCaseNumber=0; nCaseNumber<4; nCaseNumber++ )
        {
	  switch ( nCaseNumber )
	  {
	    case 0:
              printf( Ms1 );  // Display the message
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    case 1:
	      printf( Ms2 );
	      Blink( LED1 );
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    case 2:
	      printf( Ms3 );
	      Blink( LED1 );
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    default:
	      printf( Ms4 );
	      Delay();
	      Delay();
	      Delay();
	  }
	  printf("\014");
	}
      for ( nCaseNumber=0; nCaseNumber<4; nCaseNumber++ )
        {
	  switch ( nCaseNumber )
	  {
	    case 0:
              printf( Message1 );  // Display the message
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    case 1:
	      printf( Message2, nCaseNumber );
	      Blink( LED1 );
	      Blink( LED2 );
	      Blink( LED3 );
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    case 2:
	      printf( Message3, nCaseNumber );
	      Blink( LED1 );
	      Blink( LED2 );
	      Blink( LED3 );
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    default:
	      printf( Message4 );
	      Delay();
	  }
	  printf("\014");
	}
      for ( nCaseNumber=0; nCaseNumber<4; nCaseNumber++ )
        {
	  switch ( nCaseNumber )
	  {
	    case 0:
              printf( Ms1 );  // Display the message
	      LCDaddr(0x50);
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    case 1:
	      printf( Ms1 );
	      LCDaddr(40);
	      printf( Ms2 );
	      LCDaddr(0x50);
	      Blink( LED1 );
	      Blink( LED2 );
	      Blink( LED3 );
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    case 2:
	      printf( Ms2 );
	      LCDaddr( 40 );
	      printf( Ms3 );
	      LCDaddr(0x50);
	      Blink( LED1 );
	      Blink( LED2 );
	      Blink( LED3 );
	      Blink( LED1 );        // Blink the LED
	      Blink( LED2 );
	      Blink( LED3 );
	      break;
	    default:
	      printf( Ms3 );
	      LCDaddr( 40 );
	      printf( Ms4 );
	      LCDaddr(0x50);
	      Delay4();
	      Delay4();
	      //Delay();
	  }
	  printf("\014");
	}
      LED1 = LED2 = LED3 = 0;    // All LEDs on
      Delay();                   // Wait a bit
      LED1 = LED2 = LED3 = 1;    // All LEDs off
    }
}

