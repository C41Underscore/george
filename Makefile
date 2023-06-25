all: compile clean

clean:
	rm *.tab.c *.tab.h.gch *.yy.c *.yy.o *.tab.h *.tab.o

compile:
	flex -d george_lex.l
	bison -d george_parse.y
	gcc -c george_parse.tab.c george_parse.tab.h lex.yy.c
	gcc george_parse.tab.o lex.yy.o -o george