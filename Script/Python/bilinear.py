from PIL.Image import new
import numpy as np

memory = np.array([0] * (16 + 100), dtype=int)
for i in range(0, 16):
    memory[i] = (i + 1) * 10


def printImage():
    print(memory[16:272].reshape(10, 10))


# ================= SCRIPT (INITIALIZATION) =================
# Initial vector values
v1 = np.array([0] * 4)
v2 = np.array([0] * 4)
v3 = np.array([2, 1, 2, 1])
v4 = np.array([1, 2, 1, 2])

# Width
widthOffset = 4

# Offset (image size, pixel count)
memoryOffset = 16

# New width offset
newWidthOffset = 10

# Image counter
imageCounter = 0

# Pixel counter
pixelCounter = 0


# ================= SCRIPT (LOOP) =================

for pixelGroup in range(0, 9):
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
    v1 = v1 / 3
    v2 = v2 * v4
    v2 = v2 / 3
    v1 = v1 + v2
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
    v1 = v1 / 3
    v2 = v2 * v4
    v2 = v2 / 3
    v1 = v1 + v2
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
    v1 = v1 / 3
    v2 = v2 * v4
    v2 = v2 / 3
    v1 = v1 + v2
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

    if pixelCounter % 3 == 0:
        memoryOffset += 2 * newWidthOffset + 1
        imageCounter += 1

printImage()
