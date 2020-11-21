# ================================= IMPORTS =================================
import numpy as np
from PIL import Image
import resource
import sys
resource.setrlimit(resource.RLIMIT_STACK, (2**29, -1))
sys.setrecursionlimit(10**6)


# ================================= SWITCH INPUT =================================
switch = '1'

switches = {
    '1': 0,
    '2': 100,
    '3': 200,
    '4': 300,
    '5': 40000,
    '6': 40100,
    '7': 40200,
    '8': 40300,
    '9': 80000,
    '10': 80100,
    '11': 80200,
    '12': 80300,
    '13': 120000,
    '14': 120100,
    '15': 120200,
    '16': 120300,
}

# ================================= MICROARCHITECTURE =================================

registers = {
    "zero": 0,
    "r1": 0,                   # Factor
    "r2": 0,                   # Increment
    "r3": 0,                   # Width = height
    "r4": 0,                   # New width = new height
    "r5": 0,                   # Pixel count
    "r6": 0,                   # Pixel counter
    "r7": 0,                   # Pixel index
    "r8": 0,                   # Image segment width
    "r9": 0,                   # Finished flag (0 when finished)
    "t1": 0,                   # Used to store values in vectors
    "t2": 0,                   # Used to test conditions
    "v1": np.array([0] * 4),   # Index vector (offset)
    "v2": np.array([0] * 4),   # Image pixel values vector
    "v3": np.array([0] * 4),   # Constant value 2
    "v4": np.array([0] * 4),   # This vector will always be zero
}

memory = np.array([0] * (200000), dtype="uint8")


# ================================= IMAGE READ =================================


inputImage = Image.open("image.jpg").convert('L')
inputImage.load()
inputImage = np.asarray(inputImage, dtype="uint8")
outputImage = Image.fromarray(inputImage, 'L')
outputImage.save('input.jpg')
inputImage = inputImage.flatten()


# ================================= IMAGE TO MEMORY =================================

memory[0:160000] = inputImage[0:160000]


# ================================= ISA =================================

def addi(dest: str, reg1: str, imm: int):
    registers[dest] = registers[reg1] + imm


def add(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] + registers[reg2]


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


# ================================= ASM SCRIPT =================================

def nearestNeighborInit():
    # Factor = 4
    addi('r1', 'zero', 4)
    # Increment = 2
    addi('r2', 'zero', 2)
    # Width offset = height offset = 300
    addi('r3', 'zero', 300)
    # New width = new height = 200
    addi('r4', 'zero', 200)
    # Pixel count = 10000
    addi('r5', 'zero', 10000)
    # Pixel counter = 0
    addi('r6', 'zero', 0)
    # Pixel index = 0
    addi('r7', 'zero', switches[switch])
    # Image segment width = 100
    addi('r8', 'zero', 100)
    # Finished flag = 1
    addi('r9', 'zero', 1)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160000)
    # First index for the output index vector
    movv('v1', 't1', 1)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160001)
    # Second index for the output index vector
    movv('v1', 't1', 2)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160200)
    # Third index for the output index vector
    movv('v1', 't1', 3)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160201)
    # Fourth index for the output index vector
    movv('v1', 't1', 4)
    # Constant value 2 for v3
    addi('t1', 'zero', 2)
    rep('v3', 't1')
    nearestNeighborLoop()


def nearestNeighborLoop():
    if(not beq('r5', 'r6', 'nearestNeighborEnd')):    # Here the if-else statement must be omitted
        lb('t1', 'r7', 0)
        rep('v2', 't1')
        svi('v2', 'v1')
        addv('v1', 'v1', 'v3')
        addi('r6', 'r6', 1)
        addi('r7', 'r7', 1)
        mod('t2', 'r6', 'r8')
        if(not beq('t2', 'zero', 'updateOffset')):
            if(not beq('zero', 'zero', 'nearestNeighborLoop')):
                pass


def updateOffset():
    rep('v2', 'r4')
    addv('v1', 'v1', 'v2')
    add('r7', 'r7', 'r3')
    if(not beq('zero', 'zero', 'nearestNeighborLoop')):
        pass


def nearestNeighborEnd():
    pass


# ================================= PYTHON MAIN =================================
nearestNeighborInit()
outputImage = memory[160000:200000]
outputImage = outputImage.reshape(200, 200)
outputImage = Image.fromarray(outputImage, 'L')
outputImage.save('output' + switch + '.jpg')
