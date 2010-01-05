#include <pic18fregs.h>

void Delay2(void)
{
  unsigned int Count;

  //Count = 65535;
  Count = 16383;
  while ( Count != 0 )
    Count--;
}

void Delay( void )
{
  Delay2();
  Delay2();
  Delay2();
  Delay2();
}

void Delay4( void )
{
  Delay();
  Delay();
  Delay();
  Delay();
}

