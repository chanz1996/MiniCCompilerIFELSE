

    .text

# BEGIN FUNCTION: main() -----------------------------------------------
#
# Function type: function()->int

    .global main
main:
  pushl %ebp                        # Save old frame pointer
  movl %esp, %ebp                   # Set new frame pointer
  subl $4, %esp                     # Allocate space for local+temp vars
  leal -4(%ebp), %edx               # Get address of i
  movl $1, (%edx)                   # Perform assignment '='
  movl (%edx), %ecx                 # Copy assignment result to register

  # IF statment - begin

  movl -4(%ebp), %ecx               # Get value of i
  cmpl $1, %ecx                     # Compare %ecx to $1
  sete %cl                          # Perform '=='
  movzbl %cl, %ecx                  # Zero-extend the boolean result
  testl %ecx, %ecx                  # Test the result
  jz .L2_else                       # If result is zero, jump to else clause

  # IF statment - THEN clause - begin

  movl $1, %eax                     # Set return value
  jmp .L0_function_end              # Exit function

  # IF statment - THEN clause - end

  jmp .L1_done

  # IF statment - ELSE clause - begin

.L2_else:

  # IF statment - begin

  movl -4(%ebp), %ecx               # Get value of i
  cmpl $0, %ecx                     # Compare %ecx to $0
  sete %cl                          # Perform '=='
  movzbl %cl, %ecx                  # Zero-extend the boolean result
  testl %ecx, %ecx                  # Test the result
  jz .L4_else                       # If result is zero, jump to else clause

  # IF statment - THEN clause - begin

  movl $0, %eax                     # Set return value
  jmp .L0_function_end              # Exit function

  # IF statment - THEN clause - end

  jmp .L3_done

  # IF statment - ELSE clause - begin

.L4_else:

  # FUNCTION CALL to printf() - begin

  movl $LC0, %ecx                   # Get addr of string literal 'hi'
  pushl %ecx                        # Push arg 1
  call printf                       # Call printf()
  addl $4, %esp                     # Deallocate argument stack

  # FUNCTION CALL to printf() - end


  # IF statment - ELSE clause - end

.L3_done:

  # IF statment - end


  # IF statment - ELSE clause - end

.L1_done:

  # IF statment - end

  movl $0, %eax                     # Set return value
  jmp .L0_function_end              # Exit function
.L0_function_end:
  movl %ebp, %esp                   # Deallocate stack frame
  popl %ebp                         # Restore old stack frame
  ret


# END FUNCTION: main() -------------------------------------------------

.global_vars:

LC0:
  .ascii "hi\0"

