
alpha 			[A-Za-z_]
fl			(f|F|l|L)
ul			(u|U|l|L)*
digit 			[0-9]
space 			[ ]
hex			[a-fA-F0-9]
exp			[Ee][+-]?{digit}+

%{
int yylineno;
#include <stdio.h> 
%}

%%	
\n   { yylineno++; }
"/*"					{ multicomment(); }
"//"					{ singlecomment(); }
"#include<"({alpha})*".h>" {}
"#define"({space})""({alpha})""({alpha}|{digit})*""({space})""({digit})+"" { return DEF;}
"#define"({space})""({alpha}({alpha}|{digit})*)""({space})""(({digit}+)\.({digit}+))"" { return DEF;}
"#define"({space})""({alpha}({alpha}|{digit})*)""({space})""({alpha}({alpha}|{digit})*)"" { return DEF;}
{digit}+    				{  return CONSTANT; }
({digit}+)\.({digit}+) 			{  return CONSTANT; }
0[xX]{hex}+{ul}?			{  return CONSTANT; }
0{digit}+{ul}?				{  return CONSTANT; }
{digit}+{ul}?				{  return CONSTANT; }
{alpha}?'(\\.|[^\\'])+'			{  return CONSTANT; }
{digit}+{exp}{fl}?			{  return CONSTANT; }
{digit}*"."{digit}+({exp})?{fl}?	{  return CONSTANT; }
{digit}+"."{digit}*({exp})?{fl}?	{  return CONSTANT; }
{alpha}?\"(\\.|[^\\"])*\"	{  return STRING_LITERAL; } 
"sizeof"			{  return SIZEOF; }
"->"			{  return PTR_OP; }
"++"			{  return INC_OP; }
"--"			{  return DEC_OP; }
"<<"			{  return LEFT_OP; }
">>"			{  return RIGHT_OP; }
"<="			{  return LE_OP; }
">="			{  return GE_OP; }
"=="			{  return EQ_OP; }
"!="			{  return NE_OP; }
"&&"			{  return AND_OP; }
"||"			{  return OR_OP; }
"*="			{  return MUL_ASSIGN; }
"/="			{  return DIV_ASSIGN; }
"%="			{  return MOD_ASSIGN; }
"+="			{  return ADD_ASSIGN; }
"-="			{  return SUB_ASSIGN; }
"<<="			{  return LEFT_ASSIGN; }
">>="			{  return RIGHT_ASSIGN; }
"&="			{  return AND_ASSIGN; }
"^="			{  return XOR_ASSIGN; }
"|="			{  return OR_ASSIGN; }
"typedef"		{  return TYPEDEF; }
"extern"		{  return EXTERN; }
"static"		{  return STATIC; }
"auto"			{  return AUTO; }
"register"		{  return REGISTER; }
"char"			{  return CHAR; }
"short"			{  return SHORT; }
"int"			{  return INT; }
"long"			{  return LONG; }
"signed"		{  return SIGNED; }
"unsigned"		{  return UNSIGNED; }
"float"			{  return FLOAT; }
"double"		{  return DOUBLE; }
"const"			{  return CONST; }
"volatile"		{  return VOLATILE; }
"void"			{  return VOID; }
"struct"		{  return STRUCT; }
"union"			{  return UNION; }
"enum"			{  return ENUM; }
"..."			{  return ELLIPSIS; }
"case"			{  return CASE; }
"default"		{  return DEFAULT; }
"if"			{  return IF; }
"else"			{  return ELSE; }
"switch"		{  return SWITCH; }
"while"			{  return WHILE; }
"do"			{  return DO; }
"for"			{  return FOR; }
"goto"			{  return GOTO; }
"continue"		{  return CONTINUE; }
"break"			{  return BREAK; }
"return"		{  return RETURN; }
";"			{  return(';'); }
("{"|"<%")		{  return('{'); }
("}"|"%>")		{  return('}'); }
","			{  return(','); }
":"			{  return(':'); }
"="			{  return('='); }
"("			{  return('('); }
")"			{  return(')'); }
("["|"<:")		{  return('['); }
("]"|":>")		{  return(']'); }
"."			{  return('.'); }
"&"			{  return('&'); }
"!"			{  return('!'); }
"~"			{  return('~'); }
"-"			{  return('-'); }
"+"			{  return('+'); }
"*"			{  return('*'); }
"/"			{  return('/'); }
"%"			{  return('%'); }
"<"			{  return('<'); }
">"			{  return('>'); }
"^"			{  return('^'); }
"|"			{  return('|'); }
"?"			{  return('?'); }
{alpha}({alpha}|{digit})*    		{  return IDENTIFIER; }
[ \t\v\n\f]		{  }
.			{ /* ignore bad characters */ }
%%
yywrap()
{
	return(1);
}
multicomment()
{
	char c, c1;
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*' && c1=='/')
	{
		c=0;
	}
	if (c != 0)
		putchar(c1);
}
singlecomment()
{
	char c;
	while(c=input()!='\n');
	if(c=='\n')
		c=0;
	if(c!=0)
		putchar(c);
}
