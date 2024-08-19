int main(void){
	extern int array_size;
	extern int array_addr;
	extern int _test_start;
	
	int s1 = array_size;
	int array[s1];
	int i;
	int j;
	int temp;
	for(i = 0; i < s1 ; ++i){
		array[i] = *(&array_addr + i);
	}
	for(i = 0; i < s1; ++i){
		for(j = 0; j < i; ++j){
			if(array[j]>array[i]){
				temp = array[j];
				array[j]=array[i];
				array[i]=temp;
			}
		}
	}
		
	for(i = 0;i<s1; ++i){
		*(&_test_start+i) = array[i]; 
	}	

	return 0;
}
