import numpy as np
from PIL import Image

f = open("image_output.img", "r")
output = f.readlines()
f.close()

counter = 0
for byte in output:
    output[counter] = int(byte,2)
    counter += 1

if counter > 40000:
    WIDTH = 298
    HEIGHT = 298
else:
    WIDTH = 200
    HEIGHT = 200

output = np.array(output, dtype="uint8")
# int(output, 2)
output = output[0:WIDTH*HEIGHT].reshape((HEIGHT, WIDTH))
outputImage = Image.fromarray(output, 'L')
outputImage.save('output.jpg')
