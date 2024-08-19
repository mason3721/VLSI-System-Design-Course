unsigned int *copy_addr; // = &_test_start;
unsigned int copy_count = 0;
const unsigned int sensor_size = 8;
volatile unsigned int *sensor_addr = (int *) 0x10000000;
volatile unsigned int *pwm_addr = (int *) 0x30000000;

//static int    motor_kp          = 10;    
static int    motor_kp_mul          = 8;
static int    motor_kp_div          = 1;     //  /
//static int    motor_ki          = 0;      
static int    motor_ki_mul          = 5;
static int    motor_ki_div          = 1;     //  /
//static int    motor_kd          = 1;      
static int    motor_kd_mul          = 10;
static int    motor_kd_div          = 1;     //  /
 

int  motor1_Vsens	    = 0;
int  motor1_err        = 0;
int  motor1_err_prev   = 0;
int  motor1_integral   = 0;
int  motor1_derivative = 0;
int  motor1_Vcomp      = 0;
int  motor1_Vcomp_temp = 0;
int 		  motor1_Vref       = 0;
//volatile char motor1_PWM_Value  = 0;

 int  motor2_Vsens	     = 0;
 int  motor2_err         = 0;
 int  motor2_err_prev    = 0;
 int  motor2_integral    = 0;
 int  motor2_derivative  = 0;
 int  motor2_Vcomp       = 0;
 int  motor2_Vcomp_temp  = 0;
int 		  motor2_Vref        = 0;
//volatile char motor2_PWM_Value  = 0;

 int  motor3_Vsens	     = 0;
 int  motor3_err         = 0;
 int  motor3_err_prev    = 0;
 int  motor3_integral    = 0;
 int  motor3_derivative  = 0;
 int  motor3_Vcomp       = 0;
 int  motor3_Vcomp_temp  = 0;
int 		  motor3_Vref        = 0;
//volatile char motor3_PWM_Value  = 0;

 int  motor4_Vsens	     = 0;
 int  motor4_err         = 0;
 int  motor4_err_prev    = 0;
 int  motor4_integral    = 0;
 int  motor4_derivative  = 0;
 int  motor4_Vcomp       = 0;
 int  motor4_Vcomp_temp  = 0;
int 		  motor4_Vref        = 0;
//volatile char motor4_PWM_Value  = 0;

volatile int  initial_vel		= 0;
volatile int  x_value			= 0;	
volatile int  y_value			= 0;	
volatile int  z_value			= 0; 

int 	      motor_Vcomp_total = 0;
int           counter			= 0;
int			  distance			= 0;

/*****************************************************************
 * Function: void copy()                                         *
 * Description: Part of interrupt service routine (ISR).         *
 *              Copy data from sensor controller to data memory. *
 *****************************************************************/
void copy () {
	int i;
	for (i = 0; i < sensor_size; i++) {             // Copy data from sensor controller to DM
		*(copy_addr + i) = sensor_addr[i];
	}
	copy_addr += sensor_size; // Update copy address
	copy_count++;    // Increase copy count*/
	
	asm("li t6, 0x80");
	asm("csrc mstatus, t6"); // Disable MPIE of mstatus
	return;
}



/*****************************************************************
 * Function: int main(void)  									   *
 * Description: main function                                      *
 *****************************************************************/
int main(void) {
  extern unsigned int _test_start;
  int *sort_addr = &_test_start; 
  int *keep_addr = &_test_start; 
  int sort_count = 0;
  copy_addr = &_test_start;

  // Enable Global Interrupt
  asm("csrsi mstatus, 0x8"); // MIE of mstatus

  // Enable Local Interrupt
  asm("li t6, 0x800");
  asm("csrs mie, t6"); // MEIE of mie 

  // Enable Sensor Controller
  sensor_addr[0x40] = 1; // Enable sctrl_en

	/*initial_vel = 200;
	x_value = 0;
	y_value = 50;

	motor1_Vref = initial_vel - x_value -  y_value;
	motor2_Vref = initial_vel + x_value -  y_value;	
	motor3_Vref = initial_vel + x_value +  y_value;
	motor4_Vref = initial_vel - x_value +  y_value;*/

  while (1) {
      // Wait for interrupt of sensor controller
      //asm("wfi");
      // Because there is only one interrupt source, we don't need to poll interrupt source
	  counter ++;
	  if(counter > 500000000) {
		  sensor_addr[0x80] = 1; // Enable sctrl_clear
		  return 0;
	  }
	  else {
	  	// *(copy_addr    ): motor1 feedback value
	  	// *(copy_addr + 1): motor2 feedback value
	  	// *(copy_addr + 2): motor3 feedback value
	  	// *(copy_addr + 3): motor4 feedback value
	  	// *(copy_addr + 4): initial velocity value
	  	// *(copy_addr + 5): x value
	  	// *(copy_addr + 6): y value
	  	// *(copy_addr + 7): distance

		copy_addr = keep_addr;

		asm("wfi");
		
		motor1_Vsens = *(sort_addr);		
		motor2_Vsens = *(sort_addr + 1);
		motor3_Vsens = *(sort_addr + 2);
		motor4_Vsens = *(sort_addr + 3);
		
		initial_vel  = *(sort_addr + 4);
		x_value 	 = *(sort_addr + 5);
		y_value 	 = *(sort_addr + 6);
		distance 	 = *(sort_addr + 7);
		
		if((distance<=25) & (y_value > 0)) y_value = -5;
		
		motor1_Vref = initial_vel - x_value -  y_value;
		motor2_Vref = initial_vel + x_value -  y_value;	
		motor3_Vref = initial_vel + x_value +  y_value;
		motor4_Vref = initial_vel - x_value +  y_value;

		sort_addr = keep_addr;

		motor1_err  = motor1_Vref - motor1_Vsens ;
 		motor1_integral = motor1_integral + (motor1_err + motor1_err_prev) >>1; // adjustible
		motor1_derivative = motor1_err - motor1_err_prev;
   		// motor1_Vcomp_temp =  motor_kp_mul * motor1_err;
		motor1_Vcomp_temp =  (motor1_Vref >>3) + ((motor_kp_mul * motor1_err) / motor_kp_div) + ((motor_ki_mul * motor1_integral) / motor_ki_div) + ((motor_kd_mul * motor1_derivative) / motor_kd_div);
		motor1_err_prev = motor1_err;
		
		//motor2_Vsens = *(copy_addr + 1);
		motor2_err  = motor2_Vref - motor2_Vsens ;
 		motor2_integral = motor2_integral + (motor2_err + motor2_err_prev) >>1; // adjustible
		motor2_derivative = motor2_err - motor2_err_prev;
   		//motor2_Vcomp_temp =  motor_kp * motor2_err +  motor_ki * motor2_integral + motor_kd * motor2_derivative;
		motor2_Vcomp_temp =  (motor2_Vref >>3) + ((motor_kp_mul * motor2_err) / motor_kp_div) + ((motor_ki_mul * motor2_integral) / motor_ki_div) + ((motor_kd_mul * motor2_derivative) / motor_kd_div);
		motor2_err_prev = motor2_err;
	
		//motor3_Vsens = *(copy_addr + 2);
		motor3_err  = motor3_Vref - motor3_Vsens ;
 		motor3_integral = motor3_integral + (motor3_err + motor3_err_prev) >>1; // adjustible
		motor3_derivative = motor3_err - motor3_err_prev;
    	//motor3_Vcomp_temp =  motor_kp * motor3_err +  motor_ki * motor3_integral + motor_kd * motor3_derivative;
		motor3_Vcomp_temp =  (motor3_Vref >>3) + ((motor_kp_mul * motor3_err) / motor_kp_div) + ((motor_ki_mul * motor3_integral) / motor_ki_div) + ((motor_kd_mul * motor3_derivative) / motor_kd_div);
		motor3_err_prev = motor3_err;
		
		//motor4_Vsens = *(copy_addr + 3);
		motor4_err  = motor4_Vref - motor4_Vsens ;
 		motor4_integral = motor4_integral + (motor4_err + motor4_err_prev) >>1; // adjustible
		motor4_derivative = motor4_err - motor4_err_prev;
   		//motor4_Vcomp_temp =  motor_kp * motor4_err +  motor_ki * motor4_integral + motor_kd * motor4_derivative;
		motor4_Vcomp_temp =  (motor4_Vref >>3) + ((motor_kp_mul * motor4_err) / motor_kp_div) + ((motor_ki_mul * motor4_integral) / motor_ki_div) + ((motor_kd_mul * motor4_derivative) / motor_kd_div);
		motor4_err_prev = motor4_err;
		
		
		if(motor1_Vcomp_temp>255)
		motor1_Vcomp = 255;
		else if(motor1_Vcomp_temp<=0)
		motor1_Vcomp = 0;
		else
		motor1_Vcomp = motor1_Vcomp_temp & 0x000000ff;
		
		if(motor2_Vcomp_temp>255)
		motor2_Vcomp = 255;
		else if(motor2_Vcomp_temp<=0)
		motor2_Vcomp = 0;
		else
		motor2_Vcomp = motor2_Vcomp_temp & 0x000000ff;
	
	    if(motor3_Vcomp_temp>255)
		motor3_Vcomp = 255;
		else if(motor3_Vcomp_temp<=0)
		motor3_Vcomp = 0;
		else
		motor3_Vcomp = motor3_Vcomp_temp & 0x000000ff;
	    
		if(motor4_Vcomp_temp>255)
		motor4_Vcomp = 255;
		else if(motor4_Vcomp_temp<=0)
		motor4_Vcomp = 0;
		else
		motor4_Vcomp = motor4_Vcomp_temp & 0x000000ff;
	
		// motor2_Vcomp = motor2_Vcomp & 0x000000ff;
		// motor3_Vcomp = motor3_Vcomp & 0x000000ff;
		// motor4_Vcomp = motor4_Vcomp & 0x000000ff;
		
		motor_Vcomp_total = (motor4_Vcomp<<24) + (motor3_Vcomp<<16) + (motor2_Vcomp<<8) + motor1_Vcomp;
		// motor_Vcomp_total = 0x11223344;
		pwm_addr[0X0] = motor_Vcomp_total;
		sensor_addr[0x80] = 1; // Enable sctrl_clear
		
	}
  }
}
