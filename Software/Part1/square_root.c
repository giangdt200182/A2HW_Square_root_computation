#include <stdio.h>
#include "system.h"

unsigned int *timer_status = 0x81109000;
unsigned int *timer_control = 0x81109004 ;
unsigned int *timer_periodl = 0x81109008 ;
unsigned int *timer_periodh = 0x8110900C;
unsigned int *timer_snapl = 0x81109010;
unsigned int *timer_snaph = 0x81109014;
unsigned short *SW = 0x80000000;
unsigned short *LEDR = 0x81109020;
unsigned int timer_period ;

void start_timer()
{
	*timer_control = 0x00000006;
}

unsigned int get_timer_period ()
{
	return ((((*timer_periodh)<<16))|(*timer_periodl&0xffff));
}

unsigned int get_timer_value ()
{
	*timer_snapl = 0;
	return (((*timer_snaph)<<16)|(*timer_snapl&0xffff));
}

unsigned int compute_time_interval(unsigned int v1, unsigned int v2)
{
	unsigned int time_interval;
	if (v1>=v2)
	{
		time_interval = v1-v2;
	}
	else
	{
		time_interval = v1 + timer_period - v2;
	}
	return time_interval;
}



int main()
{
	unsigned int first_value, second_value,restot;
	unsigned int tab_val[200];
	unsigned int tab_res[200];
	unsigned short i,j,k;
	
	printf("Hello from Nios II!\n");

	timer_period = get_timer_period();
	start_timer();

	first_value = get_timer_value();
	second_value = get_timer_value();

	printf("t1: %u, t2: %u, computation duration: %u\n",first_value,second_value,compute_time_interval(first_value,second_value));
 while (1) {*LEDR=*SW;}
  return 0;
}
