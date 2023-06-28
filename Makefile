SRC = "src"
BUILD = "build"
TEST = "test"

all: generate_source compile link

clean:
	rm *.tab.c *.tab.h.gch *.yy.c *.yy.o *.tab.h *.tab.o

generate_source:
	flex -d ${SRC}/george_lex.l
	bison -d ${SRC}/george_parse.y
	mv *.tab.* ${BUILD}
	mv *.yy.c ${BUILD}

compile:
	gcc -c ${SRC}/george.h ${BUILD}/george_parse.tab.c ${BUILD}/george_parse.tab.h ${BUILD}/lex.yy.c
	mv *.o ${BUILD}

link:
	gcc ${BUILD}/george_parse.tab.o ${BUILD}/lex.yy.o -o ${BUILD}/george