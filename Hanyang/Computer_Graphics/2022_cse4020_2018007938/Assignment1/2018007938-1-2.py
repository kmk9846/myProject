#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import math

# A
M = np.array([])
for i in range(25):
    M = np.append(M, [i+2])

print(M)

# B
M = M.reshape(5, 5)

print(M)

# C
for i in range(5):
    M[i][0] = 0

print(M)

#D
M = M@M
print(M)

#E
vec_v = np.array([])
vec_v = np.append(vec_v, M[0])

vec_v = np.sqrt(vec_v@vec_v)
print(vec_v)
