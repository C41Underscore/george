
%{
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yyparse();

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
        yyparse();
}

#ifdef __cplusplus
}
#endif

%}

%token FUNCTION RETURN DO WHILE FOR IMPORT FROM
%token IDENTIFIER
%token TYPE INTEGER FLOAT CHAR
%token SEMICOLON LEFT_BRACKET RIGHT_BRACKET NEWLINE
%token EQUAL PLUS MINUS DIVIDE MULTIPLY
%token PLUS_INLINE MINUS_INLINE DIVIDE_INLINE MULTIPLY_INLINE
%token EQ LT LTQ GT GTQ

%%

program:
	import_list functions
	;

import_list:
	/* empty */
	|
	import_statement import_list
	;

import_statment:
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

line:
	statement
	|
        declaration
        ;

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
	TYPE IDENTIFIER EQUALS expression
	|
	TYPE IDENTIFIER
	;

for:
	FOR LEFT_BRACKET SEMICOLON SEMICOLON RIGHT_BRACKET COLON NEWLINE statements
	|
	FOR LEFT_BRACKET variable_declaration SEMICOLON SEMICOLON RIGHT_BRACKET COLON NEWLINE statements
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

expression_list:
	expression
	|
	expression NEWLINE expression_list
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
	IDENTIFIER
	|
	IDENTIFIER LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
	|
	TRUE
	|
	FALSE
	|
	NULL
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
