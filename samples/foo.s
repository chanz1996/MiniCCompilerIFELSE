
    .text
fib:
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp
  leal fib_count, %edx
  addl $1, (%edx)
  movl (%edx), %ecx
  movl 8(%ebp), %ecx
  cmpl $1, %ecx
  sete %cl
  movzbl %cl, %ecx
  testl %ecx, %ecx
  jz .L2_else
  movl $1, %eax
  jmp .L0_function_end
  jmp .L1_done
.L2_else:
  movl 8(%ebp), %ecx
  cmpl $0, %ecx
  sete %cl
  movzbl %cl, %ecx
  testl %ecx, %ecx
  jz .L4_else
  movl $0, %eax
  jmp .L0_function_end
  jmp .L3_done
.L4_else:
  movl 8(%ebp), %ecx
  subl $1, %ecx
  pushl %ecx
  call fib
  addl $4, %esp
  movl %eax, -4(%ebp)
  movl 8(%ebp), %eax
  subl $2, %eax
  pushl %eax
  call fib
  addl $4, %esp
  movl -4(%ebp), %ecx
  addl %eax, %ecx
  movl %ecx, %eax
  jmp .L0_function_end
.L3_done:
.L1_done:
.L0_function_end:
  movl %ebp, %esp
  popl %ebp
  ret

show_fib:
  pushl %ebp
  movl %esp, %ebp
  movl 8(%ebp), %edx
  pushl %edx
  call fib
  addl $4, %esp
  pushl %eax
  movl 8(%ebp), %eax
  pushl %eax
  movl $LC0, %eax
  pushl %eax
  call printf
  addl $12, %esp
  movl $0, %eax
  jmp .L5_function_end
.L5_function_end:
  movl %ebp, %esp
  popl %ebp
  ret

set_a:
  pushl %ebp
  movl %esp, %ebp
  movl 8(%ebp), %edx
  movb $97, (%edx)
  movzbl (%edx), %ecx
  movl $0, %eax
  jmp .L6_function_end
.L6_function_end:
  movl %ebp, %esp
  popl %ebp
  ret

get_literal:
  pushl %ebp
  movl %esp, %ebp
  movl $LC1, %edx
  movl %edx, %eax
  jmp .L7_function_end
.L7_function_end:
  movl %ebp, %esp
  popl %ebp
  ret

    .global main
main:
  pushl %ebp
  movl %esp, %ebp
  subl $24, %esp
  leal -5(%ebp), %edx
  movb $104, (%edx)
  movzbl (%edx), %ecx
  leal fib_count, %ecx
  leal stuff_count, %edx
  movl $0, (%edx)
  movl (%edx), %eax
  movl %eax, (%ecx)
  movl (%ecx), %edx
  movl 12(%ebp), %edx
  movl (%edx), %ecx
  pushl %ecx
  movl $LC2, %ecx
  pushl %ecx
  call printf
  addl $8, %esp
  leal -4(%ebp), %eax
  movl $0, (%eax)
  movl (%eax), %ecx
.L9_test:
  movl -4(%ebp), %ecx
  movl 8(%ebp), %eax
  cmpl %eax, %ecx
  setl %cl
  movzbl %cl, %ecx
  testl %ecx, %ecx
  jz .L10_done
  movl 12(%ebp), %ecx
  movl -4(%ebp), %eax
  movl (%ecx,%eax,4), %edx
  movl $0, %ecx
  movzbl (%edx,%ecx,1), %eax
  pushl %eax
  movl -4(%ebp), %eax
  pushl %eax
  movl 12(%ebp), %eax
  movl -4(%ebp), %edx
  movl (%eax,%edx,4), %ecx
  pushl %ecx
  movl -4(%ebp), %ecx
  pushl %ecx
  movl $LC3, %ecx
  pushl %ecx
  call printf
  addl $20, %esp
  call increment_stuff_count
  leal -4(%ebp), %eax
  addl $1, (%eax)
  movl (%eax), %ecx
  jmp .L9_test
.L10_done:
  leal -4(%ebp), %ecx
  movl $0, (%ecx)
  movl (%ecx), %eax
.L11_test:
  movl $1, %eax
  testl %eax, %eax
  jz .L12_done
  movl -4(%ebp), %eax
  pushl %eax
  call show_fib
  addl $4, %esp
  leal -4(%ebp), %eax
  addl $1, (%eax)
  movl (%eax), %ecx
  movl -4(%ebp), %ecx
  cmpl $5, %ecx
  setg %cl
  movzbl %cl, %ecx
  testl %ecx, %ecx
  jz .L14_else
  jmp .L12_done
  jmp .L13_done
.L14_else:
  jmp .L11_test
.L13_done:
  jmp .L11_test
.L12_done:
  leal stuff_count, %ecx
  movl stuff_count, %eax
  imull $2, %eax
  movl %eax, (%ecx)
  movl (%ecx), %edx
  movl fib_count, %edx
  pushl %edx
  movl $LC4, %edx
  pushl %edx
  call printf
  addl $8, %esp
  movl stuff_count, %eax
  pushl %eax
  movl $LC5, %eax
  pushl %eax
  call printf
  addl $8, %esp
  movzbl -5(%ebp), %eax
  pushl %eax
  movl $LC6, %eax
  pushl %eax
  call printf
  addl $8, %esp
  leal -5(%ebp), %eax
  pushl %eax
  call set_a
  addl $4, %esp
  leal -12(%ebp), %eax
  movl $-1, (%eax)
  movl (%eax), %edx
  leal -17(%ebp), %edx
  movl -12(%ebp), %eax
  movzbl %al, %eax
  movb %al, (%edx)
  movzbl (%edx), %ecx
  leal -16(%ebp), %ecx
  movzbl -17(%ebp), %edx
  movl %edx, (%ecx)
  movl (%ecx), %eax
  movl -12(%ebp), %eax
  pushl %eax
  movl $LC7, %eax
  pushl %eax
  call printf
  addl $8, %esp
  movzbl -17(%ebp), %eax
  pushl %eax
  movl $LC8, %eax
  pushl %eax
  call printf
  addl $8, %esp
  movl -16(%ebp), %eax
  pushl %eax
  movl $LC9, %eax
  pushl %eax
  call printf
  addl $8, %esp
  movzbl -5(%ebp), %eax
  pushl %eax
  movl $LC10, %eax
  pushl %eax
  call printf
  addl $8, %esp
  call get_literal
  pushl %eax
  movl $LC11, %eax
  pushl %eax
  call printf
  addl $8, %esp
  call get_literal
  movl $3, %ecx
  movzbl (%eax,%ecx,1), %edx
  pushl %edx
  movl $LC12, %edx
  pushl %edx
  call printf
  addl $8, %esp
  leal -12(%ebp), %eax
  movl %eax, -24(%ebp)
  pushl $30
  call malloc
  addl $4, %esp
  movl -24(%ebp), %edx
  movl %eax, (%edx)
  movl (%edx), %ecx
  movl -12(%ebp), %ecx
  movl $0, %edx
  leal (%ecx,%edx,1), %eax
  movb $104, (%eax)
  movzbl (%eax), %ecx
  movl -12(%ebp), %ecx
  movl $1, %eax
  leal (%ecx,%eax,1), %edx
  movb $105, (%edx)
  movzbl (%edx), %ecx
  movl -12(%ebp), %ecx
  movl $2, %edx
  leal (%ecx,%edx,1), %eax
  movb $0, (%eax)
  movzbl (%eax), %ecx
  movl -12(%ebp), %ecx
  pushl %ecx
  movl $LC13, %ecx
  pushl %ecx
  call printf
  addl $8, %esp
  movl -12(%ebp), %eax
  pushl %eax
  call free
  addl $4, %esp
  movl $0, %eax
  jmp .L8_function_end
.L8_function_end:
  movl %ebp, %esp
  popl %ebp
  ret

.global_vars:
  .comm fib_count,16

LC0:
  .ascii "fib(%d) is %d.\12\0"
LC1:
  .ascii "blah\12\0"
LC2:
  .ascii "My executable name is %s.\12\0"
LC3:
  .ascii "  argv[%d] is: %s    argv[%d][0] is: %c\12\0"
LC4:
  .ascii "fib_count is %d.\12\0"
LC5:
  .ascii "stuff_count is %d.\12\0"
LC6:
  .ascii "before set_a(&c), c == '%c'\12\0"
LC7:
  .ascii "  a = %d\12\0"
LC8:
  .ascii "  b = %d\12\0"
LC9:
  .ascii "  c = %d\12\0"
LC10:
  .ascii "after set_a(&c), c == '%c'\12\0"
LC11:
  .ascii "get_literal() = %s\12\0"
LC12:
  .ascii "get_literal()[3] = %c\12\0"
LC13:
  .ascii "array-built string is: %s\12\0"

