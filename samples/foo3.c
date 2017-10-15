
/* Prototypes for some standard C library functions (the code
   calls these directly). */
extern int printf(char *str, ...);


/* Main program that runs the tests.Nested if-else */
int main() {
  
  int i;
  i = 1;
  if (i == 1) {
    return 1;
  } else {
    if (i == 0) {
      return 0;
    } else {
      printf("hi");
    }
  }
  return 0;

    }


