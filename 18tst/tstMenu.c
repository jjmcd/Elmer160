// $Id: tstMenu.c,v 1.2 2007-03-25 10:19:33-04 jjmcd Exp jjmcd $
/*
  tstMenu.c - Test a simple menu

  Actually, this isn't such a simple menu. The idea here is
  to work the logic for a nested menu, where the user presses
  PB1 or PB3 for up and down, and PB2 for select.  The model is
  a radio with a DDS and a keyer.  The keyer can control speed
  and weight, and the DDS can change step size.  Also, power level
  may be adjusted

                       |- 1 ---- Processing
                       |
                       |- 10 --- Processing
             |- Step --|
             |         |- 100 -- Processing
             |         |
             |         |- Back (to Step)
             |
             |                    |- Up --- Processing
             |                    |
             |         |- Speed --|- Down - Processing
             |         |          |
             |         |          |- Back (to Speed)
             |         |
             |         |          |- Up --- Processing
     default-|         |          |
             |- Keyer -|- Weight -|- Down - Processing
             |         |          |
             |         |          |- Back (to Weight)
             |         |
             |         |- Back (to Keyer)
             |
             |         |- Up --- Processing
             |         |
             |- Power -|- Down - Processing
             |         |
             |         |- Back (to Power)
             |
             |- Back (to default)

  Although this test program will run on a PIC-EL, the actual keyer
  cannot run on PIC-EL hardware since the paddle shares pins with
  PB2 and PB2.  Although the encoder is tested and the frequency
  displayed, no commands are sent to the DDS.

  John J. McDonough - 17-Feb-07

*/

#include <pic18fregs.h>
#include <string.h>
#include <stdlib.h>

// Set aside some stack space ... we need this because the default
// compiler behavior is to put the stack where we ain't got no
// memory! We'll stick 32 bytes at the top of bank 0.
#pragma stack 0xe0 32

// Define the pins holding the LEDs
#define LED1 PORTBbits.RB1
#define LED2 PORTBbits.RB0
#define LED3 PORTAbits.RA3
// Define the pins holding the pushbuttons
#define PB1 PORTAbits.RA4
#define PB2 PORTAbits.RA1
#define PB3 PORTAbits.RA0
// Define the pins holding the encoder
#define ENC0 PORTBbits.RB3
#define ENC1 PORTBbits.RB2

// Macro to flash a LED for 2ms
#define Blink(LED) { LED = 0; Del2ms(); LED = 1; Del2ms(); }

// Define to clarify single byte used as number vs letter
#define byte unsigned char

// The following functions are included in this file
//
// Display a message on the LCD
void Message( char * );
// Return the number of a button just released
byte ButtonActive( void );
// Display the frequency
void ShowFreq( void );
// Display the keyer speed
void ShowSpeed( void );
// Display the keyer weight
void ShowWeight( void );
// Display the power level
void ShowPower( void );
// Increase the frequency
void FreqUp( void );
// Decrease the frequency
void FreqDn( void );
// Increase the keyer speed
void SpeedUp( void );
// Decrease the keyer speed
void SpeedDown( void );
// Increase the keyer weighting
void WeightUp( void );
// Decrease the keyer weighting
void WeightDown( void );
// Increase the power
void PowerUp( void );
// Decrease the power
void PowerDown( void );
// Test the encoder
byte ReadEncoder( void );

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
//Delay for 2 milliseconds
void Del2ms( void );
// Delay for a long time
void Delay(void);
// Delay even longer
void Delay4(void);

// List of messages
const char menuText[13][9] = { 
  "        ",
  "  Step",
  " Keyer",
  " Power",
  "  Back",
  "   1",
  "  10",
  "  100",
  " Speed",
  " Weight",
  "   Up",
  "  Down",
  "Procssng"
};

// Message to display for each state:
//  -- Index = state number
//  -- Contents = message number
const byte stateMsg[30] = {
  0,1,2,3,4,5,6,7,4,8,9,4,10,11,4,10,11,4,10,11,4,12,12,12,12,12,12,12,12,12
};
// Next state when button pressed
//  -- Index = current state
//  -- Contents = next state
const byte nextPB1[30] = {
  1,4,1,2,3,8,5,6,7,11,
  9,10,14,12,13,17,15,16,20,18,
  19,21,22,23,24,25,26,27,28,29
};
const byte nextPB2[30] = {
  1,6,9,13,0,21,22,23,1,15,
  18,2,28,29,3,24,25,9,26,27,
  10,21,22,23,24,25,26,27,28,29
};
const byte nextPB3[30] = {
  1,2,3,4,1,6,7,8,5,10,
  11,9,13,14,12,16,17,15,19,20,
  18,21,22,23,24,25,26,27,28,29
};
// Next state when timer expires
const byte nextTimer[30] = {
  0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,
  0,5,6,7,15,16,18,19,12,13
};

// Force use of access RAM for overflow udata's
// tm_udata is in memory that SDCC doesn't seem
// to want to use
#pragma udata tm_udata nEncDirty
#pragma udata tm_udata nEnc
#pragma udata tm_udata nFreq
#pragma udata tm_udata nKeyWeight
#pragma udata tm_udata nSpeed
#pragma udata tm_udata nPower
#pragma udata tm_udata nStep
#pragma udata tm_udata nButtonLast
#pragma udata tm_udata szMsg

// Remember frequency has changed
static byte nEncDirty;
// Store encoder state
static byte nEnc[2];
// DDS frequency
static long nFreq;
// Keyer weighting * 10
static byte nKeyWeight;
// Current speed, WPM
static byte nSpeed;
// Current power level, tenths of a watt
static byte nPower;
// Step size
static byte nStep;
// Last state of each button, 0 = pressed
static byte nButtonLast[4];
// Used for display routines
static char szMsg[16];

// ---------------------------------------------------------------
// M a i n l i n e
// ---------------------------------------------------------------

void main()
{
  byte nState;                 // Current menu state
  byte nDirty;                 // Note if display needs refreshed

  // nButtonLast initilization doesn't seem to work
  nButtonLast[1] = nButtonLast[2] = nButtonLast[3] = 1;
  nPower = 25;                 // Start power at 2.5 watts
  nSpeed = 30;                 // Start speed at 30 WPM
  nKeyWeight = 33;             // Start weight at 3.3
  nStep = 10;                  // Start step at 10
  nFreq = 14060000;            // Start freq @ QRP calling freq

  // Turn off AN0, 1, 3, 4 and 5
  ADCON1 = 0x3b;
  // Set all pins output except pushbuttons and encoder
  TRISA = 0x13;
  TRISB = 0x0c;

  // Initialize LCD display
  LCDinit();

  nState = 0;
  nDirty = 1;                  // Show frequency first pass

  while ( 1 )                  // And do this for quite a long time
    {

      switch ( ButtonActive() )
        {
        case 1:
          nState = nextPB1[nState];
          nDirty = 1;
          break;
        case 2:
          nState = nextPB2[nState];
          nDirty = 1;
          break;
        case 3:
          nState = nextPB3[nState];
          nDirty = 1;
          break;
        default:
          break;
        }
      // If we made a change, refesh the display
      if ( !nDirty )
        if ( !nState )
          nDirty = ReadEncoder();
      if ( nDirty )
        {
          LCDclear();
          if ( nState )
            Message( menuText[stateMsg[nState]] );
          else
            ShowFreq();
          nDirty = 0;
          // "Processing" states lock the system for a few
          // seconds, then move on to a new state
          if ( nState > 20 )
            {
              switch ( nState )
                {
                case 21:
                  nStep = 1;
                  break;
                case 22:
                  nStep = 10;
                  break;
                case 23:
                  nStep = 100;
                  break;
                case 24:
                  SpeedUp();
                  break;
                case 25:
                  SpeedDown();
                  break;
                case 26:
                  WeightUp();
                  break;
                case 27:
                  WeightDown();
                  break;
                case 28:
                  PowerUp();
                  break;
                case 29:
                  PowerDown();
                  break;
                default:
                  Delay4();
                }
              LCDclear();
              nState = nextTimer[nState];
              Message( menuText[stateMsg[nState]] );
            }
        }  // if nDirty
    }  // while 1
}  // main()

// ---------------------------------------------------------------
// Display the frequency
// ---------------------------------------------------------------

void ShowFreq( void )
{
  ltoa(nFreq,szMsg,10);        // Convert to ASCII text
  strcat(szMsg," Hz");         // Add "Hz" to the string
  LCDclear();                  // Clear the display
  Message(szMsg);              // and show the frequency
}

// ---------------------------------------------------------------
// Increase the frequency by the step size
// ---------------------------------------------------------------

void FreqUp( void )
{
  nFreq = nFreq + nStep;       // Bump the freq up by the setpsize
  if ( nFreq > 14100000 )      // Limit the upper frequency to
    nFreq = 14100000;          // the common CW portion
}

// ---------------------------------------------------------------
// Decrease the frequency by the step size
// ---------------------------------------------------------------

void FreqDn( void )
{
  nFreq = nFreq - nStep;       // Decrease by selected step size
  if ( nFreq < 14000000 )      // And limit the lower frequency
    nFreq = 14000000;          // to the band edge
}

// ---------------------------------------------------------------
// Test to see whether the encoder has moved
// ---------------------------------------------------------------

byte ReadEncoder( void )
{
  nEncDirty = 0;               // Assume no change
  if ( nEnc[0] )               // If pin 0 used to be high
    if ( !ENC0 )               // and it's not high now
      {
        FreqUp();              // decrease the frequency
        nEncDirty = 1;         // and remember we need to display
      }
  if ( nEnc[1] )               // If pin 1 used to be high
    if ( !ENC1 )               // and it's not high now
      {
        FreqDn();              // Decrease the frequency
        nEncDirty = 1;         // and remember we changed it
      }
  nEnc[0] = (byte) ENC0;       // Now remember the current encoder
  nEnc[1] = (byte) ENC1;       // state for next time
  return nEncDirty;            // Return true if changed
}

// ---------------------------------------------------------------
// Display the keyer weighting
// ---------------------------------------------------------------

void ShowWeight( void )
{
  strcpy(szMsg,"Key Weight=");
  LCDclear();
  // Kind of a tacky way to get the . in the string
  // We could have called itoa and then moved the letters,
  // but for just 2 digits this is probably easier
  szMsg[11] = '0'+(byte)(nKeyWeight/10);
  szMsg[12] = '.';
  szMsg[13] = '0'+(byte)(nKeyWeight%10);
  szMsg[14] = '\0';
  Message(szMsg);
  Delay();
}

// ---------------------------------------------------------------
// Increase the keyer weighting
// ---------------------------------------------------------------
void WeightUp( void )
{
  nKeyWeight++;                  // Increase the keyer weight
  if ( nKeyWeight > 37 )         // and limit it to 3.7
    nKeyWeight = 37;
  ShowWeight();
}

// ---------------------------------------------------------------
// Decrease the keyer weight
// ---------------------------------------------------------------
void WeightDown( void )
{
  nKeyWeight--;                  // Decrease the keyer weight
  if ( nKeyWeight < 29 )         // and limit it to 2.9
    nKeyWeight = 29;
  ShowWeight();
}

// ---------------------------------------------------------------
// Display the current keyer speed
// ---------------------------------------------------------------

void ShowSpeed( void )
{
  strcpy(szMsg,"Keyer Speed=");  // Start string with what we are
  LCDclear();                    // displaying and clear display
  itoa(nSpeed,&szMsg[12],10);    // Convert to decimal ASCII
  szMsg[14] = '\0';              // and be sure of terminating NULL
  Message( szMsg );              // Then display it
  Delay();                       // Chance to view display
}

// ---------------------------------------------------------------
// Increase the keyer speed
// ---------------------------------------------------------------

void SpeedUp( void )
{
  nSpeed++;                      // Increase the speed
  if ( nSpeed > 50 )             // and limit it to 50 WPM
    nSpeed = 50; 
  ShowSpeed();                   // Show the result
}

// ---------------------------------------------------------------
// Decrease the keyer speed
// ---------------------------------------------------------------

void SpeedDown( void )
{
  nSpeed--;                      // Decrease the speed
  if ( nSpeed < 5 )              // and limit it to 5 WPM
    nSpeed = 5;
  ShowSpeed();                   // Show the result
}

// ---------------------------------------------------------------
// Display the power level
// ---------------------------------------------------------------

void ShowPower( void )
{
  strcpy(szMsg,"Power=");
  LCDclear();
  // See comments in ShowWeight()
  szMsg[6] = '0'+(byte)(nPower/10);
  szMsg[7] = '.';
  szMsg[8] = '0'+(byte)(nPower%10);
  szMsg[9] = '\0';
  Message(szMsg);
  Delay();
}

// ---------------------------------------------------------------
// Increase the power level (in half-watt increments)
// ---------------------------------------------------------------

void PowerUp( void )
{
  nPower = nPower + 5;             // Increase the power level
  if ( nPower > 50 )               // and limit it to 5 watts
    nPower = 50;
  ShowPower();                     // Display it
}

// ---------------------------------------------------------------
// Decrease the power level
// ---------------------------------------------------------------

void PowerDown( void )
{
  nPower = nPower - 5;               // Decrease the power level
  if ( nPower < 5 )                  // and limit it to 0.5 watts
    nPower = 5;
  ShowPower();                       // Show the result
}

// ---------------------------------------------------------------
// Return the button number of the button last released
// ---------------------------------------------------------------

byte ButtonActive( void )
{
  byte nCurrentButton;               // Active button, 0=none

  nCurrentButton = 0;                // Set nothing currently active
  if (!nButtonLast[1])               // If PB1 was previously pressed
      if ( PB1 )                     // And it is no longer pressed
        nCurrentButton = 1;          // Then the active PB is 1
  if (!nButtonLast[3])               // If PB3 was previously pressed
      if ( PB3 )                     // And it is no longer pressed
        nCurrentButton = 3;          // Then the active PB is 3
  // Button 2 gets priority if multiples pressed
  if (!nButtonLast[2])               // If PB2 was previously pressed
      if ( PB2 )                     // And it is no longer pressed
        nCurrentButton = 2;          // Then the active PB is 2
  // Remember the states of the buttons now
  nButtonLast[1] = (byte) PB1;
  nButtonLast[2] = (byte) PB2;
  nButtonLast[3] = (byte) PB3;
  //Del2ms();                        // Allow for bounce

  // Temporary feedback
  if ( !PB1 ) Blink( LED1 );         // This will light the LED
  if ( !PB2 ) Blink( LED2 );         // as long as the corresponding
  if ( !PB3 ) Blink( LED3 );         // PB is pressed.
  return nCurrentButton;
}

// ---------------------------------------------------------------
// Display a message on the display
// ---------------------------------------------------------------

void Message( char *p )
{
  byte nCharCount;

  LCDzero();                       // Position cursor
  nCharCount = 0;                  // Initialize length
  while ( *p )                     // Until we reach the end
    {
      LCDletr( *p );               // Display the character
      p++;                         // Point to the next character
      nCharCount++;                // Increase the count
      // For some 16 character displays, the right hand 8 characters
      // start at address 0x40 in the controller, so when we reach the
      // ninth character, re-position the cursor
      if ( nCharCount == 8 )
        LCDaddr(0x40);
    }
}

