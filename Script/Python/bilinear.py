# ================================= IMPORTS =================================
import numpy as np
from PIL import Image
import resource
import sys
resource.setrlimit(resource.RLIMIT_STACK, (2**29, -1))
sys.setrecursionlimit(10**6)


# ================================= INITIAL PARAMETERS =================================

# 400x400 [100x100] -> 1198x1198 [298x298]
memory = np.array([0] * 248804, dtype=int)


def printImage():
    print("Original")
    print(memory[0:160000].reshape(400, 400))
    print("Scaled")
    print(memory[160000:248804].reshape(298, 298))


# ================================= IMAGE READ =================================


inputImage = Image.open("image.jpg").convert('L')
inputImage.load()
inputImage = np.asarray(inputImage, dtype="uint8")
outputImage = Image.fromarray(inputImage, 'L')
outputImage.save('input.jpg')
inputImage = inputImage.flatten()

test = False

# ================================= IMAGE TO MEMORY =================================

if test:
    for i in range(0, 160000):
        memory[i] = i + 1
else:
    memory[0:160000] = inputImage[0:160000]
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

for switch in range(1, 17):
    # ================= SCRIPT (INITIALIZATION) =================
    # Initial vector values
    v1 = np.array([0] * 4)
    v2 = np.array([0] * 4)
    v3 = np.array([2, 1, 2, 1])
    v4 = np.array([1, 2, 1, 2])

    # Width
    widthOffset = 400

    # Section width
    sectionWidth = 100

    # Offset (image size, pixel count)
    memoryOffset = 160000

    # New width offset
    newWidthOffset = 298

    # Image counter
    imageCounter = switches[str(switch)]

    # Pixel counter
    pixelCounter = 0

    # Total iterations
    pixelCount = 9801

    # ================= SCRIPT (LOOP) =================

    while pixelCounter < pixelCount:
        # Copy current values to the bigger image matrix
        v1[0:2] = np.array(memory[imageCounter:imageCounter + 2])
        v1[2:4] = np.array(memory[imageCounter + widthOffset:
                                  imageCounter + 2 + widthOffset])
        v2 = [0 + memoryOffset,
              3 + memoryOffset,
              3 * newWidthOffset + memoryOffset,
              3 + 3 * newWidthOffset + memoryOffset]

        # Save it to memory
        for i in range(0, 4):
            memory[v2[i]] = v1[i]

        # Bilinear interpolation (first side)
        v1[0:4] = np.array([memory[imageCounter]] * 4)
        v2[0:2] = np.array([memory[imageCounter + 1]] * 2)
        v2[2:4] = np.array([memory[imageCounter + widthOffset]] * 2)
        v1 = v1 * v3
        v2 = v2 * v4
        v1 = v1 + v2
        v1 = v1 / 3
        v2 = [1 + memoryOffset,
              2 + memoryOffset,
              memoryOffset + newWidthOffset,
              memoryOffset + 2 * newWidthOffset]

        # Save it to memory
        for i in range(0, 4):
            memory[v2[i]] = v1[i]

        # Bilinear interpolation (second side)
        v2[0:4] = np.array([memory[imageCounter + widthOffset + 1]] * 4)
        v1[0:2] = np.array([memory[imageCounter + widthOffset]] * 2)
        v1[2:4] = np.array([memory[imageCounter + 1]] * 2)
        v1 = v1 * v3
        v2 = v2 * v4
        v1 = v1 + v2
        v1 = v1 / 3
        v2 = [memoryOffset + 3 * newWidthOffset + 1,
              memoryOffset + 3 * newWidthOffset + 2,
              memoryOffset + 1 * newWidthOffset + 3,
              memoryOffset + 2 * newWidthOffset + 3]

        # Save it to memory
        for i in range(0, 4):
            memory[v2[i]] = v1[i]

        # Bilinear interpolation (intermediate pixels)
        v1[0:2] = np.array([memory[memoryOffset + newWidthOffset]] * 2)
        v1[2:4] = np.array([memory[memoryOffset + 2 * newWidthOffset]] * 2)
        v2[0:2] = np.array([memory[memoryOffset + newWidthOffset + 3]] * 2)
        v2[2:4] = np.array([memory[memoryOffset + 2 * newWidthOffset + 3]] * 2)
        v1 = v1 * v3
        v2 = v2 * v4
        v1 = v1 + v2
        v1 = v1 / 3
        v2 = [memoryOffset + newWidthOffset + 1,
              memoryOffset + newWidthOffset + 2,
              memoryOffset + 2 * newWidthOffset + 1,
              memoryOffset + 2 * newWidthOffset + 2]

        # Save it to memory
        for i in range(0, 4):
            memory[v2[i]] = v1[i]

        imageCounter += 1
        memoryOffset += 3
        pixelCounter += 1

        if pixelCounter % (sectionWidth - 1) == 0:
            memoryOffset += 2 * newWidthOffset + 1
            imageCounter += 3 * sectionWidth + 1

    printImage()

    if not test:
        outputImage = np.array(
            memory[160000:248804].reshape(298, 298), dtype="uint8")
        outputImage = Image.fromarray(outputImage, 'L')
        outputImage.save('outputBilinear' + str(switch) + '.jpg')
