
%{
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "../src/george.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;
extern int yy_flex_debug;

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\nline number: %d\n",str, yylineno);
}

int yywrap()
{
        return 1;
}

int george(int numSourceFiles, char *sourceFiles[])
{
	yy_flex_debug = 0;

	FILE *source; int i;
	source = fopen(sourceFiles[1], "r");

	if(source == NULL)
	{
		yyerror("Invalid source file");
		exit(0);
	}

	yyin = source;

	do
	{
		yyparse();
	} while(!feof(yyin));

	fclose(source);
}

void main(int argc, char *argv[])
{
	george(argc, argv);
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

//%define parse.error verbose

%union
{
	struct token *tok;
}

%%

program:
	import_list functions
	;

import_list:
	import_statement SEMICOLON
	|
	import_list SEMICOLON import_statement
	;

import_statement:
	IMPORT IDENTIFIER
	|
	FROM IDENTIFIER IMPORT identifier_list
	;

identifier_list:
	IDENTIFIER
	|
	identifier_list COMMA IDENTIFIER
	;

functions:
	function
	|
	functions function
	;

function:
	function_decl LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	;

function_decl:
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET RIGHT_BRACKET
	|
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET parameter_list RIGHT_BRACKET
	;

parameter_list:
	parameter
	|
	parameter_list COMMA parameter
	;

parameter:
	TYPE IDENTIFIER
	;

statements:
	statement
	|
	statement statements
	;

statement:
	variable_declaration SEMICOLON
	|
	for
	|
	do SEMICOLON
	|
	while
	|
	return SEMICOLON
	|
	expression SEMICOLON
	;

variable_declaration:
	TYPE IDENTIFIER EQUAL expression
	|
	TYPE IDENTIFIER
	;

for:
	FOR LEFT_BRACKET SEMICOLON SEMICOLON RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON RIGHT_BRACKET LEFT_SCOPE_BRACKET
	statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON relational_expression
	SEMICOLON RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON relational_expression
	SEMICOLON expression RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET SEMICOLON relational_expression
	SEMICOLON expression RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET SEMICOLON SEMICOLON expression RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET SEMICOLON relational_expression SEMICOLON RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON expression RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	;

do:
	DO LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET WHILE LEFT_BRACKET relational_expression RIGHT_BRACKET
	;

while:
	WHILE LEFT_BRACKET relational_expression RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET
	;

return:
	RETURN expression
	;

expression:
	assignment_expression AND expression
	|
	assignment_expression OR expression
	|
	assignment_expression
	;

assignment_expression:
	IDENTIFIER EQUAL relational_expression
	|
	relational_expression
	;

relational_expression:
	arithmetic_expression EQ relational_expression
	|
	arithmetic_expression LT relational_expression
	|
	arithmetic_expression GT relational_expression
	|
	arithmetic_expression LTQ relational_expression
	|
	arithmetic_expression GTQ relational_expression
	|
	arithmetic_expression
	;

arithmetic_expression:
	term PLUS arithmetic_expression
	|
	term MINUS arithmetic_expression
	|
	term PLUS_INLINE arithmetic_expression
	|
	term MINUS_INLINE arithmetic_expression
	|
	term
	;

term:
	factor MULTIPLY term
	|
	factor DIVIDE term
	|
	factor MULTIPLY_INLINE term
	|
	factor DIVIDE_INLINE term
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
	expression COMMA arguments

%%
