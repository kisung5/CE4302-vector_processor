import numpy as np
from PIL import Image

WIDTH = 400
HEIGHT = 400

f = open("input.txt", "r")
output = f.readlines()
f.close()

output = np.array(output, dtype="uint8")
output = output.reshape((HEIGHT, WIDTH))
outputImage = Image.fromarray(output, 'L')
outputImage.save('output.jpg')
