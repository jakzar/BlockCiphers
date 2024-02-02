from sage.crypto.sbox import SBox
#Generated SBox
S=SBox(121, 120, 239, 157, 50, 37, 11, 188, 202, 58, 87, 132, 64, 69, 141, 77, 182, 142, 206, 75, 110, 144, 145, 109, 243, 95, 103, 163, 3, 201, 99, 162, 136, 48, 148, 18, 180, 195, 96, 242, 228, 135, 155, 128, 13, 212, 115, 133, 60, 152, 106, 207, 118, 140, 20, 216, 68, 117, 33, 252, 116, 65, 130, 197, 151, 246, 203, 112, 153, 73, 218, 138, 137, 88, 36, 125, 227, 225, 170, 210, 161, 176, 6, 38, 8, 240, 147, 4, 67, 253, 185, 31, 124, 51, 7, 42, 205, 179, 159, 165, 230, 187, 34, 184, 232, 0, 149, 90, 217, 79, 191, 244, 241, 45, 127, 189, 85, 213, 173, 249, 233, 16, 101, 200, 146, 46, 39, 43, 14, 172, 168, 166, 32, 66, 235, 175, 9, 44, 97, 94, 190, 22, 150, 56, 1, 17, 255, 174, 193, 222, 123, 156, 52, 226, 53, 224, 134, 81, 186, 29, 21, 78, 139, 63, 208, 214, 192, 236, 215, 221, 171, 54, 12, 84, 209, 220, 100, 2, 59, 113, 25, 178, 74, 107, 237, 223, 92, 181, 70, 131, 198, 199, 35, 30, 28, 231, 10, 126, 23, 245, 160, 40, 24, 204, 194, 93, 143, 105, 167, 251, 211, 55, 15, 248, 254, 234, 41, 177, 98, 102, 26, 158, 169, 250, 61, 72, 83, 129, 122, 238, 27, 164, 111, 108, 47, 5, 19, 91, 57, 247, 49, 89, 219, 62, 119, 76, 183, 104, 154, 82, 196, 71, 86, 114, 80, 229)
invS=S.inverse() 
#Extended binary field
K = GF(2^8, 'a', modulus=x^8+x^5+x^3+x^2+1, repr='int')
K.inject_variables()
PK.<x>=K[]
#Permutation layer
def changeBytes(byte_array):
    retA=[]
    retA.append(byte_array[3])
    retA.append(byte_array[7])
    retA.append(byte_array[11])
    retA.append(byte_array[0])
    retA.append(byte_array[4])
    retA.append(byte_array[5])
    retA.append(byte_array[6])
    retA.append(byte_array[1])
    retA.append(byte_array[8])
    retA.append(byte_array[9])
    retA.append(byte_array[10])
    retA.append(byte_array[2])
    return retA
#Conversion of hexadecimal numbers to a bit array
def hexToArray(hex_number):
    decimal_number = int(hex_number, 16)
    byte_array = []
    for i in range(12):
        byte_value = (decimal_number >> (i * 8)) & 0xFF
        byte_array.insert(0, byte_value) 
    return byte_array


def hexToArrayKey(hex_number):
    decimal_number = int(hex_number, 16)
    byte_array = []
    for i in range(16):
        byte_value = (decimal_number >> (i * 8)) & 0xFF
        byte_array.insert(0, byte_value) 
    return byte_array

#Conversion of an array of hexadecimal numbers to a decimal number
def arrayToHex(byte_array):
    combined_number = 0
    for byte in byte_array:
        combined_number = (combined_number << 8) | byte
    return combined_number
#Conversion of a bit array to a decimal number
def listToInt(binary):
    ret=0
    for i in range (0, len(binary)):
        if(binary[i]==1):
            ret=ret+2**(i)
    return ret
#Confusin layer
def sLayer(byte_array):
    sArray=[]
    for i in range(12):
        sArray.append(S(byte_array[i]))
    return sArray
 
def invSLayer(byte_array):
    sArray=[]
    for i in range(12):
        sArray.append(invS(byte_array[i]))
    return sArray
#Generating MDS
def genMDS():
    a11=[int(i) for i in bin(111)[2:]]
    a12=[int(i) for i in bin(146)[2:]]
    a13=[int(i) for i in bin(184)[2:]]
    a21=[int(i) for i in bin(108)[2:]]
    a22=[int(i) for i in bin(61)[2:]]
    a23=[int(i) for i in bin(247)[2:]]
    a31=[int(i) for i in bin(14)[2:]]
    a32=[int(i) for i in bin(56)[2:]]
    a33=[int(i) for i in bin(64)[2:]]
    a11.reverse()
    a12.reverse()
    a13.reverse()
    a21.reverse()
    a22.reverse()
    a23.reverse()
    a31.reverse()
    a32.reverse()
    a33.reverse()
    MDS=matrix([[K(a11), K(a12), K(a13)],[K(a21), K(a22), K(a23)],[K(a31), K(a32), K(a33)]])
    return MDS
#Multiplying MDS by vector
def inMDS(s1,s2,s3):
    s1=[int(i) for i in bin(s1)[2:]]
    s2=[int(i) for i in bin(s2)[2:]]
    s3=[int(i) for i in bin(s3)[2:]]
    s1.reverse()
    s2.reverse()
    s3.reverse()
    w=vector([K(s1),K(s2),K(s3)])
    MDS=genMDS()
    ret=MDS*w
    w1=ret[0].list()
    w2=ret[1].list()
    w3=ret[2].list()
    w1=listToInt(w1)
    w2=listToInt(w2)
    w3=listToInt(w3)
    return w1,w2,w3

 
def invInMDS(s1,s2,s3):
    s1=[int(i) for i in bin(s1)[2:]]
    s2=[int(i) for i in bin(s2)[2:]]
    s3=[int(i) for i in bin(s3)[2:]]
    s1.reverse()
    s2.reverse()
    s3.reverse()
    w=vector([K(s1),K(s2),K(s3)])
    MDS=genMDS()
    MDS=MDS.inverse()
    ret=MDS*w
    w1=ret[0].list()
    w2=ret[1].list()
    w3=ret[2].list()
    w1=listToInt(w1)
    w2=listToInt(w2)
    w3=listToInt(w3)
    return w1,w2,w3    

#Transform layer using MDS
def mdsLayer(byte_array):
    mdsArray=[]
    for i in range (4):
        w1,w2,w3=inMDS(byte_array[3*i],byte_array[3*i+1],byte_array[3*i+2])
        mdsArray.append(w1)
        mdsArray.append(w2)
        mdsArray.append(w3)
    return mdsArray
 
def invMdsLayer(byte_array):
    mdsArray=[]
    for i in range (4):
        w1,w2,w3=invInMDS(byte_array[3*i],byte_array[3*i+1],byte_array[3*i+2])
        mdsArray.append(w1)
        mdsArray.append(w2)
        mdsArray.append(w3)
    return mdsArray
 
#Function rotating words
def rotWord(word):
    tmp=[]
    tmp.append(word[1])
    tmp.append(word[2])
    tmp.append(word[3])
    tmp.append(word[0])
    return tmp
#Function substituting words using SBox   
def subWord(word):
    for i in range (0,4):
        word[i]=S(word[i])
    return word
 
rTable=[1, 2, 4, 8, 16, 32, 64, 128, 27, 54, 108, 216]    

#Helper function for performing XOR operations on groups A, B, C, D
def XORcols(A,B,C,D,pointer):
    A[0]=A[0]^^pointer[0]
    A[1]=A[1]^^pointer[1]
    A[2]=A[2]^^pointer[2]
    A[3]=A[3]^^pointer[3]
    B[0]=B[0]^^A[0]
    B[1]=B[1]^^A[1]
    B[2]=B[2]^^A[2]
    B[3]=B[3]^^A[3]
    C[0]=C[0]^^B[0]
    C[1]=C[1]^^B[1]
    C[2]=C[2]^^B[2]
    C[3]=C[3]^^B[3]
    D[0]=D[0]^^C[0]
    D[1]=D[1]^^C[1]
    D[2]=D[2]^^C[2]
    D[3]=D[3]^^C[3]
    return A,B,C,D
 
#Key schedule
def keySchedule(key):
    R=hexToArrayKey(key)
    kTable=[]
    A=[]
    B=[]
    C=[]
    D=[]
    for i in range (0,4):
        A.append(R[i])
        B.append(R[4+i])
        C.append(R[8+i])
        D.append(R[12+i])
    for i in range (0,12):
        pointer=rotWord(D)
        pointer=subWord(pointer)
        pointer[0]=pointer[0]^^rTable[i]
        A,B,C,D=XORcols(A,B,C,D,pointer)
        tmpA=A
        tmpB=B
        tmpC=C
        tmpD=D
        
        A=tmpD
        B=tmpA
        C=tmpB
        D=tmpC
        M=[]
        M.append(B[0])
        M.append(B[1])
        M.append(B[2])
        M.append(B[3])
        M.append(C[0])
        M.append(C[1])
        M.append(C[2])
        M.append(C[3])
        M.append(D[0])
        M.append(D[1])
        M.append(D[2])
        M.append(D[3])
        M=arrayToHex(M)
        kTable.append(M)
        #print(hex(M))
    return kTable
 

def XORkey(key, m):
    key=hexToArray(hex(key))
    output=[]
    for i in range (0, len(m)):
        output.append(key[i]^^m[i])
    return output

def encrypt(m,key):
    kTable=keySchedule(key)
    A=hexToArray(m)
    for i in range (0,10):
        A=XORkey(kTable[i],A)
        A=sLayer(A)
        A=mdsLayer(A)
        A=changeBytes(A)
    A=arrayToHex(A) 
    A=hex(A)
    return A
 

def decrypt(m,key):
    kTable=keySchedule(key)
    A=hexToArray(m)
    for i in range (0,10):
        A=changeBytes(A)
        A=invMdsLayer(A)
        A=invSLayer(A)
        A=XORkey(kTable[9-i],A)
    A=arrayToHex(A) 
    A=hex(A)
    return A
    
MKey="0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"    
M="0x112233445566778899aabbcc"
C=encrypt(M,MKey)
D=decrypt(C,MKey)

print("Key: ",MKey)
print("Message: ",M)
print("Ciphertext: ",C)
print("Decrypted message: ",D)