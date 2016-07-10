dir_inc = ./src
dir_src = ./src
dir_build = ./build
dir_test = ./test

$(shell mkdir -p $(dir_build))

.PHONY: psil

psil:
	bison -d $(dir_src)/testyac.y -o $(dir_src)/testyac.tab.c
	flex -o $(dir_src)/testlex.yy.c $(dir_src)/testlex.l
	g++ $(dir_src)/testyac.tab.c $(dir_src)/testlex.yy.c $(dir_src)/testmain.cpp -ll -o $(dir_build)/psil

clean :
	rm -r $(dir_build)
