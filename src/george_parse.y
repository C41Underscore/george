
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
extern struct ast_node *tree_root;

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
	#ifdef YYDEBUG
		yydebug = 1;
	#endif
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
%type <node> functions function function_decl
%type <node> parameter_list parameter statements statement
%type <node> variable_declaration for for_conditions for_var_init for_loop_stmts
%type <node> do while if if_block else scope return bracketed_relational_expression
%type <node> expression assignment_expression relational_expression arithmetic_expression
%type <node> term factor operand function_call arguments

%define parse.error verbose

%union
{
	struct token *tok;
	struct ast_node *node;
}

%%

program:
	import_list functions {$$ = create_node(NULL); add_node($$, $1, $2); set_tree_root($$);}
	;

import_list:
	import_statement SEMICOLON {$$ = $1;}
	|
	import_statement SEMICOLON import_list {$$ = create_node(NULL); add_node($$, $1, $3);}
	;

import_statement:
	IMPORT IDENTIFIER {$$ = create_node(NULL); add_node($$, create_node($1), create_node($2));}
	|
	FROM IDENTIFIER IMPORT identifier_list {$$ = create_node($2); add_node($$, $4, NULL);}
	;

identifier_list:
	IDENTIFIER {$$ = create_node($1);}
	|
	IDENTIFIER COMMA identifier_list {$$ = create_node($1); add_node($$, $3, NULL);}
	;

functions:
	function {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	function functions {$$ = create_node(NULL); add_node($$, $1, $2);}
	;

function:
	function_decl scope {$$ = create_node(NULL); add_node($$, $1, NULL);}
	;

function_decl:
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET RIGHT_BRACKET {$$ = create_node($2); add_node($$, create_node($1), NULL);}
	|
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET parameter_list RIGHT_BRACKET {$$ = create_node($2); add_node($$, create_node($1), $5);}
	;

parameter_list:
	parameter {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	parameter_list COMMA parameter {$$ = create_node(NULL); add_node($$, $3, $1);}
	;

parameter:
	TYPE IDENTIFIER {$$ = create_node(NULL); add_node($$, create_node($1), create_node($2));}
	;

statements:
	statement {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	statement statements {$$ = create_node(NULL); add_node($$, $1, $2);}
	;

statement:
	variable_declaration SEMICOLON {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	for {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	do SEMICOLON {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	while {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	if {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	return SEMICOLON {$$ = create_node(NULL); add_node($$, $1, NULL);}
	|
	expression SEMICOLON {$$ = create_node(NULL); add_node($$, $1, NULL);}
	;

variable_declaration:
	TYPE IDENTIFIER EQUAL expression {$$ = create_node($2); add_node($$, create_node($1), create_node($3)); add_node($$->right, $4, NULL);}
	|
	TYPE IDENTIFIER {$$ = create_node(NULL); add_node($$, create_node($1), create_node($2));}
	;

for:
	FOR for_conditions scope {$$ = create_node($1); add_node($$, $2, $3);}
	;

for_conditions:
	LEFT_BRACKET for_var_init for_loop_stmts RIGHT_BRACKET {$$ = create_node(NULL); add_node($$, $2, $3);}
	;

for_var_init:
	variable_declaration SEMICOLON {$$ = $1;}
	|
	SEMICOLON {$$ = create_node(NULL);}
	;

for_loop_stmts:
	relational_expression SEMICOLON expression {$$ = create_node(NULL); add_node($$, $1, $3); }
	|
	relational_expression SEMICOLON {$$ = $1;}
	|
	SEMICOLON expression {$$ = $2;}
	|
	SEMICOLON {$$ = create_node(NULL);}
	;

do:
	DO scope WHILE bracketed_relational_expression {$$ = create_node($1); add_node($$, $2, $4);}
	;

while:
	WHILE bracketed_relational_expression scope {$$ = create_node($1); add_node($$, $2, $3);}
	;

if:
	IF bracketed_relational_expression if_block {$$ = create_node($1); add_node($$, $2, $3);}
	;

if_block:
	scope else {$$ = create_node(NULL); add_node($$, $1, $2);}
	;

else:
	/* empty */ {$$ = create_node(NULL);}
	|
	ELSE statement {$$ = create_node($1); add_node($$, $2, NULL);}
	|
	ELSE scope {$$ = create_node($1); add_node($$, $2, NULL);}
	;

scope:
	LEFT_SCOPE_BRACKET statements RIGHT_SCOPE_BRACKET {$$ = $2;}
	;

return:
	RETURN expression {$$ = create_node($1); add_node($$, $2, NULL);}
	;

bracketed_relational_expression:
	LEFT_BRACKET relational_expression RIGHT_BRACKET {$$ = $2;}
	;

expression:
	assignment_expression EQUAL expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	assignment_expression {$$ = $1;}
	;

assignment_expression:
	relational_expression AND assignment_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	relational_expression OR assignment_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	relational_expression {$$ = $1;}
	;

relational_expression:
	arithmetic_expression EQ relational_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	arithmetic_expression LT relational_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	arithmetic_expression GT relational_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	arithmetic_expression LTQ relational_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	arithmetic_expression GTQ relational_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	arithmetic_expression {$$ = $1;}
	;

arithmetic_expression:
	term PLUS arithmetic_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	term MINUS arithmetic_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	term PLUS_INLINE arithmetic_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	term MINUS_INLINE arithmetic_expression {$$ = create_node($2); add_node($$, $1, $3);}
	|
	term {$$ = $1;}
	;

term:
	factor MULTIPLY term {$$ = create_node($2); add_node($$, $1, $3);}
	|
	factor DIVIDE term {$$ = create_node($2); add_node($$, $1, $3);}
	|
	factor MULTIPLY_INLINE term {$$ = create_node($2); add_node($$, $1, $3);}
	|
	factor DIVIDE_INLINE term {$$ = create_node($2); add_node($$, $1, $3);}
	|
	factor {$$ = $1;}
	;

factor:
	MINUS operand  {$$ = create_node($1); add_node($$, $2, NULL);}
	|
	NOT operand {$$ = create_node($1); add_node($$, $2, NULL);}
	|
	operand {$$ = $1;}
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
	IDENTIFIER LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET {$$ = create_node($2); add_node($$, create_node($1), $3);}
	|
	TRUE {$$ = create_node($1);}
	|
	FALSE {$$ = create_node($1);}
	|
	NULL_CHAR {$$ = create_node($1);}
	|
	LEFT_BRACKET expression RIGHT_BRACKET {$$ = $2;}
	|
	function_call {$$ = $1;}
	;

function_call:
	IDENTIFIER LEFT_BRACKET arguments RIGHT_BRACKET {$$ = create_node(NULL); add_node($$, create_node($1), $3);}
	;

arguments:
	expression {$$ = $1;}
	|
	expression COMMA arguments {$$ = create_node(NULL); add_node($$, $1, $3);}

%%
