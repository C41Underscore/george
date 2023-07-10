SRC = "src"
BUILD = "build"
TEST = "test"

all: generate_source compile link

clean:
	rm *.tab.c *.tab.h.gch *.yy.c *.yy.o *.tab.h *.tab.o

generate_source:
	flex -d ${SRC}/george_lex.l
	bison -d ${SRC}/george_parse.y -Wcounterexamples
	mv *.tab.* ${BUILD}
	mv *.yy.c ${BUILD}

compile:
	gcc -g -c ${BUILD}/george_parse.tab.h ${BUILD}/george_parse.tab.c ${SRC}/george.h ${SRC}/george.c ${BUILD}/lex.yy.c
	mv *.o ${BUILD}

link:
	gcc -g ${BUILD}/george.o ${BUILD}/lex.yy.o ${BUILD}/george_parse.tab.o -o ${BUILD}/george