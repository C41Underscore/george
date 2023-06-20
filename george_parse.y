
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

%token FUNCTION RETURN DO WHILE FOR
%token IDENTIFIER
%token TYPE INTEGER FLOAT CHAR
%token SEMICOLON LEFT_BRACKET RIGHT_BRACKET NEWLINE
%token EQUAL PLUS MINUS DIVIDE MULTIPLY
%token PLUS_INLINE MINUS_INLINE DIVIDE_INLINE MULTIPLY_INLINE
%token EQ LT LTQ GT GTQ

%%

line:
	statement
	|
        declaration
        ;

statement:
	expression
	|
	control
	;

statements:
	statement
	|
	statement statements
	;

declaration:
	variable_decl
	|
	function_decl
	;

variable_decl:
	TYPE IDENTIFIER
	|
	TYPE IDENTIFIER EQUALS
	;

function_decl:
	FUNCTION TYPE IDENTIFIER LEFT_BRACKET RIGHT_BRACKET COLON NEWLINE statement

control:
	for
	|
	while
	|
	do
	;

for:
	FOR LEFT_BRACKET variable_decl SEMICOLON SEMICOLON RIGHT_BRACKET COLON NEWLINE

%%
