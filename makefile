
V=keyword

$V: $V.c
	gcc -Wall -O2 -o $V $V.c	

$V.c: $V.flex makefile
	flex -o $V.c $V.flex 

clean :
	@rm -rf *.o *.c *.h #$V

author: author.c
	gcc -Wall -O2 -o author author.c	

author.c: author.flex makefile
	flex -o author.c author.flex 

counter: counter.c
	gcc -Wall -O2 -o counter counter.c	

counter.c: counter.flex makefile
	flex -o counter.c counter.flex 

tohtml: tohtml.c
	gcc -Wall -O2 -o tohtml tohtml.c	

tohtml.c: tohtml.flex makefile
	flex -o tohtml.c tohtml.flex

tohtml_2: tohtml_2.c
	gcc -Wall -O2 -o tohtml_2 tohtml_2.c

tohtml_2.c: tohtml_2.flex makefile
	flex -o tohtml_2.c tohtml_2.flex
