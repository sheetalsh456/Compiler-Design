#include <stdio.h>
int main()
{
	int a = 4 ;
	{
		int b=3;
		float hg=9.7;
		int c=10;
		a=5;
		{
			b=10;
			int c=11;
			a=6;
			a;
		}
		c=8;
	}
	return 0;
}
void foo()
{
	int a=678;
	return;
}
