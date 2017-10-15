

    .text

# BEGIN FUNCTION: fib() ------------------------------------------------
#
# Function type: function(int)->int

fib:
  pushl %ebp                        # Save old frame pointer
  movl %esp, %ebp                   # Set new frame pointer
  subl $4, %esp                     # Allocate space for local+temp vars
  leal fib_count, %edx              # Get address of fib_count
  addl $1, (%edx)                   # Perform assignment '+='
  movl (%edx), %ecx                 # Copy assignment result to register

  # IF statment - begin

  movl 8(%ebp), %ecx                # Get value of i
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

  movl 8(%ebp), %ecx                # Get value of i
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

  # FUNCTION CALL to fib() - begin

  movl 8(%ebp), %ecx                # Get value of i
  subl $1, %ecx                     # Perform '-'
  pushl %ecx                        # Push arg 1
  call fib                          # Call fib()
  addl $4, %esp                     # Deallocate argument stack

  # FUNCTION CALL to fib() - end


  # FUNCTION CALL to fib() - begin

  movl %eax, -4(%ebp)               # Save caller-save register to temp
  movl 8(%ebp), %eax                # Get value of i
  subl $2, %eax                     # Perform '-'
  pushl %eax                        # Push arg 1
  call fib                          # Call fib()
  addl $4, %esp                     # Deallocate argument stack

  # FUNCTION CALL to fib() - end

  movl -4(%ebp), %ecx               # Stack machine: copy temp to register
  addl %eax, %ecx                   # Perform '+'
  movl %ecx, %eax                   # Set return value
  jmp .L0_function_end              # Exit function

  # IF statment - ELSE clause - end

.L3_done:

  # IF statment - end


  # IF statment - ELSE clause - end

.L1_done:

  # IF statment - end

.L0_function_end:
  movl %ebp, %esp                   # Deallocate stack frame
  popl %ebp                         # Restore old stack frame
  ret


# END FUNCTION: fib() --------------------------------------------------


# BEGIN FUNCTION: show_fib() -------------------------------------------
#
# Function type: function(int)->int

show_fib:
  pushl %ebp                        # Save old frame pointer
  movl %esp, %ebp                   # Set new frame pointer

  # FUNCTION CALL to printf() - begin


  # FUNCTION CALL to fib() - begin

  movl 8(%ebp), %edx                # Get value of i
  pushl %edx                        # Push arg 1
  call fib                          # Call fib()
  addl $4, %esp                     # Deallocate argument stack

  # FUNCTION CALL to fib() - end

  pushl %eax                        # Push arg 3
  movl 8(%ebp), %eax                # Get value of i
  pushl %eax                        # Push arg 2
  movl $LC0, %eax                   # Get addr of string literal 'fib(%d)...'
  pushl %eax                        # Push arg 1
  call printf                       # Call printf()
  addl $12, %esp                    # Deallocate argument stack

  # FUNCTION CALL to printf() - end

  movl $0, %eax                     # Set return value
  jmp .L5_function_end              # Exit function
.L5_function_end:
  movl %ebp, %esp                   # Deallocate stack frame
  popl %ebp                         # Restore old stack frame
  ret


# END FUNCTION: show_fib() ---------------------------------------------


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
  leal fib_count, %ecx              # Get address of fib_count
  leal stuff_count, %edx            # Get address of stuff_count
  movl $0, (%edx)                   # Perform assignment '='
  movl (%edx), %eax                 # Copy assignment result to register
  movl %eax, (%ecx)                 # Perform assignment '='
  movl (%ecx), %edx                 # Copy assignment result to register

  # FUNCTION CALL to printf() - begin

  movl 12(%ebp), %edx               # Get value of argv
  movl (%edx), %ecx                 # Pointer dereference
  pushl %ecx                        # Push arg 2
  movl $LC1, %ecx                   # Get addr of string literal 'My exec...'
  pushl %ecx                        # Push arg 1
  call printf                       # Call printf()
  addl $8, %esp                     # Deallocate argument stack

  # FUNCTION CALL to printf() - end


  # FOR loop - begin

  leal -4(%ebp), %eax               # Get address of i
  movl $0, (%eax)                   # Perform assignment '='
  movl (%eax), %ecx                 # Copy assignment result to register
.L7_test:
  movl -4(%ebp), %ecx               # Get value of i
  movl 8(%ebp), %eax                # Get value of argc
  cmpl %eax, %ecx                   # Compare %ecx to %eax
  setl %cl                          # Perform '<'
  movzbl %cl, %ecx                  # Zero-extend the boolean result
  testl %ecx, %ecx                  # Test the result
  jz .L8_done                       # If result is zero, leave for loop

  # FUNCTION CALL to printf() - begin

  movl 12(%ebp), %ecx               # Get value of argv
  movl -4(%ebp), %eax               # Get value of i
  movl (%ecx,%eax,4), %edx          # Pointer array index dereference
  movl $0, %ecx                     # Load numeric constant 0
  movzbl (%edx,%ecx,1), %eax        # Pointer array index dereference
  pushl %eax                        # Push arg 5
  movl -4(%ebp), %eax               # Get value of i
  pushl %eax                        # Push arg 4
  movl 12(%ebp), %eax               # Get value of argv
  movl -4(%ebp), %edx               # Get value of i
  movl (%eax,%edx,4), %ecx          # Pointer array index dereference
  pushl %ecx                        # Push arg 3
  movl -4(%ebp), %ecx               # Get value of i
  pushl %ecx                        # Push arg 2
  movl $LC2, %ecx                   # Get addr of string literal '  argv[...'
  pushl %ecx                        # Push arg 1
  call printf                       # Call printf()
  addl $20, %esp                    # Deallocate argument stack

  # FUNCTION CALL to printf() - end


  # FUNCTION CALL to increment_stuff_count() - begin

  call increment_stuff_count        # Call increment_stuff_count()

  # FUNCTION CALL to increment_stuff_count() - end

  leal -4(%ebp), %eax               # Get address of i
  addl $1, (%eax)                   # Perform assignment '+='
  movl (%eax), %ecx                 # Copy assignment result to register
  jmp .L7_test                      # Jump to start of for loop
.L8_done:

  # FOR loop - end

  leal -4(%ebp), %ecx               # Get address of i
  movl $0, (%ecx)                   # Perform assignment '='
  movl (%ecx), %eax                 # Copy assignment result to register

  # WHILE loop - begin

.L9_test:
  movl $1, %eax                     # Load numeric constant 1
  testl %eax, %eax                  # Test the result
  jz .L10_done                      # If result is zero, leave while loop

  # FUNCTION CALL to show_fib() - begin

  movl -4(%ebp), %eax               # Get value of i
  pushl %eax                        # Push arg 1
  call show_fib                     # Call show_fib()
  addl $4, %esp                     # Deallocate argument stack

  # FUNCTION CALL to show_fib() - end

  leal -4(%ebp), %eax               # Get address of i
  addl $1, (%eax)                   # Perform assignment '+='
  movl (%eax), %ecx                 # Copy assignment result to register

  # IF statment - begin

  movl -4(%ebp), %ecx               # Get value of i
  cmpl $5, %ecx                     # Compare %ecx to $5
  setg %cl                          # Perform '>'
  movzbl %cl, %ecx                  # Zero-extend the boolean result
  testl %ecx, %ecx                  # Test the result
  jz .L12_else                      # If result is zero, jump to else clause

  # IF statment - THEN clause - begin

  jmp .L10_done                     # Loop: break statement

  # IF statment - THEN clause - end

  jmp .L11_done

  # IF statment - ELSE clause - begin

.L12_else:
  jmp .L9_test                      # Loop: continue statement

  # IF statment - ELSE clause - end

.L11_done:

  # IF statment - end

  jmp .L9_test                      # Jump to start of while loop
.L10_done:

  # WHILE loop - end

  leal stuff_count, %ecx            # Get address of stuff_count
  movl stuff_count, %eax            # Get value of stuff_count
  imull $2, %eax                    # Perform '*'
  movl %eax, (%ecx)                 # Perform assignment '='
  movl (%ecx), %edx                 # Copy assignment result to register

  # FUNCTION CALL to printf() - begin

  movl fib_count, %edx              # Get value of fib_count
  pushl %edx                        # Push arg 2
  movl $LC3, %edx                   # Get addr of string literal 'fib_cou...'
  pushl %edx                        # Push arg 1
  call printf                       # Call printf()
  addl $8, %esp                     # Deallocate argument stack

  # FUNCTION CALL to printf() - end


  # FUNCTION CALL to printf() - begin

  movl stuff_count, %eax            # Get value of stuff_count
  pushl %eax                        # Push arg 2
  movl $LC4, %eax                   # Get addr of string literal 'stuff_c...'
  pushl %eax                        # Push arg 1
  call printf                       # Call printf()
  addl $8, %esp                     # Deallocate argument stack

  # FUNCTION CALL to printf() - end

  movl $0, %eax                     # Set return value
  jmp .L6_function_end              # Exit function
.L6_function_end:
  movl %ebp, %esp                   # Deallocate stack frame
  popl %ebp                         # Restore old stack frame
  ret


# END FUNCTION: main() -------------------------------------------------

.global_vars:
  .comm fib_count,16

LC0:
  .ascii "fib(%d) is %d.\12\0"
LC1:
  .ascii "My executable name is %s.\12\0"
LC2:
  .ascii "  argv[%d] is: %s    argv[%d][0] is: %c\12\0"
LC3:
  .ascii "fib_count is %d.\12\0"
LC4:
  .ascii "stuff_count is %d.\12\0"

