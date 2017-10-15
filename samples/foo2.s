

    .text

# BEGIN FUNCTION: main() -----------------------------------------------
#
# Function type: function(int,pointer(pointer(char)))->int

    .global main
main:
  pushl %ebp                        # Save old frame pointer
  movl %esp, %ebp                   # Set new frame pointer
  subl $8, %esp                     # Allocate space for local+temp vars
  leal -5(%ebp), %edx               # Get address of c
  movb $104, (%edx)                 # Perform assignment '='
  movzbl (%edx), %ecx               # Copy assignment result to register

  # FUNCTION CALL to printf() - begin

  movl $LC0, %ecx                   # Get addr of string literal 'hello w...'
  pushl %ecx                        # Push arg 1
  call printf                       # Call printf()
  addl $4, %esp                     # Deallocate argument stack

  # FUNCTION CALL to printf() - end

  movl $0, %eax                     # Set return value
  jmp .L0_function_end              # Exit function
.L0_function_end:
  movl %ebp, %esp                   # Deallocate stack frame
  popl %ebp                         # Restore old stack frame
  ret


# END FUNCTION: main() -------------------------------------------------

.global_vars:

LC0:
  .ascii "hello world\0"

