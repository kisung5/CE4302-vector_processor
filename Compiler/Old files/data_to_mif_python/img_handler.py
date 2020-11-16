from PIL import Image
import numpy as np
import sys


def txt_to_mif():
    # This function extracts the data from the source text file.
    # Image in '6.txt' file, using int values
    data_file = open("6.txt", "r")
    lines = data_file.readlines()
    data_file.close()
    data_stream = lines[5]
    data_stream = data_stream.split()
    bitmap = np.array(data_stream)
    bitmap = bitmap.astype(np.uint8)
    string_array = ["DEPTH = " + str(len(bitmap) + int(len(bitmap)/2)) + ";\n",
                    "WIDTH = " + str(8) + ";\n",
                    "ADDRESS_RADIX = DEC;\n",
                    "DATA_RADIX = DEC;\n",
                    "CONTENT\n", "BEGIN\n"]

    counter = 0
    for i in bitmap:
        temp_string = str(counter) + " : "
        temp_string += str(i)
        temp_string += ";\n"
        string_array.append(temp_string)
        counter += 1
    for j in range(int(len(bitmap)/2)):
        temp_string = str(counter) + " : "
        temp_string += str(0)
        temp_string += ";\n"
        string_array.append(temp_string)
        counter += 1

    string_array.append("END;")
    # Save raw data/metadata
    raw_file = open("data.mif", "w")
    raw_file.writelines(string_array)
    raw_file.close()


def rsa():
    # This function executes the rsa decryption method to 6.txt
    data_file = open("6.txt", "r")
    lines = data_file.readlines()
    data_stream = lines[5]
    data_stream = data_stream.split()

    data_array = []
    counter = 0
    d = 569
    n = 3953
    encrypt_array = []
    # print(int(len(data_stream)/2))
    # print(int(data_stream[counter]) * 256 + int(data_stream[counter + 1]))

    for i in range(int(len(data_stream)/2)):
        e_number = int(data_stream[counter])*256 + int(data_stream[counter+1])
        encrypt_array.append(e_number)
        number = (e_number ** d) % n
        data_array.append(number)
        counter += 2

    print(max(encrypt_array))  # max encrypt number 3931 = 1111 0101 1011
    print(len(data_array))
    bitmap = np.array(data_array)
    bitmap = np.array(bitmap).reshape([320, 320])
    bitmap = bitmap.astype(np.uint8)
    im = Image.fromarray(bitmap)
    im.save('image.jpg', 'jpeg')


def bin_to_jpeg():
    data_array = []
    # Open temp file with raw data
    f1 = open(r"output.bin", "rb")
    data = f1.read()  # read them as int8
    f1.close()

    for byte in data:
        data_array.append(byte)

    bitmap = np.array(data_array)
    bitmap = np.array(bitmap).reshape([640, 480])
    bitmap = bitmap.astype(np.uint8)
    im = Image.fromarray(bitmap)
    im.save('image_mips.jpg', 'jpeg')


# if __name__ == '__main__':
#     # get the second argument from the command line
#
#     if len(sys.argv) == 2:
#         globals()[sys.argv[1]]()
#     else:
#         globals()[sys.argv[1]](sys.argv[2])
