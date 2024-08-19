extern int array_size;
extern short array_addr;
extern short _test_start;

int main(void)
{
    int num = array_size;
    int temp;
	int tempArray[128];

    for (int i = 0; i < num; i++)   //load
		tempArray[i] = *(&(array_addr) + i);


    for (int i = 0; i < (num-1); i++)   //bubble
    {
        for (int j = 0; j < (num-1-i); j++)
        {
            if ( tempArray[j] > tempArray[j+1] )
            {
            	temp = tempArray[j];
                tempArray[j] = tempArray[j+1];
                tempArray[j+1] = temp;
            }   
        }   
    }

	for (int i = 0; i < num; i++)   //store
        *(&(_test_start) + i) = tempArray[i];

    return 0;
}