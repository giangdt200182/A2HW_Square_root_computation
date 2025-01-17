#include <stdio.h>
#include "system.h"

// Define memory-mapped I/O addresses for timer and peripherals
unsigned int *timer_status = 0x81109000;
unsigned int *timer_control = 0x81109004;
unsigned int *timer_periodl = 0x81109008;
unsigned int *timer_periodh = 0x8110900C;
unsigned int *timer_snapl = 0x81109010;
unsigned int *timer_snaph = 0x81109014;

// Define memory-mapped I/O addresses for LEDs and switches
unsigned int *ledr = 0x81109030; // LED output register
unsigned int *sw   =   0x81109020; // Switch input register

// Define memory-mapped PIOs 
unsigned int *reg_A  = ;
bool *start          = ;
bool *done           = ;
unsigned int *result = ;



unsigned int timer_period; // Global variable to hold the timer period

// Start the timer with a control configuration
void start_timer()
{
	*timer_control = 0x00000006;
}

// Retrieve the timer period by combining high and low 16-bit registers
unsigned int get_timer_period ()
{
	return ((((*timer_periodh)<<16))|(*timer_periodl&0xffff));
}

// Retrieve the current timer value by reading the snapshot registers
unsigned int get_timer_value ()
{
	*timer_snapl = 0;
	return (((*timer_snaph)<<16)|(*timer_snapl&0xffff));
}

// Compute the time interval between two timer values
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

// Compute the integer square root of a 32-bit number using an iterative algorithm
unsigned int sqrt_root(unsigned int A) {
    int reg_result = 0;
    *reg_A = A;
    *start = 1;
    while ((*done) == 1 ){
        reg_result = *result; 
        *start = 0;
    } 
    return reg_result;
}

int main() {
    unsigned int first_value, second_value, check; // Timer values and result accumulator
    unsigned int tab_val[200]; // Array of test values (squares of indices)
    unsigned int tab_res[200]; // Array of computed square roots
    unsigned short i, j; // Loop indices

    printf("Hello from Nios II!\n");
    
    // Initialize the timer and retrieve its period
    timer_period = get_timer_period();
    start_timer();

    // Populate the `tab_val` array with squares of indices
    for (j = 0; j < 200; j++) {
		tab_val[j]=j*j;
		}

    // Measure time before computation
    first_value = get_timer_value();

    *sig_start=0;
    // Compute square roots for each value in `tab_val`
    for (i = 0; i < 100; i++) {
			for (j = 0; j < 200; j++) {
				tab_res[j]=sqrt_root(tab_val[j]);
			}
		}

    // Measure time after computation
    second_value = get_timer_value();

    // Accumulate all computed results into `restot`
    check = 0;
	for (j = 0; j < 200; j++) {
		if (tab_res[j]==j){
            check += 1;
            printf("Error in computation of %u", j);
        }
	}

    // Print the computation duration and accumulated result
	printf("t1: %u, t2: %u, computation duration: %u\n", first_value,second_value,compute_time_interval(first_value,second_value));

    //    *ledr = computation_result; // Display result on LEDs
    while (1) {
        if(check==0)
            *ledr = *sw; // Maintain real-time interaction
    }

    return 0;
}