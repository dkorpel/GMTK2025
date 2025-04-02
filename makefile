# Cheat sheet: (http://eduardolezcano.com/wp-content/uploads/2016/06/make_cheatsheet.pdf)
# %   wildcard, replaced with the same string that was used to perform substitution
# $@  to represent the full target name of the current target
# $?  returns the dependencies that are newer than the current target
# $*  returns the text that corresponds to % in the target
# $<  returns the name of the first dependency
# $^  returns the names of all the dependencies with space as the delimiter
# -   command prefix to ignore errors
# @   command prefix to suppress stdout of commands

.PHONY: all, run

all:
	dmd -i -Isource source/sdl3.c source/app.d -od=build -of=build/game

run: all
	./build/game
