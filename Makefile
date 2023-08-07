SRC = "src"
BUILD = "build"
TEST = "test"

SRC_FILES = ${BUILD}/george_parse.tab.h ${BUILD}/george_parse.tab.c ${BUILD}/lex.yy.c \
			${SRC}/Record.hpp ${SRC}/Record.cpp ${SRC}/SymbolTable.hpp ${SRC}/SymbolTable.cpp \
			${SRC}/george.h ${SRC}/george.c
OBJ_FILES = ${BUILD}/george.o ${BUILD}/lex.yy.o ${BUILD}/george_parse.tab.o ${BUILD}/SymbolTable.o ${BUILD}/Record.o

all: clean generate_source compile link

clean:
	rm -f -r ${BUILD}

generate_source:
ifeq (,$(wildcard ${BUILD}))
	mkdir ${BUILD}
endif
	flex -d ${SRC}/george_lex.l
	bison -d ${SRC}/george_parse.y -Wcounterexamples
	mv *.tab.* ${BUILD}
	mv *.yy.c ${BUILD}

compile:
	g++ -c ${SRC_FILES}
	mv *.o ${BUILD}

link:
	g++ -g ${OBJ_FILES} -o ${BUILD}/george