import os

operators = {
    "add": "00001",
    "and": "00010",
    "sub": "00011",
    "mul": "00100",
    "cnb": "00101",
    "mod": "00111",
    "beq": "01000",
    "bgt": "01001",
    "addi": "10000",
    "srl": "10001",
    "sll": "10010",
    "sb": "10011",
    "lb": "10100",
    "lw": "10101",
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
    "t1": "1010",
    "t2": "1011",
    "t3": "1100",
    "v1": "1101",
    "v2": "1110",
    "s1": "1111",
}

labels = {}

compiledInstructions = []


def compile(instruction):
    opcode = operators[instruction[0]]
    opType = opcode[0:2]
    reg1 = registers[instruction[1]]
    reg2 = registers[instruction[2]]
    # If the instruction is type A
    if(opType == "00"):
        reg3 = registers[instruction[3]]
        zeroExt = "000000000000000"
        compiledInstructions.append([opcode, reg1, reg2, reg3, zeroExt])
        return opcode + reg1 + reg2 + reg3 + zeroExt
    # If the instruction is type I
    else:
        imm = instruction[3]
        # If its a branch operation
        if(opType == "01"):
            imm = labels[imm]
        imm = format(int(imm), '019b')
        compiledInstructions.append([opcode, reg1, reg2, imm])
        return opcode + reg1 + reg2 + imm


# Main
QUARTUS_DIRECTORY = open(os.path.dirname(os.getcwd()) +
                         '\\ProyectoGrupalI\\quartus_directory.txt', 'r').read()
file = open("Compiler\\RSA_Decrypt.asmrsa", "r")
fileArray = []
pc = 0
for line in file:
    line = line.lower()
    lineArray = line.split()
    if(len(lineArray) != 0):
        if(lineArray[0][-1] == ':'):
            newLabel = {lineArray[0][0:-1]: str(pc)}
            labels.update(newLabel)
        else:
            pc += 4
            fileArray.append(lineArray)
file.close()

print(labels)
print(fileArray)


file = open( #QUARTUS_DIRECTORY + 
    'Compiler' + 
    '\\' + 'RSA_Decrypt.b', "w")

for instruction in fileArray:
    file.write(compile(instruction) + "\n")

file.close()
print(compiledInstructions)
