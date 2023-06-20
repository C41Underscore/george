cmake_minimum_required(VERSION 3.25)
project(george C)

set(CMAKE_C_STANDARD 11)

set(SRC_DIR "./")
set(PARSER_DIR "${CMAKE_CURRENT_BINARY_DIR}")


find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

set(LEXER_OUT "${PARSER_DIR}/george_lex.c")
set(PARSER_OUT "${PARSER_DIR}/george_parse.c")

flex_target(LEXER "george_lex.l" "${LEXER_OUT}")
bison_target(PARSER "george_parse.y" "${PARSER_OUT}")
add_flex_bison_dependency(LEXER PARSER)

add_executable(george "${LEXER_OUT}" "${PARSER_OUT}")
