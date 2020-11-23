operators = {
    "mod": "00000",
    "add": "00001",
    "and": "00010",
    "sub": "00011",
    "mul": "00100",
    "div": "00101",     # Changed
    "beq": "01000",
    "bgt": "01001",
    "addi": "10000",
    "srl": "10001",
    "sll": "10010",
    "sb": "10011",
    "lb": "10100",
    # "lw": "10101",    # Changed
    "addv": "11000",    # Changed
    "mulv": "11001",    # Changed
    "divv": "11010",    # Changed
    "rep": "11011",     # Changed
    "movv": "11100",    # Changed
    "svi": "11101",     # Changed
    "lvi": "11110",     # Changed
}

registers = {
    "zero": "0000",
    "r1": "0001",
    "r2": "0010",
    "r3": "0011",
    "r4": "0100",
    "r5": "0101",
    "r6": "0110",
    "r7": "0111",
    "r8": "1000",
    "r9": "1001",
    "t1": "1010",   # Will use this for I/O
    "t2": "1011",   # Will use this for external register
    "v1": "1100",   # Changed
    "v2": "1101",   # Changed
    "v3": "1110",   # Changed
    "v4": "1111",   # Changed
}

labels = {}

compiledInstructions = []


def compile(instruction):
    opcode = operators[instruction[0]]
    reg1 = registers[instruction[1]]
    reg2 = registers[instruction[2]]
    # If the instruction is type A
    if(opcode[0:2] == "00"):
        reg3 = registers[instruction[3]]
        if (not validateRegisters('A', reg1, reg2, reg3)):
            print("Cannot use vector registers for instruction A ->", instruction)
            return "========= COMPILATION ERROR ============ [" + ' '.join([str(elem) for elem in instruction]) + "]"
        zeroExt = "000000000000000"
        compiledInstructions.append([opcode, reg1, reg2, reg3, zeroExt])
        return opcode + reg1 + reg2 + reg3 + zeroExt
    # If the instruction is a branch
    elif (opcode[0:2] == "01"):
        if (not validateRegisters('B', reg1, reg2)):
            print("Cannot use vector registers in branches ->", instruction)
            return "========= COMPILATION ERROR ============ [" + ' '.join([str(elem) for elem in instruction]) + "]"
        imm = instruction[3]
        imm = labels[imm]
        imm = format(int(imm), '019b')
        compiledInstructions.append([opcode, reg1, reg2, imm])
        return opcode + reg1 + reg2 + imm
    # If the instruction is type I
    if(opcode[0:2] == "10"):
        if (not validateRegisters('I', reg1, reg2)):
            print("Cannot use vector registers in I instructions ->", instruction)
            return "========= COMPILATION ERROR ============ [" + ' '.join([str(elem) for elem in instruction]) + "]"
        imm = instruction[3]
        imm = format(int(imm), '019b')
        compiledInstructions.append([opcode, reg1, reg2, imm])
        return opcode + reg1 + reg2 + imm
    # It is a VA instruction
    elif (opcode[0:3] == "110"):
        # Replicate
        if (opcode == "11011"):
            if (not validateRegisters('REP', reg1, reg2)):
                print("Invalid registers for instruction ->", instruction)
                return "========= COMPILATION ERROR ============ [" + ' '.join([str(elem) for elem in instruction]) + "]"
            reg3 = registers['zero']
        # Normal vector arithmetic
        else:
            if (not validateRegisters('VA', reg1, reg2)):
                print("Invalid registers for instruction ->", instruction)
                return "========= COMPILATION ERROR ============ [" + ' '.join([str(elem) for elem in instruction]) + "]"
            reg3 = registers[instruction[3]]
        zeroExt = "000000000000000"
        compiledInstructions.append([opcode, reg1, reg2, reg3, zeroExt])
        return opcode + reg1 + reg2 + reg3 + zeroExt
    # It is a VI instruction
    elif (opcode[0:3] == "111"):
        # Move vector
        if (opcode == "11100"):
            if (not validateRegisters('MOVV', reg1, reg2)):
                print("Invalid registers for instruction ->", instruction)
                return "========= COMPILATION ERROR ========= [" + ' '.join([str(elem) for elem in instruction]) + "]"
        # Normal VI instruction
        else:
            if (not validateRegisters('VI', reg1, reg2)):
                print("Invalid registers for instruction ->", instruction)
                return "========= COMPILATION ERROR ============ [" + ' '.join([str(elem) for elem in instruction]) + "]"
        imm = instruction[3]
        imm = format(int(imm), '019b')
        compiledInstructions.append([opcode, reg1, reg2, imm])
        return opcode + reg1 + reg2 + imm


def validateRegisters(type, *args) -> bool:
    if (type == "A" or type == "B" or type == "I"):
        for register in args:
            if register[0:2] == "11":
                return False
        return True
    elif (type == "VA"):
        for register in args:
            if register[0:2] != "11":
                return False
        return True
    elif (type == "VI"):
        if args[0][0:2] == "11" and args[1][0:2] == "11":
            return True
        return False
    elif (type == "MOVV" or type == "REP"):
        if args[0][0:2] == "11" and args[1][0:2] != "11":
            return True
        return False
    return False


# Main
file = open("rsa.asmrsa", "r")
fileArray = []
pc = 0
for line in file:
    line = line.lower()
    lineArray = line.split()
    if(len(lineArray) != 0):
        if(lineArray[0][-1] == ':'):
            newLabel = {lineArray[0][0:-1]: str(pc + 4)}
            labels.update(newLabel)
        else:
            pc += 4
            fileArray.append(lineArray)
file.close()

'''
print(labels)
print(fileArray)
'''

file = open("rsa.b", "w")

for instruction in fileArray:
    file.write(compile(instruction) + "\n")

file.close()
'''
print(compiledInstructions)
'''
