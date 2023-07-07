
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

void main(int argc, char *argv[])
{
	//  Process inputs before starting compiler
	george(0, NULL, argc - 1, argv);
	exit(0);
}

#ifdef __cplusplus
}
#endif

%}

%token FUNCTION RETURN DO WHILE FOR IF ELSE IMPORT FROM TRUE FALSE NULL_CHAR
%token IDENTIFIER
%token TYPE INTEGER FLOAT CHAR STRING
%token SEMICOLON COLON COMMA NEWLINE
%token LEFT_BRACKET RIGHT_BRACKET LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_SCOPE_BRACKET RIGHT_SCOPE_BRACKET
%token EQUAL PLUS MINUS DIVIDE MULTIPLY
%token PLUS_INLINE MINUS_INLINE DIVIDE_INLINE MULTIPLY_INLINE
%token EQ LT LTQ GT GTQ
%token AND OR NOT

%type <tok> FUNCTION RETURN DO WHILE FOR IF ELSE IMPORT FROM TRUE FALSE NULL_CHAR
%type <tok> IDENTIFIER
%type <tok> TYPE INTEGER FLOAT CHAR STRING
%type <tok> SEMICOLON COLON COMMA NEWLINE
%type <tok> LEFT_BRACKET RIGHT_BRACKET LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_SCOPE_BRACKET RIGHT_SCOPE_BRACKET
%type <tok> EQUAL PLUS MINUS DIVIDE MULTIPLY
%type <tok> PLUS_INLINE MINUS_INLINE DIVIDE_INLINE MULTIPLY_INLINE
%type <tok> EQ LT LTQ GT GTQ
%type <tok> AND OR NOT

%type <node> program import_list import_statement identifier_list
%type <node> functions function function_decl function_call
%type <node> operand

%define parse.error verbose

%union
{
	struct token *tok;
	struct ast_node *node;
}

%%

program:
	import_list functions {add_node(tree_root, $1, $2);}
	;

import_list:
	import_statement SEMICOLON
	|
	import_statement SEMICOLON import_list
	;

import_statement:
	IMPORT IDENTIFIER {add_node($$, create_node($1), create_node($2));}
	|
	FROM IDENTIFIER IMPORT identifier_list {$$ = create_node($2); add_node($$, $4, NULL);}
	;

identifier_list:
	IDENTIFIER {$$ = create_node($1);}
	|
	IDENTIFIER COMMA identifier_list {$$ = create_node($1); add_node($$, $3, NULL);}
	;

functions:
	function {add_node($$, $1, NULL);}
	|
	function functions {add_node($$, $1, $2);}
	;

function:
	function_decl LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET {add_node($$, $1, NULL);}
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
	if
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

if:
	IF LEFT_BRACKET relational_expression RIGHT_BRACKET LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET else
	;

else:
	/* empty */
	|
	ELSE statement
	|
	ELSE LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET

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
	INTEGER {$$ = create_node($1);}
	|
	FLOAT {$$ = create_node($1);}
	|
	STRING {$$ = create_node($1);}
	|
	IDENTIFIER {$$ = create_node($1);}
	|
	IDENTIFIER LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
	|
	TRUE {$$ = create_node($1);}
	|
	FALSE {$$ = create_node($1);}
	|
	NULL_CHAR {$$ = create_node($1);}
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
