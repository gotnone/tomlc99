HFILES = toml.h
CFILES = toml.c
OBJ = $(CFILES:.c=.o) 
EXEC = toml_json toml_cat
INCLUDE_DIR = include

CFLAGS = -std=c99 -Wall -Wextra -fpic -I$(INCLUDE_DIR)
LIB = libtoml.a
LIB_SHARED = libtoml.so

# to compile for debug: make DEBUG=1
# to compile for no debug: make
ifdef DEBUG
    CFLAGS += -O0 -g
else
    CFLAGS += -O2 -DNDEBUG
endif


all: $(LIB) $(LIB_SHARED) $(EXEC)

*.o: $(HFILES)

libtoml.a: src/toml.o
	ar -rcs $@ $^

libtoml.so: src/toml.o
	$(CC) -shared -o $@ $^

toml_json: src/toml_json.c $(LIB)

toml_cat: src/toml_cat.c $(LIB)

prefix ?= /usr/local

install: all
	install -d ${prefix}/include/tomlc99 ${prefix}/lib
	install include/tomlc99/toml.h ${prefix}/include/tomlc99
	install $(LIB) ${prefix}/lib
	install $(LIB_SHARED) ${prefix}/lib

clean:
	rm -f *.o $(EXEC) $(LIB) $(LIB_SHARED)
