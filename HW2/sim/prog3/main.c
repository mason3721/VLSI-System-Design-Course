int main(void){
	extern int _test_start;
	extern int div1;
	extern int div2;
	int num;
	int dividend;
	int divisor;
	
	dividend = ((*(&div1)) > (*(&div2)))? (*(&div1)) : (*(&div2));

	divisor = ((*(&div1)) > (*(&div2)))? (*(&div2)) : (*(&div1));
	
	// Find remainder when dividend % divisor > 0
	while ( dividend % divisor > 0 )   
	{    num = dividend;			
		 dividend = divisor;
		 divisor = num % divisor;
	}
	
	// Store Answers
	*(&_test_start) = divisor;  //GCD
	
	return 0;
}

