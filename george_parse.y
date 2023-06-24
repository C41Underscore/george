
%{
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
        return 1;
}

void main()
{
	FILE *source; int i;
	source = fopen("../test.george", "r");

	if(source == NULL)
	{
		yyerror("Invalid source file");
		exit(0);
	}

	yyin = source;

	char buf[64];
	fgets(buf, 64, source);
	printf("%s\n", buf);

	do
	{
		yyparse();
	} while(!feof(yyin));

	fclose(source);
	exit(0);
}

#ifdef __cplusplus
}
#endif

%}

%token FUNCTION RETURN DO WHILE FOR IMPORT FROM TRUE FALSE NULL_CHAR
%token IDENTIFIER
%token TYPE INTEGER FLOAT CHAR STRING
%token SEMICOLON COLON COMMA NEWLINE
%token LEFT_BRACKET RIGHT_BRACKET LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_SCOPE_BRACKET RIGHT_SCOPE_BRACKET
%token EQUAL PLUS MINUS DIVIDE MULTIPLY
%token PLUS_INLINE MINUS_INLINE DIVIDE_INLINE MULTIPLY_INLINE
%token EQ LT LTQ GT GTQ
%token AND OR NOT

%%

program:
	import_list functions {printf("program\n");}
	;

import_list:
	import_statement
	|
	import_list NEWLINE import_statement
	{printf("import_list\n");} ;

import_statement:
	IMPORT IDENTIFIER
	|
	FROM IDENTIFIER IMPORT identifier_list
	{printf("import_statement\n");} ;

identifier_list:
	IDENTIFIER
	|
	identifier_list COMMA IDENTIFIER
	{printf("identifier_list\n");} ;

functions:
	function
	|
	functions function
	{printf("functions\n");} ;

function:
	function_decl LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	{printf("function\n");} ;

function_decl:
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET RIGHT_BRACKET
	|
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET parameter_list RIGHT_BRACKET
	{printf("function_decl\n");} ;

parameter_list:
	parameter
	|
	parameter_list COMMA parameter
	{printf("parameter_list\n");} ;

parameter:
	TYPE IDENTIFIER
	{printf("parameter\n");} ;

statements:
	statement
	|
	statements NEWLINE statement
	;

statement:
	variable_declaration
	|
	for
	|
	do
	|
	while
	|
	return
	|
	expression
	;

variable_declaration:
	TYPE IDENTIFIER EQUAL expression
	|
	TYPE IDENTIFIER
	;

for:
	FOR LEFT_BRACKET SEMICOLON SEMICOLON RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON RIGHT_BRACKET COLON NEWLINE LEFT_SCOPE_BRACKET
	statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON relational_expression
	SEMICOLON RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON relational_expression
	SEMICOLON expression RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET SEMICOLON relational_expression
	SEMICOLON expression RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET SEMICOLON SEMICOLON expression RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET SEMICOLON relational_expression SEMICOLON RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON expression RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	;

do:
	DO COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET WHILE LEFT_BRACKET relational_expression RIGHT_BRACKET
	;

while:
	WHILE LEFT_BRACKET relational_expression RIGHT_BRACKET COLON LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	;

return:
	RETURN expression
	;

expression:
	expression AND relational_expression
	|
	expression OR relational_expression
	|
	relational_expression
	;

relational_expression:
	relational_expression EQ arithmetic_expression
	|
	relational_expression LT arithmetic_expression
	|
	relational_expression GT arithmetic_expression
	|
	relational_expression LTQ arithmetic_expression
	|
	relational_expression GTQ arithmetic_expression
	|
	arithmetic_expression
	;

arithmetic_expression:
	arithmetic_expression PLUS term
	|
	arithmetic_expression MINUS term
	|
	arithmetic_expression PLUS_INLINE term
	|
	arithmetic_expression MINUS_INLINE term
	|
	term
	;

term:
	term MULTIPLY factor
	|
	term DIVIDE factor
	|
	term MULTIPLY_INLINE factor
	|
	term DIVIDE_INLINE factor
	|
	factor
	;

factor:
	MINUS operand
	|
	NOT operand
	|
	operand
	;

operand:
	INTEGER
	|
	FLOAT
	|
	STRING
	|
	IDENTIFIER
	|
	IDENTIFIER LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
	|
	TRUE
	|
	FALSE
	|
	NULL_CHAR
	|
	LEFT_BRACKET expression RIGHT_BRACKET
	|
	function_call
	;

function_call:
	IDENTIFIER LEFT_BRACKET arguments RIGHT_BRACKET
	;

arguments:
	expression
	|
	arguments COMMA expression

%%
