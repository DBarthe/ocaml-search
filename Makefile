OCAMLMAKEFILE = OCamlMakefile

RESULT = libsearch
SOURCES = src/search.mli src/search.ml
  
CREATE_LIB = yes

INCDIRS = lib/OCaml-Lib/src
LIBDIRS = lib/OCaml-Lib/

LIBS = lib/OCaml-Lib/libmy

OCAMLDOCFLAGS = -charset utf-8

all: libmy bcl

tests: all
	make -C test/
	./test/test
	make clean -C test/

libmy:
	make -C lib/OCaml-Lib/ INCDIRS= LIBS=

clean-libmy:
	make clean -C lib/OCaml-Lib/ INCDIRS= LIBS=

realclean: clean clean-libmy

include $(OCAMLMAKEFILE)

