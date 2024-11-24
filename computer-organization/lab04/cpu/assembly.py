import re
import os
import sys

os.chdir(sys.path[0])

# 在文件开头添加支持的指令集合
SUPPORTED_INSTRUCTIONS = {
    'add', 'sub', 'and', 'or', 'xor', 'slt',  # R-type
    'addi', 'andi', 'ori', 'xori', 'slti',    # I-type
    'lw', 'sw',                                # Load/Store
    'beq', 'jal'                               # Branch/Jump
    # 根据实际支持的指令添加或删除
}

def remove_comment(line):
    line = line.split('//')[0].strip()
    line = line.split('# ')[0].strip()
    line = line.split(';')[0].strip()
    return line


class Assembler:
    def collect_labels(self, filename):
        labels = {}
        current_addr = 0

        with open(filename, 'r', encoding='utf8') as f:
            lines = f.readlines()

        for line in lines:
            line = remove_comment(line)
            if not line:
                continue

            # 处理标签行
            if line.endswith(':'):
                label = line[:-1].strip()
                labels[label] = current_addr
                continue  # 标签行不增加地址计数

            # 检查是否是有效指令
            parts = re.split(r'[,\s]+', line)
            instr = parts[0].lower()
            if instr in SUPPORTED_INSTRUCTIONS:
                current_addr += 4

        return labels

    def parse_instruction(self, line, labels=None, current_addr=0):
        # 移除注释
        line = remove_comment(line)
        if not line:
            return None

        # 解析标签定义行
        if line.endswith(':'):
            return None

        # 分割指令和操作数
        parts = re.split(r'[,\s]+', line)
        instr = parts[0].lower()

        # 检查指令是否受支持
        if instr not in SUPPORTED_INSTRUCTIONS:
            raise ValueError(f"不支持的指令: {instr}")

        operands = [op.strip() for op in parts[1:] if op.strip()]

        # R型指令
        r_type = {
            'add': '0110011',
            'sub': '0110011',
            'and': '0110011',
            'or': '0110011',
            'xor': '0110011',
            'slt': '0110011',
            'sll': '0110011',
            'slt': '0110011',
            'sltu': '0110011',
            'xor': '0110011',
            'srl': '0110011',
            'sra': '0110011',
            'or': '0110011',
            'and': '0110011'
        }

        # I型指令
        i_type = {
            'addi': '0010011',
            'andi': '0010011',
            'ori': '0010011',
            'xori': '0010011',
            'slti': '0010011',
            'lw': '0000011',
            'jalr': '1100111',
            'lb': '0000011',
            'lh': '0000011',
            'lbu': '0000011',
            'lhu': '0000011'
        }

        # S型指令
        s_type = {
            'sb': '0100011',
            'sh': '0100011',
            'sw': '0100011'
        }

        # B型指令
        b_type = {
            'beq': '1100011',
            'bne': '1100011',
            'blt': '1100011',
            'bge': '1100011',
            'bltu': '1100011',
            'bgeu': '1100011'
        }

        # 解析寄存器编号
        def get_reg_num(reg):
            return int(reg[1:])

        # 生成机器码
        if instr in r_type:
            rd = get_reg_num(operands[0])
            rs1 = get_reg_num(operands[1])
            rs2 = get_reg_num(operands[2])

            funct3 = {
                'add': '000',
                'sub': '000',
                'and': '111',
                'or': '110',
                'xor': '100',
                'slt': '010',
                'sll': '001',
                'slt': '010',
                'sltu': '011',
                'xor': '100',
                'srl': '101',
                'sra': '101',
                'or': '110',
                'and': '111'
            }[instr]

            funct7 = '0100000' if instr in ['sub', 'sra'] else '0000000'

            machine_code = funct7 + format(rs2, '05b') + format(rs1, '05b') + funct3 + format(rd, '05b') + r_type[instr]

        elif instr in i_type:
            rd = get_reg_num(operands[0])
            # 检查是否是形如 0x34(x0) 的格式
            if '(' in operands[1]:
                # 处理形如 0x34(x0) 的格式
                imm_str = operands[1].split('(')[0]
                rs1 = get_reg_num(operands[1].split('(')[1].rstrip(')'))
                # 支持十六进制和十进制
                imm = int(imm_str, 16) if imm_str.startswith('0x') else int(imm_str)
            else:
                rs1 = get_reg_num(operands[1])
                # 支持十六进制和十进制
                imm = int(operands[2], 16) if operands[2].startswith('0x') else int(operands[2])

            funct3 = {
                'addi': '000',
                'andi': '111',
                'ori': '110',
                'xori': '100',
                'slti': '010',
                'lw': '010',
                'lb': '000',
                'lh': '001',
                'lbu': '100',
                'lhu': '101'
            }[instr]

            machine_code = format(imm & 0xFFF, '012b') + format(rs1, '05b') + funct3 + format(rd, '05b') + i_type[instr]

        elif instr in s_type:
            rs2 = get_reg_num(operands[0])
            # 检查是否是形如 0x34(x0) 的格式
            if '(' in operands[1]:
                # 处理形如 0x34(x0) 的格式
                imm_str = operands[1].split('(')[0]
                rs1 = get_reg_num(operands[1].split('(')[1].rstrip(')'))
                # 支持十六进制和十进制
                imm = int(imm_str, 16) if imm_str.startswith('0x') else int(imm_str)
            else:
                imm = int(operands[1], 16) if operands[1].startswith('0x') else int(operands[1])
                rs1 = get_reg_num(operands[2])

            funct3 = {
                'sb': '000',
                'sh': '001',
                'sw': '010'
            }[instr]

            imm_11_5 = format((imm >> 5) & 0x7F, '07b')
            imm_4_0 = format(imm & 0x1F, '05b')

            machine_code = imm_11_5 + format(rs2, '05b') + format(rs1, '05b') + funct3 + imm_4_0 + s_type[instr]

        elif instr in b_type:
            rs1 = get_reg_num(operands[0])
            rs2 = get_reg_num(operands[1])

            # 处理标签或立即数
            if operands[2].startswith('0x'):
                imm = int(operands[2], 16)
            elif operands[2].isdigit() or operands[2].startswith('-'):
                imm = int(operands[2])
            else:  # 标签
                if labels and operands[2] in labels:
                    # 计算相对偏移
                    target_addr = labels[operands[2]]
                    imm = target_addr - current_addr
                else:
                    raise ValueError(f"未定义的标签: {operands[2]}")

            funct3 = {
                'beq': '000',
                'bne': '001',
                'blt': '100',
                'bge': '101',
                'bltu': '110',
                'bgeu': '111'
            }[instr]

            imm_12 = format((imm >> 12) & 0x1, '01b')
            imm_10_5 = format((imm >> 5) & 0x3F, '06b')
            imm_4_1 = format((imm >> 1) & 0xF, '04b')
            imm_11 = format((imm >> 11) & 0x1, '01b')

            machine_code = imm_12 + imm_10_5 + format(rs2, '05b') + format(rs1, '05b') + funct3 + imm_4_1 + imm_11 + b_type[instr]

        elif instr == 'jal':
            rd = get_reg_num(operands[0])

            # 处理标签或立即数
            if operands[1].startswith('0x'):
                imm = int(operands[1], 16)
            elif operands[1].isdigit() or operands[1].startswith('-'):
                imm = int(operands[1])
            else:  # 标签
                if labels and operands[1] in labels:
                    target_addr = labels[operands[1]]
                    imm = target_addr - current_addr
                else:
                    raise ValueError(f"未定义的标签: {operands[1]}")
            
            # JAL 的 opcode
            opcode = '1101111'
            
            # 处理20位有符号数的补码表示
            print(imm)
            if imm < 0:
                imm = (1 << 21) + imm  # 转换为补码，使用21位
            
            # JAL指令的立即数编码，按照RISC-V规范：
            # imm[20|10:1|11|19:12] = inst[31|30:21|20|19:12]
            imm_20 = (imm >> 20) & 1      # 符号位
            imm_10_1 = (imm >> 1) & 0x3FF # bits 10:1
            imm_11 = (imm >> 11) & 1      # bit 11
            imm_19_12 = (imm >> 12) & 0xFF # bits 19:12
            
            machine_code = (f"{imm_20:01b}" + 
                          f"{imm_10_1:010b}" + 
                          f"{imm_11:01b}" + 
                          f"{imm_19_12:08b}" + 
                          format(rd, '05b') + 
                          opcode)
            # print(imm_20)
            # print(' ' + f"{imm_10_1:010b}")
            # print(machine_code)        
            # print('00000000110000000000010001101111')        

        else:
            return None

        return format(int(machine_code, 2), '08x')

    def assemble_file(self, input_file, output_file):
        # 首先收集所有标签
        labels = self.collect_labels(input_file)
        instructions = []
        current_addr = 0

        # 读取汇编文件
        with open(input_file, 'r', encoding='utf8') as f:
            for line in f:
                line = remove_comment(line)
                if not line or line.endswith(':'):  # 跳过空行和标签行
                    continue
                
                machine_code = self.parse_instruction(line, labels, current_addr)
                if machine_code:
                    instructions.append(machine_code)
                    current_addr += 4

        # 写入COE文件
        with open(output_file, 'w') as f:
            f.write('memory_initialization_radix=16;\n')
            f.write('memory_initialization_vector=\n')
            for i, instr in enumerate(instructions):
                if i == len(instructions) - 1:
                    f.write(instr.upper() + ';')
                else:
                    f.write(instr.upper() + ',\n')


if __name__ == '__main__':
    input_file = 'user/data/test_load_store.s'
    output_file = 'user/data/I_mem.coe'
    assembler = Assembler()
    assembler.assemble_file(input_file, output_file)
