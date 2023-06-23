
%{
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h>
#include <string.h>

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
	source = fopen("test.george", "r");
	yyin = source;
	do
	{
		yyparse();
	} while(!feof(yyin));

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
	import_list functions
	;

import_list:
	/* empty */
	|
	import_statement import_list
	;

import_statement:
	IMPORT IDENTIFIER
	|
	FROM IDENTIFIER IMPORT identifier_list

identifier_list:
	IDENTIFIER
	|
	IDENTIFIER COMMA identifier_list

functions:
	function
	|
	function functions

function:
	function_decl COLON NEWLINE statements

function_decl:
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET parameter_list RIGHT_BRACKET

parameter_list:
	/* empty */
	|
	parameter
	|
	parameter COMMA parameter_list

parameter:
	TYPE IDENTIFIER

statements:
	statement
	|
	statement NEWLINE statements
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
	FOR LEFT_BRACKET SEMICOLON SEMICOLON RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON RIGHT_BRACKET COLON NEWLINE LEFT_SCOPE_BRACKET
	statements RIGHT_SCOPE_BRACKET
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON relational_expression
	SEMICOLON RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON relational_expression
	SEMICOLON expression RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET SEMICOLON relational_expression
	SEMICOLON expression RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET SEMICOLON SEMICOLON expression RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET SEMICOLON relational_expression SEMICOLON RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON expression RIGHT_BRACKET COLON NEWLINE statements
	;

do:
	DO COLON NEWLINE statements NEWLINE WHILE LEFT_BRACKET relational_expression RIGHT_BRACKET
	;

while:
	WHILE LEFT_BRACKET relational_expression RIGHT_BRACKET COLON NEWLINE statements
	;

return:
	RETURN expression
	;

expression:
	relational_expression AND expression
	|
	relational_expression OR expression
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
