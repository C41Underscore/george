%{
#include <stdio.h>
#include <string.h>
#include "george_parse.h"
%}
%%
\t                            return TAB

function                      return FUNCTION
return                        return RETURN
do                            return DO
while                         return WHILE
for                           return FOR
import                        return IMPORT
from                          return FROM
true                          return TRUE
false                         return FALSE
null                          return NULL

[_a-zA-Z]+[_a-zA-Z0-9]*       return IDENTIFIER

int|float|char|void           return TYPE
[0-9]+                        return INTEGER
[0-9]+.[0-9]*|[0-9]*.[0-9]+   return FLOAT
'[a-zA-Z]'                    return CHAR
"(.*?)"                       return STRING

;                             return SEMICOLON
(                             return LEFT_BRACKET
)                             return RIGHT_BRACKET
[                             return LEFT_SQUARE_BRACKET
]                             return RIGHT_SQUARE_BRACKET
:                             return COLON
,                             return COMMA
\n                            return NEWLINE

=                             return EQUAL
+                             return PLUS
-                             return MINUS
/                             return DIVIDE
*                             return MULTIPLY
-=                            return MINUS_INLINE
+=                            return PLUS_INLINE
/=                            return DIVIDE_INLINE
*=                            return MULTIPLY_INLINE

==                            return EQ
<                             return LT
<=                            return LTQ
>                             return GT
=>                            return GTQ

and                           return AND
or                            return OR
not                           return NOT
%%