start: //通道结果由后一条指令读操作数观察
    lw x5, 0x34(x0); //取测试常数55555555。存储器读通道
start_A:
    add x1, x5, x0; //r1: 寄存器写通道。R5:寄存器读通道A输出
    xor x2, x0, x1; //r1: 寄存器读通道B输出。R2:ALU输出通道
    lw x5, 0x48(x0); //取测试常数AAAAAAAA。立即数通道:00000048
    beq x2, x5 test_sw; //循环测试
    jal x0, start; //循环测试。
test_sw: //增加写SW测试，如34和48单元交换
    beq x0, x0, start; //循环测试。立即数通道：00000014
