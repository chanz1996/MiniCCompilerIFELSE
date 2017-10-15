

FLAGS=-annotate -ast
PYTHON=python

compile-samples:
	${PYTHON} c.py samples/foo.c samples/foo_lib.c ${FLAGS}
	gcc samples/foo.s samples/foo_lib.s -o samples/foo

clean:
	rm -f parsetab.py parser.out *.pyc samples/*.ast \
              samples/*.s samples/*.exe samples/foo
