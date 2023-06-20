%{
#include <stdio.h>
#include <string.h>
#include "george_parse.h"
%}
%%
function                      return FUNCTION
return                        return RETURN
do                            return DO
while                         return WHILE
for                           return FOR

[_a-zA-Z]+[_a-zA-Z0-9]*       return IDENTIFIER

int|float|char                return TYPE
[0-9]+                        return INTEGER
[0-9]+.[0-9]*|[0-9]*.[0-9]+   return FLOAT
'[a-zA-Z]'                    return CHAR

;                             return SEMICOLON
(                             return LEFT_BRACKET
)                             return RIGHT_BRACKET
:                             return COLON
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
%%