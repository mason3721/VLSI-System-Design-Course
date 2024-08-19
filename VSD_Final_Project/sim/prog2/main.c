
volatile unsigned int *pwm_addr = (int *) 0x30000000;
 
int  motor1_Vcomp      = 0;

int  motor2_Vcomp       = 0;

int  motor3_Vcomp       = 0;

int  motor4_Vcomp       = 0;

int 	      motor_Vcomp_total = 0;
int           counter			= 0;

/*****************************************************************
 * Function: int main(void)  									   *
 * Description: main function                                      *
 *****************************************************************/
int main(void) {
  motor1_Vcomp=20;
		motor2_Vcomp=100;
		motor3_Vcomp=150;
		motor4_Vcomp=200;
		
		motor_Vcomp_total = (motor4_Vcomp<<24) + (motor3_Vcomp<<16) + (motor2_Vcomp<<8) + motor1_Vcomp;
		// motor_Vcomp_total = 0x11223344;
		pwm_addr[0X0] = motor_Vcomp_total;
  while (counter<1000) {
		counter ++;
	}
	return 0;
}