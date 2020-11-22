import numpy as np
from PIL import Image


FACTOR = 4
INCREMENT = FACTOR // 2      # = 2
WIDTH = 400
HEIGHT = 400
NEW_WIDTH = INCREMENT * WIDTH
NEW_HEIGHT = INCREMENT * HEIGHT
PIXEL_COUNT = WIDTH * HEIGHT


inputImage = Image.open("image.jpg").convert('L')
inputImage.load()
inputImage = np.asarray(inputImage, dtype="uint8")
outputImage = Image.fromarray(inputImage, 'L')
outputImage.save('input.jpg')
print(inputImage)


output = np.array([0] * PIXEL_COUNT * FACTOR, dtype="float")  # Memory


counter = 0
image = np.array([0] * PIXEL_COUNT)
for i in range(0, HEIGHT):
    for j in range(0, WIDTH):
        image[counter] = inputImage[i][j]
        counter += 1


def saveInIndex(valueArray, indexArray, vectorSize):
    for i in range(0, vectorSize):
        output[indexArray[i]] = valueArray[i]


def nearestNeighbor():
    pixelCounter = 0
    offset = np.array([0, 1, NEW_WIDTH, NEW_WIDTH + 1])
    while(pixelCounter < PIXEL_COUNT):
        saveInIndex(np.array([image[pixelCounter]] * 4), offset, 4)
        offset += 2
        pixelCounter += 1
        if(pixelCounter % WIDTH == 0):
            offset += NEW_WIDTH


nearestNeighbor()


counter = 0
convertedImage = []
for i in range(0, NEW_HEIGHT):
    convertedImage.append(output[NEW_WIDTH * i: NEW_WIDTH * i + NEW_WIDTH])
convertedImage = np.array(convertedImage, dtype="uint8")
outputImage = Image.fromarray(convertedImage, 'L')
outputImage.save('outputNearestNeighbor.jpg')
