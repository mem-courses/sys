import re
import os
import sys

os.chdir(sys.path[0])


def collect_labels(filename):
    labels = {}
    current_addr = 0

    with open(filename, 'r') as f:
        for line in f:
            line = line.split(';')[0].strip()
            if not line:
                continue

            if line.endswith(':'):
                label = line[:-1].strip()
                labels[label] = current_addr
            elif any(instr in line.lower() for instr in ['add', 'sub', 'addi', 'lw', 'sw', 'beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu']):
                current_addr += 4

    return labels


def parse_instruction(line, labels=None, current_addr=0):
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
    operands = [op.strip() for op in parts[1:] if op.strip()]

    # R型指令
    r_type = {
        'add': '0110011',
        'sub': '0110011',
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
        'slti': '0010011',
        'sltiu': '0010011',
        'xori': '0010011',
        'ori': '0010011',
        'andi': '0010011',
        'lb': '0000011',
        'lh': '0000011',
        'lw': '0000011',
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
        rs1 = get_reg_num(operands[1])
        imm = int(operands[2])

        funct3 = {
            'addi': '000',
            'slti': '010',
            'sltiu': '011',
            'xori': '100',
            'ori': '110',
            'andi': '111',
            'lb': '000',
            'lh': '001',
            'lw': '010',
            'lbu': '100',
            'lhu': '101'
        }[instr]

        machine_code = format(imm & 0xFFF, '012b') + format(rs1, '05b') + funct3 + format(rd, '05b') + i_type[instr]

    elif instr in s_type:
        rs2 = get_reg_num(operands[0])
        imm = int(operands[1])
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

    else:
        return None

    return format(int(machine_code, 2), '08x')


def assemble_file(input_file, output_file):
    # 首先收集所有标签
    labels = collect_labels(input_file)
    instructions = []
    current_addr = 0

    # 读取汇编文件
    with open(input_file, 'r') as f:
        for line in f:
            machine_code = parse_instruction(line, labels, current_addr)
            if machine_code:
                instructions.append(machine_code)
                current_addr += 4

    # 写入COE文件
    with open(output_file, 'w') as f:
        f.write('memory_initialization_radix=16;\n')
        f.write('memory_initialization_vector=\n')
        for i, instr in enumerate(instructions):
            if i == len(instructions) - 1:
                f.write(instr + ';')
            else:
                f.write(instr + ',\n')


if __name__ == '__main__':
    input_file = 'user/data/demo.s'
    output_file = 'user/data/I_mem.coe'
    assemble_file(input_file, output_file)
