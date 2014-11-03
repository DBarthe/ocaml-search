OCAMLMAKEFILE = OCamlMakefile

RESULT = libsearch
SOURCES = src/search.mli src/search.ml
  
CREATE_LIB = yes

INCDIRS = lib/OCaml-Lib/
LIBDIRS = lib/OCaml-Lib/

LIBS = libmy

OCAMLDOCFLAGS = -charset utf-8

all: libmy bcl

tests: all
	make -C test/
	./test/test
	make clean -C test/

libmy:
	make -C lib/OCaml-Lib/

realclean: clean
	make clean -C lib/OCaml-Lib/

include $(OCAMLMAKEFILE)

