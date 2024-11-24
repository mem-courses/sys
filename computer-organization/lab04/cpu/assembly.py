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

class Assembler:
    def collect_labels(self, filename):
        labels = {}
        current_addr = 0

        with open(filename, 'r', encoding='utf8') as f:
            lines = f.readlines()

        # 第一遍扫描：收集所有指令的地址
        for line in lines:
            line = line.split('//')[0].strip()
            line = line.split(';')[0].strip()
            if not line:
                continue

            if any(instr in line.lower() for instr in ['add', 'sub', 'addi', 'lw', 'sw', 'beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu']):
                current_addr += 4

        # 第二遍扫描：收集所有标签
        current_addr = 0
        for line in lines:
            line = line.split('//')[0].strip()
            line = line.split(';')[0].strip()

            if not line:
                continue

            if line.endswith(':'):
                label = line[:-1].strip()
                labels[label] = current_addr
            elif any(instr in line.lower() for instr in ['add', 'sub', 'addi', 'lw', 'sw', 'beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu']):
                current_addr += 4

        return labels

    def parse_instruction(self, line, labels=None, current_addr=0):
        # 移除注释
        line = line.split(';')[0].strip()
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
            
            # 构造 20 位立即数字段
            imm_20 = format((imm >> 20) & 0x1, '01b')
            imm_10_1 = format((imm >> 1) & 0x3FF, '010b')
            imm_11 = format((imm >> 11) & 0x1, '01b')
            imm_19_12 = format((imm >> 12) & 0xFF, '08b')
            
            machine_code = imm_20 + imm_19_12 + imm_11 + imm_10_1 + format(rd, '05b') + opcode

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
    input_file = 'user/data/demo.s'
    output_file = 'user/data/I_mem.coe'
    assembler = Assembler()
    assembler.assemble_file(input_file, output_file)
