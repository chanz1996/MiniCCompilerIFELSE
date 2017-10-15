extern int printf(char *str, ...);
extern char *malloc(int size);
extern int free(char *ptr);
extern int stuff_count;
extern int increment_stuff_count();
int fib_count;
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

static int show_fib(int i)
{
  printf("fib(%d) is %d.\n", i, fib(i));
  return 0;
}

static int set_a(char *c)
{
  *c = 'a';
  return 0;
}
static char *get_literal()
{
  return "blah\n";
}

int main(int argc, char **argv) {
  char c;
  int i;

  c = 'h';

 
  fib_count = stuff_count = 0;

  printf("My executable name is %s.\n", *argv);
  for (i = 0; i < argc; i += 1) {
    printf("  argv[%d] is: %s    "
           "argv[%d][0] is: %c\n", i, argv[i], i, argv[i][0]);
    increment_stuff_count();
  }
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

  printf("before set_a(&c), c == '%c'\n", c);

  set_a(&c);

  {
    int a;
    char b;
    int c;

        
    a = -1;


    b = a;

    c = b;

    printf("  a = %d\n", a);
    printf("  b = %d\n", b);
    printf("  c = %d\n", c);
  }

  printf("after set_a(&c), c == '%c'\n", c);

  printf("get_literal() = %s\n", get_literal());

  printf("get_literal()[3] = %c\n", get_literal()[3]);

  {
  
    char *c;

    c = malloc(30);
    c[0] = 'h';
    c[1] = 'i';
    c[2] = 0;
    printf("array-built string is: %s\n", c);
    free(c);
  }
  return 0;
}
