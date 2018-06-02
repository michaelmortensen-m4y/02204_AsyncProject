import numpy as np
import math


max_tests = 1000
min_num = 1 # May never be 0!
max_num = 2**7-1
max_bits = math.ceil(math.log2(max_num))
max_hex = math.ceil(max_bits/4)

A = np.random.randint(min_num, max_num, size = max_tests)
B = np.random.randint(min_num, max_num, size = max_tests)
C = np.empty(max_tests, int)

for i in range(0, max_tests):
	C[i] = int(math.gcd(A[i], B[i]))

vhex = np.vectorize(hex) # Just use bin instead of and later we should not divide
# or something like that

A = vhex(A)
A = [s.replace('0x', 'X') for s in A]

B = vhex(B)
B = [s.replace('0x', 'X') for s in B]

C = vhex(C)
C = [s.replace('0x', 'X') for s in C]

for i in range(0, max_tests):
	A[i] =  A[i][0] + '"' + (max_hex+1-len(A[i]))*'0' + A[i][1:] + '",'

for i in range(0, max_tests):
	B[i] =  B[i][0] + '"' + (max_hex+1-len(B[i]))*'0' + B[i][1:] + '",'

for i in range(0, max_tests):
	C[i] =  C[i][0] + '"' + (max_hex+1-len(C[i]))*'0' + C[i][1:] + '",'

np.savetxt('A.in', A, delimiter=' ', fmt='%s')
np.savetxt('B.in', B, delimiter=' ', fmt='%s')
np.savetxt('C.in', C, delimiter=' ', fmt='%s')