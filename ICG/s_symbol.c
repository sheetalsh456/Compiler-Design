#include<stdio.h>
#include<string.h>
struct sym
{
	int sno;
	char token[100];
	int type[100];
	int tn;
	int addr;
	float fvalue;
	int scope;
}st[100];
int n=0,arr[10];
float t[100];
int iter=0;
int returntype_func(int ct)
{
	return arr[ct-1];
}
void storereturn( int ct, int returntype )
{
	arr[ct] = returntype;
	return;
}
void insertscope(char *a,int s)
{
	int i;
	for(i=0;i<n;i++)
	{
		if(!strcmp(a,st[i].token))
		{
			st[i].scope=s;
			break;
		}
	}
}
int returnscope(char *a,int cs)
{
	int i;
	int max = 0;
	for(i=0;i<=n;i++)
	{
		if(!(strcmp(a,st[i].token)) && cs>=st[i].scope)
		{
			if(st[i].scope>=max)
				max = st[i].scope;
		}
	}
	return max;
}
int lookup(char *a)
{
	int i;
	for(i=0;i<n;i++)
	{
		if( !strcmp( a, st[i].token) )
			return 0;
	}
	return 1;
}
int returntype(char *a,int sct)
{
	int i;
	for(i=0;i<=n;i++)
	{
		if(!strcmp(a,st[i].token) && st[i].scope==sct)
		{
			return st[i].type[0];
		}
	}
}

void check_scope_update(char *a,char *b,int sc)
{
	int i,j,k;
	int max=0;
	for(i=0;i<=n;i++)
	{
		if(!strcmp(a,st[i].token)   && sc>=st[i].scope)
		{
			if(st[i].scope>=max)
				max=st[i].scope;
		}
	}
	for(i=0;i<=n;i++)
	{
		if(!strcmp(a,st[i].token)   && max==st[i].scope)
		{
			float temp=atof(b);
			for(k=0;k<st[i].tn;k++)
			{
				if(st[i].type[k]==258)
					st[i].fvalue=(int)temp;
				else
					st[i].fvalue=temp;
			}
		}
	}
}
void storevalue(char *a,char *b,int s_c)
{
	int i;
	for(i=0;i<=n;i++)
	{
		if(!strcmp(a,st[i].token) && s_c==st[i].scope)
		{
			st[i].fvalue=atof(b);
		}
	}
}

void insert(char *name, int type, int addr)
{
	int i;
	if(lookup(name))
	{
		strcpy(st[n].token,name);
		st[n].tn=1;
		st[n].type[st[n].tn-1]=type;
		st[n].addr=addr;
		st[n].sno=n+1;
		n++;
	}
	else
	{
		for(i=0;i<n;i++)
		{
			if(!strcmp(name,st[i].token))
			{
				st[i].tn++;
				st[i].type[st[i].tn-1]=type;
				break;
			}
		}
	}	
	
	return;
}
void insert_dup(char *name, int type, int addr,int s_c)
{
	strcpy(st[n].token,name);
	st[n].tn=1;
	st[n].type[st[n].tn-1]=type;
	st[n].addr=addr;
	st[n].sno=n+1;
	st[n].scope=s_c;
	n++;
	return;
}

void print()
{
	int i,j;
	printf("\nSymbol Table\n\n");
	printf("\nSNo.\tToken\tAddress\tValue\tScope\tType\n");
	for(i=0;i<n;i++)
	{
		if(st[i].type[0]==258)
			printf("%d\t%s\t%d\t%d\t%d",st[i].sno,st[i].token,st[i].addr,(int)st[i].fvalue,st[i].scope);
		else
			printf("%d\t%s\t%d\t%.1f\t%d",st[i].sno,st[i].token,st[i].addr,st[i].fvalue,st[i].scope);
		for(j=0;j<st[i].tn;j++)
		{
			if(st[i].type[j]==258)
				printf("\tINT");
			else if(st[i].type[j]==259)
				printf("\tFLOAT");
			else if(st[i].type[j]==271)
				printf("\tFUNCTION");
			else if(st[i].type[j]==269)
				printf("\tARRAY");
			else if(st[i].type[j]==260)
				printf("\tVOID");
		}
		printf("\n");
	}
	return;
}
