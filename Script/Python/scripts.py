# ================================= IMPORTS =================================
import numpy as np
from PIL import Image
import resource
import sys
resource.setrlimit(resource.RLIMIT_STACK, (2**29, -1))
sys.setrecursionlimit(10**6)


# ================================= SWITCH INPUT =================================
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
    "r1": 0,                   # Algorithm selector and variable
    "r2": 0,                   # Memory offset
    "r3": 0,                   # Width = height
    "r4": 0,                   # New width = new height
    "r5": 0,                   # Pixel count
    "r6": 0,                   # Pixel counter
    "r7": 0,                   # Pixel index
    "r8": 0,                   # Image segment width
    "r9": 0,                   # Finished flag (0 when finished)
    "t1": 0,                   # Used to store values in vectors and to test conditions
    "t2": 0,                   # GPIO exclusive
    "v1": np.array([0] * 4),   # Index vector (offset)
    "v2": np.array([0] * 4),   # Image pixel values vector
    "v3": np.array([0] * 4),   # Constant value 2 / multipliers
    "v4": np.array([0] * 4),   # This vector will always be zero / multipliers
}

memory = np.array([0] * (250000), dtype="uint8")


# ================================= IMAGE READ =================================


inputImage = Image.open("image.jpg").convert('L')
inputImage.load()
inputImage = np.asarray(inputImage, dtype="uint8")
outputImage = Image.fromarray(inputImage, 'L')
outputImage.save('input.jpg')
inputImage = inputImage.flatten()


# ================================= IMAGE TO MEMORY =================================

memory[0:160000] = inputImage[0:160000]
memory[249997] = 1  # Algorithm
memory[249998] = 5  # Image section


# ================================= ISA =================================

def addi(dest: str, reg1: str, imm: int):
    registers[dest] = registers[reg1] + imm


def add(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] + registers[reg2]


def sub(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] - registers[reg2]


def mul(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] * registers[reg2]


def div(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] // registers[reg2]


def mod(dest: str, reg1: str, reg2: str):
    registers[dest] = registers[reg1] % registers[reg2]


def lb(dest: str, reg1: str, imm: int):
    registers[dest] = memory[registers[reg1] + imm]


def beq(reg1: str, reg2: str, label: int) -> bool:
    if registers[reg1] == registers[reg2]:
        if label == 'end':
            end()
            return True
        elif label == 'nearestNeighborLoop':
            nearestNeighborLoop()
            return True
        elif label == 'nearestNeighborInit':
            nearestNeighborInit()
            return True
        elif label == 'nearestNeighborUpdateOffset':
            nearestNeighborUpdateOffset()
            return True
        elif label == 'bilinearLoop':
            bilinearLoop()
            return True
        elif label == 'bilinearUpdateOffset':
            bilinearUpdateOffset()
            return True
        else:
            return False
    else:
        return False


def addv(dest: str, regv1: str, regv2: str):
    registers[dest] = np.add(registers[regv1], registers[regv2])


def mulv(dest: str, regv1: str, regv2: str):
    registers[dest] = np.multiply(registers[regv1], registers[regv2])


def divv(dest: str, regv1: str, regv2: str):
    registers[dest] = np.divide(registers[regv1], registers[regv2])


def rep(dest: str, reg1: str):
    registers[dest] = np.array([registers[reg1]] * 4)


def svi(valueArray, indexArray):
    for i in range(0, 4):
        memory[registers[indexArray][i]] = registers[valueArray][i]


def lvi(valueArray, indexArray):
    for i in range(0, 4):
        registers[valueArray][i] = memory[registers[indexArray][i]]


def movv(dest: str, reg1: str, imm: int):
    registers[dest][imm] = registers[reg1]


# ================================= ASM SCRIPT =================================
def init():
    # Pixel index based on image section (r7 = i)
    lb('r7', 'zero', 249998)
    # t1 = 4
    addi('t1', 'zero', 4)
    # r1 = i % 4
    mod('r1', 'r7', 't1')
    # r7 = i // 4
    div('r7', 'r7', 't1')
    # t1 = 100
    addi('t1', 'zero', 100)
    # r1 = 100 * (i % 4)
    mul('r1', 't1', 'r1')
    # t1 = 40000
    addi('t1', 'zero', 40000)
    # r1 = 40000 * (i // 4)
    mul('r7', 't1', 'r7')
    # r7 = (i % 4) * 100 + (i // 4) * 40000
    add('r7', 'r1', 'r7')
    # Select algorithm
    addi('r1', 'zero', 249997)
    lb('r1', 'r1', 0)
    if(not beq('r1', 'zero', 'nearestNeighborInit')):
        bilinearInit()


def bilinearInit():
    # v1 = [0, 0, 0, 0]
    rep('v1', 'zero')
    # v2 = [0, 0, 0, 0]
    rep('v2', 'zero')
    # v3 = [2, 1, 2, 1]
    addi('t1', 'zero', 1)
    movv('v3', 't1', 1)
    movv('v3', 't1', 3)
    addi('t1', 'zero', 2)
    movv('v3', 't1', 0)
    movv('v3', 't1', 2)
    # v4 = [1, 2, 1, 2]
    addi('t1', 'zero', 2)
    movv('v4', 't1', 1)
    movv('v4', 't1', 3)
    addi('t1', 'zero', 1)
    movv('v4', 't1', 0)
    movv('v4', 't1', 2)
    # Start at pixel count in memory (after input image) (memoryOffset)
    addi('r2', 'zero', 160000)
    # Width offset = height offset = 400 (width offset)
    addi('r3', 'zero', 400)
    # New width = new height = 200 (new width offset)
    addi('r4', 'zero', 298)
    # Pixel count = 9801 (totalIterations)
    addi('r5', 'zero', 9801)
    # Pixel counter = 0 (pixelCounter)
    addi('r6', 'zero', 0)
    # r7 = imageCounter
    # Image segment width = 100 (sectionWidth)
    addi('r8', 'zero', 100)
    bilinearLoop()


def bilinearLoop():
    if(not beq('r6', 'r5', 'end')):
        # Get v1 values from memory
        lb('r1', 'r7', 0)
        movv('v1', 'r1', 0)
        lb('r1', 'r7', 1)
        movv('v1', 'r1', 1)
        add('t1', 'r7', 'r3')
        lb('r1', 't1', 0)
        movv('v1', 'r1', 2)
        lb('r1', 't1', 1)
        movv('v1', 'r1', 3)
        add('t1', 'zero', 'r2')
        movv('v2', 't1', 0)
        addi('t1', 't1', 3)
        movv('v2', 't1', 1)
        addi('t1', 'zero', 3)
        mul('t1', 't1', 'r4')
        add('t1', 't1', 'r2')
        movv('v2', 't1', 2)
        addi('t1', 't1', 3)
        movv('v2', 't1', 3)

        # Save pixels to memory
        svi('v1', 'v2')

        # Bilinear interpolation (first side)
        lb('t1', 'r7', 0)
        rep('v1', 't1')
        lb('t1', 'r7', 1)
        movv('v2', 't1', 0)
        movv('v2', 't1', 1)
        add('t1', 'r7', 'r3')
        lb('t1', 't1', 0)
        movv('v2', 't1', 2)
        movv('v2', 't1', 3)
        mulv('v1', 'v1', 'v3')
        mulv('v2', 'v2', 'v4')
        addv('v1', 'v1', 'v2')
        addi('t1', 'zero', 3)
        rep('v2', 't1')
        divv('v1', 'v1', 'v2')
        add('t1', 'zero', 'r2')
        addi('t1', 't1', 1)
        movv('v2', 't1', 0)
        addi('t1', 't1', 1)
        movv('v2', 't1', 1)
        add('t1', 'r2', 'r4')
        movv('v2', 't1', 2)
        add('t1', 't1', 'r4')
        movv('v2', 't1', 3)

        # Save pixels to memory
        svi('v1', 'v2')

        # Bilinear interpolation (second side)
        add('t1', 'r3', 'r7')
        lb('r1', 't1', 0)
        movv('v1', 'r1', 0)
        movv('v1', 'r1', 1)
        lb('r1', 't1', 1)
        rep('v2', 'r1')
        add('t1', 'zero', 'r7')
        lb('r1', 't1', 1)
        movv('v1', 'r1', 2)
        movv('v1', 'r1', 3)
        mulv('v1', 'v1', 'v3')
        mulv('v2', 'v2', 'v4')
        addv('v1', 'v1', 'v2')
        addi('t1', 'zero', 3)
        rep('v2', 't1')
        divv('v1', 'v1', 'v2')
        addi('t1', 'zero', 3)
        mul('t1', 'r4', 't1')
        add('t1', 't1', 'r2')
        addi('t1', 't1', 1)
        movv('v2', 't1', 0)
        addi('t1', 't1', 1)
        movv('v2', 't1', 1)
        add('t1', 'r4', 'r2')
        addi('t1', 't1', 3)
        movv('v2', 't1', 2)
        add('t1', 't1', 'r4')
        movv('v2', 't1', 3)

        # Save pixels to memory
        svi('v1', 'v2')

        # Bilinear interpolation (intermediate side)
        add('r1', 'r2', 'r4')
        lb('t1', 'r1', 0)
        movv('v1', 't1', 0)
        movv('v1', 't1', 1)
        lb('t1', 'r1', 3)
        movv('v2', 't1', 0)
        movv('v2', 't1', 1)
        add('r1', 'r1', 'r4')
        lb('t1', 'r1', 0)
        movv('v1', 't1', 2)
        movv('v1', 't1', 3)
        lb('t1', 'r1', 3)
        movv('v2', 't1', 2)
        movv('v2', 't1', 3)
        mulv('v1', 'v1', 'v3')
        mulv('v2', 'v2', 'v4')
        addv('v1', 'v1', 'v2')
        addi('t1', 'zero', 3)
        rep('v2', 't1')
        divv('v1', 'v1', 'v2')
        add('t1', 'r2', 'r4')
        addi('r1', 't1', 1)
        movv('v2', 'r1', 0)
        addi('t1', 't1', 2)
        movv('v2', 't1', 1)
        add('r1', 'r1', 'r4')
        movv('v2', 'r1', 2)
        add('t1', 't1', 'r4')
        movv('v2', 't1', 3)

        # Save pixels to memory
        svi('v1', 'v2')

        # Update values
        addi('r7', 'r7', 1)
        addi('r2', 'r2', 3)
        addi('r6', 'r6', 1)

        # Verify row end
        addi('t1', 'zero', 1)
        sub('t1', 'r8', 't1')
        mod('t1', 'r6', 't1')
        if(not beq('t1', 'zero', 'bilinearUpdateOffset')):
            if(not beq('zero', 'zero', 'bilinearLoop')):
                pass


def bilinearUpdateOffset():
    add('t1', 'r4', 'r4')
    addi('t1', 't1', 1)
    add('r2', 'r2', 't1')
    addi('t1', 'zero', 3)
    mul('t1', 'r8', 't1')
    add('r7', 't1', 'r7')
    addi('r7', 'r7', 1)
    if(not beq('zero', 'zero', 'bilinearLoop')):
        pass


def nearestNeighborInit():
    # Width offset = height offset = 300
    addi('r3', 'zero', 300)
    # New width = new height = 200
    addi('r4', 'zero', 200)
    # Pixel count = 10000
    addi('r5', 'zero', 10000)
    # Pixel counter = 0
    addi('r6', 'zero', 0)
    # Image segment width = 100
    addi('r8', 'zero', 100)
    # Finished flag = 0
    addi('r9', 'zero', 0)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160000)
    # First index for the output index vector
    movv('v1', 't1', 0)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160001)
    # Second index for the output index vector
    movv('v1', 't1', 1)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160200)
    # Third index for the output index vector
    movv('v1', 't1', 2)
    # Start at pixel count in memory (after input image)
    addi('t1', 'zero', 160201)
    # Fourth index for the output index vector
    movv('v1', 't1', 3)
    # Constant value 2 for v3
    addi('t1', 'zero', 2)
    rep('v3', 't1')
    nearestNeighborLoop()


def nearestNeighborLoop():
    if(not beq('r5', 'r6', 'end')):    # Here the if-else statement must be omitted
        lb('t1', 'r7', 0)
        rep('v2', 't1')
        svi('v2', 'v1')
        addv('v1', 'v1', 'v3')
        addi('r6', 'r6', 1)
        addi('r7', 'r7', 1)
        mod('t1', 'r6', 'r8')
        if(not beq('t1', 'zero', 'nearestNeighborUpdateOffset')):
            if(not beq('zero', 'zero', 'nearestNeighborLoop')):
                pass


def nearestNeighborUpdateOffset():
    rep('v2', 'r4')
    addv('v1', 'v1', 'v2')
    add('r7', 'r7', 'r3')
    if(not beq('zero', 'zero', 'nearestNeighborLoop')):
        pass


def end():
    # Finished flag = 1
    addi('r9', 'zero', 1)
    # ================================= END OF SCRIPT =================================
    if memory[249997] == 0:
        outputImage = np.array(
            memory[160000:200000].reshape(200, 200), dtype="uint8")
        outputImage = Image.fromarray(outputImage, 'L')
        outputImage.save('output.jpg')
    elif memory[249997] == 1:
        outputImage = np.array(
            memory[160000:248804].reshape(298, 298), dtype="uint8")
        outputImage = Image.fromarray(outputImage, 'L')
        outputImage.save('output.jpg')


# ================================= PYTHON MAIN =================================
init()
