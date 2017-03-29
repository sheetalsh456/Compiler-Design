#include <stdio.h>
int main()
{
	int a=5;
	int b=6;
	do
	{
		b=b+1;
		do
		{
			b=9;
		}while(a==7);
	}while(a>7);
	return 0;
}
