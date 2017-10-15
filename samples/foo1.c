
/* Prototypes for some standard C library functions (the code
   calls these directly). */
extern int printf(char *str, ...);


/* Test of extern variable.  How many times we've called
   a printf() function. */
extern int stuff_count;

/* Increments this global variable. */
extern int increment_stuff_count();

/* Test of global variable.  How many times we've called
   the fib() function. */
int fib_count;

/* fibonacci function: Test of basic branching and recursion. */
static int fib(int i)
{
  fib_count += 1;
  if (i == 1) {
    return 1;
  } else {
    if (i == 0) {
      return 0;
    } else {
      return fib(i-1) + fib(i-2);
    }
  }
}

/* Just a wrapper to easily show the results of a
   call to fib(). */
static int show_fib(int i)
{
  printf("fib(%d) is %d.\n", i, fib(i));
  return 0;
}


/* Main program that runs the tests. */
int main(int argc, char **argv) {
  char c;
  int i;

  c = 'h';

  /* Test of multiple assignment. */
  fib_count = stuff_count = 0;

  /* Test of command-line argument passing, pointer
     indirection/array indexing, for looping. */
  printf("My executable name is %s.\n", *argv);
  for (i = 0; i < argc; i += 1) {
    printf("  argv[%d] is: %s    "
           "argv[%d][0] is: %c\n", i, argv[i], i, argv[i][0]);
    increment_stuff_count();
  }

  /* Test of while looping with break/continue. */
  i = 0;
  while (1) {
    show_fib(i);
    i += 1;
    if (i > 5)
      break;
    else
      continue;
  }
  stuff_count = stuff_count * 2;

  printf("fib_count is %d.\n", fib_count);
  printf("stuff_count is %d.\n", stuff_count);

  


  
 
  return 0;
}
