CC = "gcc"
LEXER_CC = "flex"
PARSER_CC = "bison"

SRC = "src"
BUILD = "build"
TEST = "test"

SRC_FILES = ${BUILD}/george_parse.tab.h ${BUILD}/george_parse.tab.c ${BUILD}/lex.yy.c \
			${SRC}/george.h ${SRC}/george.c
OBJ_FILES = ${BUILD}/george.o ${BUILD}/lex.yy.o ${BUILD}/george_parse.tab.o

all: clean generate_source compile link

clean:
	rm -f -r ${BUILD}

generate_source:
ifeq (,$(wildcard ${BUILD}))
	mkdir ${BUILD}
endif
	${LEXER_CC} -d ${SRC}/george_lex.l
	${PARSER_CC} -d ${SRC}/george_parse.y -Wcounterexamples
	mv *.tab.* ${BUILD}
	mv *.yy.c ${BUILD}

compile:
	${CC} -c ${SRC_FILES}
	mv *.o ${BUILD}

link:
	${CC} -g ${OBJ_FILES} -o ${BUILD}/george