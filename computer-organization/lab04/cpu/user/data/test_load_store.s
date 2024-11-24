# 测试 lw, sw, jal, beq 指令
# 初始化一些值
addi x1, x0, 10          # x1 = 10
addi x2, x0, 20          # x2 = 20
add x3, x1, x2           # x3 = 30
addi x4, x0, 100         # x4 = 1600 (内存基地址)
add x4, x4, x4           # (这里如果不对x4进行倍增的话venus会不让读写)
add x4, x4, x4
add x4, x4, x4
add x4, x4, x4

# 测试 sw 指令
sw x1, 0(x4)             # Mem[100] = 10
sw x2, 4(x4)             # Mem[104] = 20
sw x3, 8(x4)             # Mem[108] = 30

# 测试 lw 指令
lw x5, 0(x4)             # x5 = 10 (从Mem[100]读取)
lw x6, 4(x4)             # x6 = 20 (从Mem[104]读取)
lw x7, 8(x4)             # x7 = 30 (从Mem[108]读取)

# 测试 jal 指令
jal x8, jump_target      # x8 存储下一条指令地址
addi x9, x0, 1           # 这条指令会被跳过
addi x10, x0, 2          # 这条指令会被跳过

jump_target:
addi x11, x0, 50         # x11 = 50
add x12, x11, x5         # x12 = 60 (50 + 10)

# 测试 beq 指令
beq x5, x1, beq_target   # 相等，应该跳转
addi x13, x0, 3          # 这条指令会被跳过
addi x14, x0, 4          # 这条指令会被跳过

beq_target:
addi x15, x0, 70         # x15 = 70
add x16, x15, x6         # x16 = 90 (70 + 20)

# 继续进行一些运算以使用剩余寄存器
slt x17, x1, x2          # x17 = 1 (10 < 20)
slt x18, x2, x1          # x18 = 0 (20 > 10)
add x19, x17, x18        # x19 = 1

addi x20, x0, 80         # x20 = 80
add x21, x20, x7         # x21 = 110 (80 + 30)
add x22, x21, x11        # x22 = 160 (110 + 50)

sw x15, 12(x4)           # Mem[112] = 70
lw x23, 12(x4)           # x23 = 70

add x24, x23, x16        # x24 = 160 (70 + 90)
add x25, x24, x12        # x25 = 220 (160 + 60)

addi x26, x0, 200        # x26 = 200
add x27, x26, x19        # x27 = 201 (200 + 1)
add x28, x27, x17        # x28 = 202 (201 + 1)

slt x29, x28, x25        # x29 = 1 (202 < 220)
add x30, x29, x18        # x30 = 1 (1 + 0)
add x31, x30, x17        # x31 = 2 (1 + 1)
