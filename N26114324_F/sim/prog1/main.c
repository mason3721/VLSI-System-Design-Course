int main(){
extern int array_size;
extern int array_addr;
extern int _test_start;

int *array = &array_addr;

for(int a=0; a<array_size; ++a){
	for(int b=0; b<a; ++b){
		if(array[b] > array[a]){
			int temp = array[b];
			array[b] = array[a];
			array[a] = temp;
		}
	}	
}
for(int a=0; a<array_size; ++a){
	*(&_test_start+a) = array[a];
}
return 0;
}