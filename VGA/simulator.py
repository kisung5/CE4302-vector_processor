from PIL import Image
import os

# IMAGE DATA
IMAGE_EXTENSION = "png"

# VGA DATA
FRAMES = 2
H_BACK_PORCH = 143
H_FRONT_PORCH = 784
V_BACK_PORCH = 34
V_FRONT_PORCH = 515
WIDTH = 800
HEIGHT = 525
SIZE = WIDTH * HEIGHT
# NOTE: This simulator assumes a 1 pixel by sample ratio and a 640x480 display

# OPEN TESTBENCH FILE
DIRECTORY = open(os.path.dirname(os.getcwd()) +
                 '\\ProyectoGrupalI\\quartus_directory.txt', 'r').read()
FILE = open(DIRECTORY + '\\monitor_inputs.txt', "r")
PIXEL_INFO = FILE.read().split('\n')
# NOTE: Testbench pixel info format = h_sync (1b) v_sync (1b) red (3b) green (3b) blue (2b)

# ARRAYS
current_image = []

# PROCESS EVERY FRAME
h_counter = 0
v_counter = 0
frame_counter = 0
pixel = 0
v_sync = '1'
h_sync = '1'

while (frame_counter < FRAMES):
    # Extract pixel information from file
    current_pixel = PIXEL_INFO[pixel].split(' ')
    new_h_sync = current_pixel[0]
    new_v_sync = current_pixel[1]
    # Posedge of v_sync
    if(v_sync == '0' and new_v_sync == '1'):
        # Save frame to image file
        img = Image.new('L', (640, 480))
        img.putdata(current_image)
        img.save("VGA/Simulator outputs/frame" + str(frame_counter + 1) +
                 "." + IMAGE_EXTENSION)
        # Update variables
        v_counter = 0
        h_counter = 0
        frame_counter += 1
        current_image.clear()
    # Posedge of h_sync
    elif(h_sync == '0' and new_h_sync == '1'):
        v_counter += 1
        h_counter = 0
    # Adressable video
    elif(H_BACK_PORCH < h_counter < H_FRONT_PORCH and V_BACK_PORCH < v_counter < V_FRONT_PORCH):
        rgb = current_pixel[2]
        rgb = int(rgb, 2)
        current_image.append(rgb)
    # Update values
    v_sync = new_v_sync
    h_sync = new_h_sync
    h_counter += 1
    pixel += 1
