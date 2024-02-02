#Jakub Zaroda
#Block algorithms - implementation of the PRESENT cipher
from sage.crypto.sbox import SBox

#Standard SBox and its inverse
S=SBox(0xC, 5, 6, 0xB, 9, 0, 0xA, 0xD, 3, 0xE, 0xF, 8, 4, 7, 1, 2)
SInv=SBox(5, 0xE, 0xF, 8, 0xC, 1, 2, 0xD, 0xB, 4, 6, 3, 0, 7, 9, 0xA)
 
#Generated values for the permutation array and its inverse
P=SBox(0, 16, 32, 48, 1, 17, 33, 49, 2, 18, 34, 50, 3, 19, 35, 51, 4, 20, 36, 52, 5, 21, 37, 53, 6, 22, 38, 54, 7, 23, 39, 55,
      8, 24, 40, 56, 9, 25, 41, 57, 10, 26, 42, 58, 11, 27, 43, 59, 12, 28, 44, 60, 13, 29, 45, 61, 14, 30, 46, 62, 15, 31, 47, 63)
PInv=SBox(0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 2,
       6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63)
 
    
#Function performing a cyclic left shift of 61 bits    
def cyclicShift(n):
    return ((n & 2**19-1)<<61)+(n>>19)

#Function generating round keys based on the master key (in hex format)
#Returns an array of round keys
def generateRoundKeys(masterKey):
    K=[]
    register=masterKey
    
    #Casting the master key to an integer
    register=int(hex(register), 16)

    
    #Uncomment the lines containing "print()" to display intermediate states
    #The loop performs:
    #  - adding the 64 most left bits of the register to the key array
    #  - shifting the register to the left by 61 bits
    #  - updating the register by changing the 4 most left bits through the SBox
    #  - updating the register by XORing with the round counter modulo 2 in bits at positions [15-19]
    for i in range (0, 31):
        K.append(register>>16)
        register=cyclicShift(register)
        #print("SHIFT", hex(register))
        register=(S(register>>76)<<76)+(register & 2**76-1)
        #print("SBOX",hex(register))
        register=register ^^ (i+1 << 15)
        #print("\nXOR", hex(register))
        
    #Adding the last round key  
    K.append(register>>16)    
    return K
 
    
#Function adding a round key through XOR operation
def addRoundKey(state, key):
    return state ^^ key

#Function implementing the nonlinear layer using SBoxes
#The result is the value obtained by passing through SBoxes of the next 4 bits from the right
#This is done by appropriately shifting the current state to the right by i times 4
#Performing AND operation with the value 1111b
#The obtained value passes through the SBox, and the value from the SBox is added to the result
#after shifting it to the left also by i times 4
def sBoxLayer(state):
    ret=0
    for i in range(0,16):
        ret+=S((state>>i*4) & 0xF) << i*4
    return ret

#Function implementing the nonlinear layer during decryption using inverted SBoxes
#Similar to the sBoxLayer() function
#The result is the value after passing through the inverted SBox - SInv
def sBoxLayerInv(state):
    ret=0
    for i in range(0,16):
        ret+=SInv((state>>i*4) & 0xF) << i*4
    return ret  



#Function implementing the linear layer using permutation arrays
#The result is a number with appropriately swapped bits
#This is done by shifting the current state to the right by i bits
#Performing AND operation with the value 1b
#Shifting the current bit by i-th position from the permutation array to the left
def pLayer(state):
    output = 0
    for i in range(64):
         output += ((state >> i) & 0x01) << P(i)
    return output

#Function implementing the linear layer during decryption using inverted permutation arrays
#Similar to the pLayer() function
#The result is the value after passing through the inverted permutation array - PInv
def pLayerInv(state):
    output = 0
    for i in range(64):
         output += ((state >> i) & 0x01) << PInv(i)
    return output

#Encryption function
# INPUT:
# plainText - plaintext - in hex format
# key - master key - in hex format
# Round key array is generated
# Then, 31 encryption rounds are performed using the functions:
# addRoundKey()
# sBoxLayer()
# pLayer()
# after the last round, the last round key is added
def encrypt(plainText, key):  
    K=generateRoundKeys(key)
    state=plainText
    state=int(hex(state), 16)

    for i in range (0, 31):
        state=addRoundKey(state,K[i])
        #print("\nKEY: ", hex(K[i]))
        #print("XOR KEY",hex(state))
        state=sBoxLayer(state)
        #print("SBOX",hex(state))
        state=pLayer(state)
        #print("Player",hex(state))

    state=addRoundKey(state,K[31])
    #print("Koncowy",hex(state))
    return state
    

#Decryption function
# INPUT:
# cipherText - encrypted text - in hex format
# key - master key - in hex format
# Round key array is generated
# Then, 31 decryption rounds are performed using the functions:
# addRoundKey()
# pLayerInv()
# sBoxLayerInv()
# after the last round, the last (first) round key is added
def decrypt(cipherText, key):  
    K=generateRoundKeys(key)
    state=cipherText
    state=int(hex(state), 16)

    for i in range (0, 31):
        state=addRoundKey(state,K[31-i])
        #print("\nKEY",hex(K[31-i]))
        #print("XOR KEY",hex(state))
        
        state=pLayerInv(state)
        #print("Player",hex(state))
        
        state=sBoxLayerInv(state)
        #print("SBOX",hex(state))

    state=addRoundKey(state,K[0])
    #print("Koncowy",hex(state))
    return state



plainText=0xffffffffffffffff
masterKey=0x00000000000000000000
cipherText=encrypt(plainText,masterKey)
decryptedText=decrypt(cipherText,masterKey)

print("Plaintext: ", hex(plainText))
print("Master Key: ", hex(masterKey))
print("Ciphertext: ", hex(cipherText))
print("Decrypted Plaintext: ", hex(decryptedText))