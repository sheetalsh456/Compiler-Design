#include <stdio.h>
int main()
{
	int a=5;
	int b=6;
	for(a=9;a!=6;a=a-1)
	{
		b=2;
		for(b=0;b<=9;b=b*2)
		{
			b=7;
		}
	}
	b=b/9;
	return 0;
}
