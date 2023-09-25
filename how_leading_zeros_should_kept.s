.data
    x1: .word 16
    y1: .word 12
    x2: .word 25
    y2: .word 800
    x3: .word 956
    y3: .word 85 
    string1: .string  "\nshould keep zeros:"

.text
.globl main
main:
    nop
    addi t0,t0,1
    addi sp, sp, -4
    sw t0,0(sp)
    addi t5, zero, 3
    
    la a0, string1
    li a7, 4
    ecall
    
    addi t0,t0,-2
    blt t0, zero, firstx
    beq t0, zero, secondx
    bge t0, zero, thirdx
    
firstx:
    #read x
    lw a0, x1         
    #call func                  
    jal ra, func
    #store in s1
    sw a0, 0(s1)
    
firsty: 
    #read y
    lw a0, y1    
    #call func              
    jal ra, func
    jal ra, calcu
    
secondx:
    #read x
    lw a0, x2         
    #call func                  
    jal ra, func
    #store in s1
    sw a0, 0(s1)
    
secondy: 
    #read y
    lw a0, y2    
    #call func              
    jal ra, func
    jal ra, calcu
    
thirdx:
    #read x
    lw a0, x3         
    #call func                  
    jal ra, func
    #store in s1
    sw a0, 0(s1)
    
thirdy: 
    #read y
    lw a0, y3    
    #call func              
    jal ra, func
    jal ra, calcu
    
calcu:
    #load s1 to t0
    lw t0, 0(s1)
    blt a0, t0, no
    
    #a0>t0
    sub a0, a0, t0
    li a7, 1
    ecall
    jal ra, restore
    
    #t0>a0
no:
    sub a0, t0, a0
    li a7, 1
    ecall
    jal ra, restore

restore:
    lw t0,0(sp)
    addi sp, sp, 4
    beq t0, t5, exit
    jal ra, main
    
exit:
    li a7, 10
    ecall
    
    #t1 = shift num
func:
    addi  t1, t1, 1 
loop:
    sra   t2, a0, t1     
    or    a0, a0, t2    
    #if t1 == 16 co
    addi  t3, t1, -16     
    beq   t3, x0, co   
    #t1 = t1*2
    slli  t1, t1, 1      
    jal   x0, loop
co:
    #x -= ((x >> 1) & 0x55555555 );
    srai  t1, a0, 1
    lui t4, 0x55555
    ori t4, t4, 0x555
    and  t1, t1, t4
    sub   a0, a0, t1
    #x = ((x >> 2) & 0x33333333) + (x & 0x33333333 );
    srai  t1, a0, 2
    lui t4, 0x33333
    ori t4, t4, 0x333
    and  t1, t1, t4
    and  a0, a0, t4
    add   a0, a0, t1
    # x = ((x >> 4) + x) & 0x0f0f0f0f;
    srai  t1, a0, 4
    add   a0, a0, t1
    lui t4, 0x0f0f0
    ori t4, t4, 0x787
    addi t4, t4, 0x788
    and  a0, a0, t4
    #x += (x >> 8);
    srai  t1, a0, 8
    add   a0, a0, t1
    #x += (x >> 16);
    srai  t1, a0, 16
    add   a0, a0, t1
    #return (32 - (x & 0x7f));
    andi  a0, a0, 0x7f
    addi  t3, t3, 32
    sub   a0, t3, a0

    ret
