alpha [A-Za-z]
digit [0-9]
und [_]
space [ ]

%{
int yylineno;

#define IF 1
#define ELSE 2
#define INC 3
#define WHILE 4
#define INT 5
#define FLOAT 6
#define VOID 9
#define RETURN 10
#define MAIN 11
#define BREAK 56

#define ID 12

#define NUM 13

#define LE 14
#define GE 15
#define EQ 16
#define NE 17
#define OR 18
#define AND 19
#define ASS 20
#define PLUS 21
#define SUB 22
#define MULT 23
#define DIV 24
#define MOD 25
#define BA 26
#define BO 27
#define BN 28
#define L 29
#define G 30
#define PP 31
#define MM 32

#define SEMICOLON 33
#define B1 34
#define B2 35
#define C1 36
#define C2 37
#define D1 38
#define D2 39
#define COMMA 40
#define Q 41
#define COLON 57
#define FULLSTOP 58

#define HEAD 42

#define D 43
#define F 44

#define CA 45
#define CSA 46

#define ARR 47

#define SLC 48
#define MLCO 49
#define MLCC 50
#define DEF 51

#define PRINTF 52
#define SCANF 53
#define FUNC 54
#define MAINFUNC 55

%}

%%
\n	{yylineno++;}
"main(void)" return MAINFUNC;
"main()" return MAINFUNC;
"main(int argc, char **argv)" return MAINFUNC;
"main(int argc, char *argv[])" return MAINFUNC;
"return"	return RETURN;
void	return VOID;
break	return BREAK;
if    	return IF;
else    return ELSE;
printf 	return PRINTF;
scanf 	return SCANF;
#include<stdio.h> return HEAD;
#include<string.h> return HEAD;
"#define {alpha}({alpha}|{digit}|{und})* {digit}+" return DEF;
"#define {alpha}({alpha}|{digit}|{und})* ({digit}+)\.({digit}+)" return DEF;
"#define {alpha}({alpha}|{digit}|{und})* {alpha}({alpha}|{digit}|{und})*" return DEF;
"//" return SLC;
"/*" return MLCO;
"*/" return MLCC;
{digit}+    return NUM;
({digit}+)\.({digit}+) return NUM;
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
"||"    return OR;
"&&"    return AND;
while	return WHILE;
";"	return SEMICOLON;
":" 	return COLON;
"."	return FULLSTOP;
int	return INT;
float	return FLOAT;
"("	return B1;
")"	return B2;
"{"	return C1;
"}"	return C2;
"="	return ASS;
"+"	return PLUS;
"-"	return SUB;
"*"	return MULT;
"/"	return DIV;
"%"	return MOD;
"%d"	return D;
"%f"	return F;
"\""	return Q;
","	return COMMA;
",&"	return CA;
", &"	return CSA;
"&"	return BA;
"|"	return BO;
"!"	return BN;
"<"	return L;
">"	return G;
"++"	return PP;
"--"	return MM;
[ \t\n] ;
{alpha}({alpha}|{digit}|{und})*    return ID;
{alpha}({alpha}|{digit}|{und})*\[{digit}*\] return ARR;
{alpha}({alpha}|{digit}|{und})*\(({alpha}|{digit}|{und}|{space})*\) return FUNC;
"[" 	return D1;
"]" 	return D2;
. printf("NA\n");
%%

struct row
{
	int sno;
	char token[100];
	char attr[100];
	int attrno;
	int addr;
}r[100000];
int main(void)
{
	int i=0,ptoken,h[20]={0},qline=0,qcnt=0,x=1000,j,k,y=0,b_c=0,b_o=0,c_o=0,c_c=0,d_o=0,d_c=0,ntoken, vtoken,rep=0;
	ntoken = yylex();
	printf("\n");
	int mlc=0,slcline=0,mlcline;
	while(ntoken) {
		rep = 0;
		if(yylineno==slcline)
		{
			ntoken=yylex();
			continue;
		}
		y=0;
		for(k=0;k<i;k++)
		{
			if(!(strcmp(r[k].token,yytext)))
			{
				y = 1;
				break;
			}		
		}	
		if(y==1)
			rep=1;
		if(yylineno!=qline && qline!=0)
		{
			if(qcnt%2!=0)
				printf("\n-------------ERROR ! INCOMPLETE STRING at Line %d------------------\n",qline);
			qcnt=0;
		}
		if(b_c > b_o)
			printf("ERROR ! UNMATCHED ')'\n");
		if(c_c>c_o)
			printf("ERROR ! UNMATCHED '}'\n");
		if(d_c>d_o)
			printf("ERROR ! UNMATCHED ']'\n");
		if(rep==0 && ntoken!=48 && ntoken!=49 && ntoken!=50 && mlc==0 && qcnt%2==0)
		{
			r[i].sno=i+1;
			strcpy(r[i].token,yytext);
			r[i].addr = x;
		}
		if(((ntoken>=1 && ntoken<=11) || ntoken==56) && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=0;
				strcpy(r[i].attr,"KEYWORD");
			}
			printf("%s\t\tKeyword----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==12 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=1;
				strcpy(r[i].attr,"ID");
			}
			printf("%s\t\tIdentifier----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==13 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=2;
				strcpy(r[i].attr,"CONSTANT");
			}
			printf("%s\t\tConstant----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken>=14 && ntoken<=32 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=3;
				strcpy(r[i].attr,"OPERATOR");
			}
			printf("%s\t\tOperator----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken>=33 && ntoken<=41 && mlc==0)
		{
			if(ntoken==41)
			{
				qcnt++;
				qline=yylineno;
			}
			if(ntoken==34)
				b_o++;
			if(ntoken==35)
				b_c++;
			if(ntoken==36)
				c_o++;
			if(ntoken==37)
				c_c++;
			if(ntoken==38)
				d_o++;
			if(ntoken==39)
				d_c++;
			if(rep==0 && qcnt%2==0)
			{	
				ptoken=4;
				strcpy(r[i].attr,"SPECIAL CHAR");
			}
			printf("%s\t\tSpecial Character----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==42 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=5;
				strcpy(r[i].attr,"HEADER");
			}	
			printf("%s\t\tHeader----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken>=43 && ntoken<=44 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=6;
				strcpy(r[i].attr,"FORMAT SPECIFIER");
			}
			printf("%s\t\tFormat Specifier----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken>=45 && ntoken<=46 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=12;
				strcpy(r[i].attr,"VARIABLE LOCATION");
			}
			printf("%s\t\tVariable Location----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==47 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=7;
				strcpy(r[i].attr,"ARRAY");
			}
			printf("%s\t\tArray----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==48 && mlc==0)
		{
			ptoken=15;
			printf("%s\t\tSingle Line Comment----------Line %d\n",yytext,yylineno);
			slcline=yylineno;
		}
		else if(ntoken==49)
		{
			mlc=1;
			printf("%s\t\tMulti Line Comment Start----------Line %d\n",yytext,yylineno);
			mlcline = yylineno;
				
		}
		else if(ntoken==50 && mlc==1)
		{
			mlc=0;
			printf("%s\t\tMulti Line Comment End----------Line %d\n",yytext,yylineno);
			mlcline=0;
		}
		else if(ntoken==50 && mlc==0)
			printf("\n---------------ERROR! UNMATCHED NESTED END COMMENT-------------\n");
		else if(ntoken==51 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=8;
				strcpy(r[i].attr,"Preprocessor Directive");
			}
			printf("%s\t\tPreprocessor Directive----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken>=52 && ntoken<=53 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=9;
				strcpy(r[i].attr,"Pre Defined Function");
			}
			printf("%s\t\tPre Defined Function----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==54 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=10;
				strcpy(r[i].attr,"User Defined Function");
			}
			printf("%s\t\tUser Defined Function----------Line %d\n",yytext,yylineno);
		}
		else if(ntoken==55 && mlc==0)
		{
			if(rep==0 && qcnt%2==0)
			{
				ptoken=11;
				strcpy(r[i].attr,"Main Function");
			}
			printf("%s\t\tMain Function----------Line %d\n",yytext,yylineno);
		}
		if(rep==0 && ntoken!=48 && ntoken!=49 && ntoken!=50 && mlc==0 && qcnt%2==0)
		{
			h[ptoken]++;
			r[i].attrno = h[ptoken];
			i++;
			x=x+4;
		}
		ntoken=yylex();
	}
	if(mlc==1)
		printf("\n--------------------ERROR! UNMATCHED COMMENT starting at Line %d------------\n",mlcline);
	if(b_c!=b_o)
		printf("\n--------------------ERROR ! UNMATCHED '('---------------------\n");
	if(c_c!=c_o)
		printf("\n-------------------------ERROR ! UNMATCHED '{'----------------\n");
	if(d_c!=d_o)
		printf("\n--------------------ERROR ! UNMATCHED '['----------------------\n");
	printf("\n------------Symbol Table---------------------\n\nSNo\tToken\t\tAttribute\t\tMemory Location\n\n");

	for(j=0;j<i;j++)
		printf("%d\t%s\t\t< %s , %d >\t\t%d\n",r[j].sno,r[j].token,r[j].attr,r[j].attrno,r[j].addr);
	return 0;
}

int yywrap(void)
{
	return 1;
}
