import numpy as np
from PIL import Image

inputImage = Image.open("image.jpg").convert('L')
inputImage.load()
inputImage = np.asarray(inputImage, dtype="uint8")

f = open("input.txt", "w")
for row in inputImage:
    for pixel in row:
        f.write(str(pixel) + "\n")
f.close()
