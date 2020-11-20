import numpy as np
from PIL import Image

registers = {
    "zero": 0,
    "r1": 0,                   # Factor
    "r2": 0,                   # Increment
    "r3": 0,                   # Width = height
    "r4": 0,                   # New width = new height
    "r5": 0,                   # Pixel count
    "r6": 0,                   # Pixel counter
    "r7": 0,
    "r8": 0,
    "r9": 0,                   # Finished flag (0 when finished)
    "t1": 0,                   # Used to store values in vectors
    "t2": 0,                   # Used to test conditions
    "v1": np.array([0] * 4),   # Index vector (offset)
    "v2": np.array([0] * 4),   # Image pixel values vector
    "v3": np.array([0] * 4),   # Constant value 2
    "v4": np.array([0] * 4),   # This vector will always be zero
}

'''
inputImage = Image.open("image.jpg").convert('L')
inputImage.load()
inputImage = np.asarray(inputImage, dtype="uint8")
outputImage = Image.fromarray(inputImage, 'L')
outputImage.save('input.jpg')
print(inputImage)
'''

memory = np.array([0] * (64 + 16))
memory[0] = 1
memory[1] = 2
memory[2] = 3
memory[3] = 4
memory[4] = 5
memory[5] = 6
memory[6] = 7
memory[7] = 8
memory[8] = 9
memory[9] = 10
memory[10] = 11
memory[11] = 12
memory[12] = 13
memory[13] = 14
memory[14] = 15
memory[15] = 16


def addi(dest: str, reg1: str, imm: int):
    registers[dest] = registers[reg1] + imm


def mod(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] % registers[reg2]


def lb(dest: str, reg1: str, imm: int):
    registers[dest] = memory[registers[reg1] + imm]


def beq(reg1: str, reg2: str, label: int) -> bool:
    if registers[reg1] == registers[reg2]:
        if label == 'nearestNeighborEnd':
            nearestNeighborEnd()
            return True
        elif label == 'nearestNeighborLoop':
            nearestNeighborLoop()
            return True
        elif label == 'updateOffset':
            updateOffset()
            return True
        else:
            return False
    else:
        return False


def addv(dest: str, regv1: str, regv2: str):
    registers[dest] = np.add(registers[regv1], registers[regv2])


def rep(dest: str, reg1: str):
    registers[dest] = np.array([registers[reg1]] * 4)


def svi(valueArray, indexArray):
    for i in range(0, 4):
        memory[registers[indexArray][i]] = registers[valueArray][i]


def lvi(valueArray, indexArray):
    for i in range(0, 4):
        registers[valueArray][i] = memory[registers[indexArray][i]]


def movv(dest: str, reg1: str, imm: int):
    registers[dest][imm - 1] = registers[reg1]


def nearestNeighborInit():
    addi('r1', 'zero', 4)   # Factor = 4
    addi('r2', 'zero', 2)   # Increment = 2
    addi('r3', 'zero', 4)   # Width = height = 400
    addi('r4', 'zero', 8)   # New width = new height = 800
    addi('r5', 'zero', 16)  # Pixel count = 160000
    addi('r6', 'zero', 0)   # Pixel counter = 0
    addi('r9', 'zero', 1)   # Finished flag = 1
    addi('t1', 'zero', 16)  # Start at pixel count in memory (after input image)
    movv('v1', 't1', 1)     # First index for the output index vector
    addi('t1', 'zero', 17)  # Start at pixel count in memory (after input image)
    movv('v1', 't1', 2)     # Second index for the output index vector
    addi('t1', 'zero', 24)  # Start at pixel count in memory (after input image)
    movv('v1', 't1', 3)     # Third index for the output index vector
    addi('t1', 'zero', 25)  # Start at pixel count in memory (after input image)
    movv('v1', 't1', 4)     # Fourth index for the output index vector
    addi('t1', 'zero', 2)   # Constant value 2 for v3
    rep('v3', 't1')
    nearestNeighborLoop()


def nearestNeighborLoop():
    if(not beq('r5', 'r6', 'nearestNeighborEnd')):    # Here the if-else statement must be omitted
        lb('t1', 'r6', 0)
        rep('v2', 't1')
        svi('v2', 'v1')
        addv('v1', 'v1', 'v3')
        addi('r6', 'r6', 1)
        mod('t2', 'r6', 'r3')
        if(not beq('t2', 'zero', 'updateOffset')):
            if(not beq('zero', 'zero', 'nearestNeighborLoop')):
                return


def updateOffset():
    rep('v2', 'r4')
    addv('v1', 'v1', 'v2')
    if not(beq('zero', 'zero', 'nearestNeighborLoop')):
        pass


def nearestNeighborEnd():
    print(memory)


# MAIN
nearestNeighborInit()
