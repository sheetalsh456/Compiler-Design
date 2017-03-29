%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "s_symbol.c"
	int g_addr = 100;
int i=1,lnum1=0,label1[20],ltop1;
int stack[100],index1=0,end[100],arr[10],gl1,gl2,ct,c,b,fl,top=0,label[20],lnum=0,ltop=0;
char st1[100][10];
char i_[2]="0";
char temp[2]="t";
char null[2]=" ";
void yyerror(char *s);
int printline();
void open1()
{
	stack[index1]=i;
	i++;
	index1++;
	return;
}
void close1()
{
	index1--;
	end[stack[index1]]=1;
	stack[index1]=0;
	return;
}
void if1()
{
	lnum++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = not %s\n",temp,st1[top]);
 	printf("if %s goto L%d\n",temp,lnum);
	i_[0]++;
	label[++ltop]=lnum;	
	
}
void if2()
{
	lnum++;
	printf("goto L%d\n",lnum);
	printf("L%d: \n",label[ltop--]);
	label[++ltop]=lnum;
}
void if3()
{
	printf("L%d:\n",label[ltop--]);
}
void w1()
{
	lnum++;
	label[++ltop]=lnum;
	printf("L%d:\n",lnum);
}
void w2()
{
	lnum++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,lnum);
	i_[0]++;
	label[++ltop]=lnum;
}
void w3()
{
	int y=label[ltop--];
	printf("goto L%d\n",label[ltop--]);
	printf("L%d:\n",y);
}
void dw1()
{
	lnum++;
	label[++ltop]=lnum;
	printf("L%d:\n",lnum);
}
void dw2()
{
 	printf("if %s goto L%d\n",st1[top--],label[ltop--]);
}
void f1()
{
	lnum++;
	label[++ltop]=lnum;
	printf("L%d:\n",lnum);
}
void f2()
{
	lnum++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,lnum);
	i_[0]++;
	label[++ltop]=lnum;
	lnum++;
	printf("goto L%d\n",lnum);
	label[++ltop]=lnum;
	lnum++;
	printf("L%d:\n",lnum);	
	label[++ltop]=lnum;
}
void f3()
{
	printf("goto L%d\n",label[ltop-3]);
	printf("L%d:\n",label[ltop-1]);
}
void f4()
{
	printf("goto L%d\n",label[ltop]);
	printf("L%d:\n",label[ltop-2]);
	ltop-=4;
}
void push(char *a)
{
	strcpy(st1[++top],a);
}
void array1()
{
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = %s * 4\n",temp,st1[top]);
	strcpy(st1[top],temp);
	i_[0]++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = %s [ %s ] \n",temp,st1[top-1],st1[top]);
	top--;
	strcpy(st1[top],temp);
	i_[0]++;	
}
void codegen()
{
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = %s %s %s\n",temp,st1[top-2],st1[top-1],st1[top]);
	top-=2;
	strcpy(st1[top],temp);
	i_[0]++;
}
void codegen_umin()
{
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = -%s\n",temp,st1[top]);
	top--;
	strcpy(st1[top],temp);
	i_[0]++;
}
void codegen_assign()
{
	printf("%s = %s\n",st1[top-2],st1[top]);
	top-=2;
}


%}
%token<ival> INT FLOAT VOID
%token<str> ID NUM REAL LE GE EQ NEQ AND OR
%token WHILE IF RETURN PREPROC STRING PRINT FUNCTION DO ARRAY ELSE STRUCT STRUCT_VAR FOR
%left LE GE EQ NEQ AND OR '<' '>'
%right '='
%right UMINUS 
%left '+' '-'
%left '*' '/' 
%type<str> assignment assignment1 consttype '=' '+' '-' '*' '/' E T F 
%type<ival> Type
%union {
		int ival;
		char *str;
	}
%%

start : Function start 
	| PREPROC start 
	| Declaration start
	| 
	;

Function : Type ID '('')'  CompoundStmt {
	if(strcmp($2,"main")!=0)
	{
		printf("goto F%d\n",lnum1);
	}
	if ($1!=returntype_func(ct))
	{
		printf("\nError : Type mismatch : Line %d\n",printline());
	}

	if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar") && strcmp($2,"clearerr") && strcmp($2,"getw") && strcmp($2,"putw") && strcmp($2,"putc") && strcmp($2,"rewind") && strcmp($2,"sprint") && strcmp($2,"sscanf") && strcmp($2,"remove") && strcmp($2,"fflush"))) 
		printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
	else 
	{ 
		insert($2,FUNCTION,g_addr); 
		insert($2,$1,g_addr); 
		g_addr+=4;
	}
	}
	;

Type : INT
	| FLOAT
	| VOID
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt 
	| 
	;

stmt : Declaration
	| if 
	| ID '(' ')' ';' 
	| while 
	| dowhile 
	| for 
	| RETURN consttype ';' {
					if(!(strspn($2,"0123456789")==strlen($2))) 
						storereturn(ct,FLOAT); 
					else 
						storereturn(ct,INT); ct++;
					} 
	| RETURN ';' {storereturn(ct,VOID); ct++;} 
	| ';'
	| PRINT '(' STRING ')' ';' 
	| CompoundStmt 
	;

dowhile : DO {dw1();} CompoundStmt WHILE '(' E ')' {dw2();} ';'
	;

for	: FOR '(' E {f1();} ';' E {f2();}';' E {f3();} ')' CompoundStmt {f4();}
	;

if : 	 IF '(' E ')' {if1();} CompoundStmt {if2();} else
	;

else : ELSE CompoundStmt {if3();}
	| 
	;

while : WHILE {w1();}'(' E ')' {w2();} CompoundStmt {w3();}
	;

assignment : ID '=' consttype 
	| ID '+' assignment 
	| ID ',' assignment
	| consttype ',' assignment
	| ID
	| consttype
	;

assignment1 : ID {push($1);} '=' {strcpy(st1[++top],"=");} E {codegen_assign();}  
	{
		int sct=returnscope($1,stack[index1-1]); 
		int type=returntype($1,sct); 
		if((!(strspn($5,"0123456789")==strlen($5))) && type==258 && fl==0) 
			printf("\nError : Type Mismatch : Line %d\n",printline()); 
		if(!lookup($1)) 
		{ 
			int currscope=stack[index1-1]; 
			int scope=returnscope($1,currscope); 
			if((scope<=currscope && end[scope]==0) && !(scope==0)) 
			{
				check_scope_update($1,$5,currscope);
			}
		} 
		}

	| ID ',' assignment1    {
					if(lookup($1)) 
						printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
				}
	| consttype ',' assignment1   
	| ID  {
		if(lookup($1)) 
			printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
		}
	| consttype
	;

consttype : NUM
	| REAL
	;

Declaration : Type ID {push($2);} '=' {strcpy(st1[++top],"=");} E {codegen_assign();} ';'  
	{
		if( (!(strspn($6,"0123456789")==strlen($6))) && $1==258 && (fl==0)) 
		{
			printf("\nError : Type Mismatch : Line %d\n",printline());
			fl=1;
		} 
		if(!lookup($2)) 
		{
			int currscope=stack[index1-1]; 
			int previous_scope=returnscope($2,currscope); 
			if(currscope==previous_scope) 
				printf("\nError : Redeclaration of %s : Line %d\n",$2,printline()); 
			else 
			{
				insert_dup($2,$1,g_addr,currscope);
				check_scope_update($2,$6,stack[index1-1]);
				int sg=returnscope($2,stack[index1-1]); 
				g_addr+=4;
			}
		} 
		else 
		{ 
			int scope=stack[index1-1];  
			insert($2,$1,g_addr); 
			insertscope($2,scope); 
			check_scope_update($2,$6,stack[index1-1]);
			g_addr+=4;
		}
	}

	| assignment1 ';'  {
				if(!lookup($1)) 
				{ 
					int currscope=stack[index1-1]; 
					int scope=returnscope($1,currscope); 
					if(!(scope<=currscope && end[scope]==0) || scope==0) 
						printf("\nError : Variable %s out of scope : Line %d\n",$1,printline());
				} 
				else 
					printf("\nError : Undeclared Variable %s : Line %d\n",$1,printline()); 
				}

	| Type ID '[' assignment ']' ';' {
						insert($2,ARRAY,g_addr); 
						insert($2,$1,g_addr); 
						g_addr+=4; 
					}
	| ID '[' assignment1 ']' ';'
	| STRUCT ID '{' Declaration '}' ';' {
						insert($2,STRUCT,g_addr); 
						g_addr+=4; 
						}
	| STRUCT ID ID ';' {
				insert($3,STRUCT_VAR,g_addr); 
				g_addr+=4;
				}
	| error
	;

array : ID {push($1);}'[' E ']'
	;

E : E '+'{strcpy(st1[++top],"+");} T{codegen();}
   | E '-'{strcpy(st1[++top],"-");} T{codegen();}
   | T
   | ID {push($1);} LE {strcpy(st1[++top],"<=");} E {codegen();}
   | ID {push($1);} GE {strcpy(st1[++top],">=");} E {codegen();}
   | ID {push($1);} EQ {strcpy(st1[++top],"==");} E {codegen();}
   | ID {push($1);} NEQ {strcpy(st1[++top],"!=");} E {codegen();}
   | ID {push($1);} AND {strcpy(st1[++top],"&&");} E {codegen();}
   | ID {push($1);} OR {strcpy(st1[++top],"||");} E {codegen();}
   | ID {push($1);} '<' {strcpy(st1[++top],"<");} E {codegen();}
   | ID {push($1);} '>' {strcpy(st1[++top],">");} E {codegen();}
   | ID {push($1);} '=' {strcpy(st1[++top],"||");} E {codegen_assign();}
   | array {array1();}
   ;
T : T '*'{strcpy(st1[++top],"*");} F{codegen();}
   | T '/'{strcpy(st1[++top],"/");} F{codegen();}
   | F
   ;
F : '(' E ')' {$$=$2;}
   | '-'{strcpy(st1[++top],"-");} F{codegen_umin();} %prec UMINUS
   | ID {push($1);fl=1;}
   | consttype {push($1);}
   ;

%%

#include "lex.yy.c"
#include<ctype.h>


int main(int argc, char *argv[])
{
	yyin =fopen(argv[1],"r");
	yyparse();
	if(!yyparse())
	{
		printf("Parsing done\n");
		print();
	}
	else
	{
		printf("Error\n");
	}
	fclose(yyin);
	return 0;
}

void yyerror(char *s)
{
	printf("\nLine %d : %s %s\n",yylineno,s,yytext);
}
int printline()
{
	return yylineno;
}
