dir_inc = ./src
dir_src = ./src
dir_build = ./build
dir_test = ./test

$(shell mkdir -p $(dir_build))

.PHONY: psil

psil:
	bison -d $(dir_src)/yac_psil.y -o $(dir_src)/yac_psil.tab.c
	flex -o $(dir_src)/lex_psil.yy.c $(dir_src)/lex_psil.l
	g++ -g -std=c++11 $(dir_src)/yac_psil.tab.c $(dir_src)/lex_psil.yy.c $(dir_src)/psil_namespace.cpp $(dir_src)/driver_psil.cpp -ll -o $(dir_build)/psil

clean :
	rm -r $(dir_build)
