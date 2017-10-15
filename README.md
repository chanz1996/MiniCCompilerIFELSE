# MiniCCompilerIFELSE
This is a compiler for a subset of the C programming language.(For IF-ELSE Construct)

The lexer and parser were constructed using Dave Beazley's PLY (Python
Lex-Yacc), an open-source Python implementation of GNU
lex/yacc. Stages of compilation (symbol tree generation, type
checking, flow control checking, etc) are performed using an
object-oriented design pattern called a visitor (GoF 1995). The output
is annotated Intel 80x86 assembly, suitable for translation to machine
language using the GNU Assembler (GAS).

USING THE COMPILER
---------------------------------------------------------------

The syntax for using the mini-c compiler is as follows:

    c.py <source-file-1> [[source-file-2] ...] [-ast] [-annotate]

Source files are the C files you want to compile into assembly (.s
files).

The '-ast' option generates a file with extension .ast that is a
printout of the abstract syntax tree for the source file, after
all stages of compilation occur.

The '-annotate' option generates annotated assembly.  That is,
assembly is generated with comments describing what each instruction
does, its relevance to the original C source code, and so forth.
Additional comments are inserted to delimit functions, control
structures, and so forth.
