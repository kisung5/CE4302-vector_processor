import numpy as np

memory = np.array([0] * (4 + 16), dtype='uint8')
memory[0:4] = np.array([10, 20, 30, 40])

# ================= SCRIPT =================
# Initial vector values
v1 = np.array([0] * 4)
v2 = np.array([0] * 4)
v3 = np.array([2, 1, 2, 1])
v4 = np.array([1, 2, 1, 2])

# Initial register
offset = 4

# Generate bigger image matrix
v1 = np.array(memory[0:4])
v2 = [0 + offset, 3 + offset, 12 + offset, 15 + offset]

# Save it to memory
for i in range(0, 4):
    memory[v2[i]] = v1[i]

# Bilinear interpolation (first side)
v1[0:4] = np.array([memory[0]] * 4)
v2[0:2] = np.array([memory[1]] * 2)
v2[2:4] = np.array([memory[2]] * 2)
v1 = v1 * v3
v1 = v1 // 3
v2 = v2 * v4
v2 = v2 // 3
v1 = v1 + v2
v2 = [1 + offset, 2 + offset, 4 + offset, 8 + offset]

# Save it to memory
for i in range(0, 4):
    memory[v2[i]] = v1[i]

# Bilinear interpolation (second side)
v2[0:4] = np.array([memory[3]] * 4)
v1[0:2] = np.array([memory[2]] * 2)
v1[2:4] = np.array([memory[1]] * 2)
v1 = v1 * v3
v1 = v1 // 3
v2 = v2 * v4
v2 = v2 // 3
v1 = v1 + v2
v2 = [13 + offset, 14 + offset, 7 + offset, 11 + offset]

# Save it to memory
for i in range(0, 4):
    memory[v2[i]] = v1[i]

# Bilinear interpolation (intermediate pixels)
v1[0:2] = np.array([memory[offset + 4]] * 2)
v1[2:4] = np.array([memory[offset + 8]] * 2)
v2[0:2] = np.array([memory[offset + 7]] * 2)
v2[2:4] = np.array([memory[offset + 11]] * 2)
v1 = v1 * v3
v1 = v1 // 3
v2 = v2 * v4
v2 = v2 // 3
v1 = v1 + v2
v2 = [5 + offset, 6 + offset, 9 + offset, 10 + offset]

# Save it to memory
for i in range(0, 4):
    memory[v2[i]] = v1[i]
print(memory)
