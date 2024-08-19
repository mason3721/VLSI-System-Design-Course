int main(){
extern int div1;
extern int div2;
extern int _test_start;

int i = 1;
while (i != 0){
	i = div1 % div2;
	div1 = div2;
	div2 = i;
	}
*(&_test_start) = div1;

return 0;
}