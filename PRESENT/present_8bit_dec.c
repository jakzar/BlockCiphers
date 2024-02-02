//JAKUB ZARODA - PRESENT DECRYPTION 8Bit max 1kB
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

//Standard SBox
const uint8_t invSBox[]={0x5,0xe,0xf,0x8,0xc,0x1,0x2,0xd,0xb,0x4,0x6,0x3,0x0,0x7,0x9,0xa};
//Standard inverse SBox
const uint8_t sBox[]={0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2};


int main()
{
    uint8_t key[] =	{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    volatile uint8_t state[] = {0xa1,0x12,0xff,0xc7,0x2f,0x68,0x41,0x7b};
    uint8_t tmpState[8];

    uint8_t round=0;
    uint8_t i;
    uint8_t j;
    uint8_t bitPosition;
    uint8_t sourceByte;
    uint8_t sourceBit;
    uint8_t destByte;
    uint8_t destBit;
    uint8_t keyCp[10];

    //Copying key
    for (i = 0; i < 10; i++) {
        keyCp[i] = key[i];
    }


    printf("\nCIPHERTEXT\t\t");
    for (i = 0; i < 8; i++) {
        printf("%02X", state[i]);
    }

    printf("\nKEY\t\t\t");
    for (i = 0; i < 10; i++) {
        printf("%02X", key[i]);
    }


    for(round=0;round<=30;round++){
        //printf("\n%d",round);                         Test vectors
        for (i = 0; i < 10; i++) {
            key[i] = keyCp[i];
        }

        //Determining the round key
        for(j=0;j<31-round;j++){
            uint8_t k1=key[7];
            uint8_t k2=key[8];
            uint8_t k3=key[9];

            for(i=0;i<7;i++){
                key[9-i]=key[6-i];
            }
            key[0]=k1;
            key[1]=k2;
            key[2]=k3;

            k1=key[0];
            for(i=0;i<9;i++){
                key[i]=key[i]<<5 | key[i+1]>>3;
            }
            key[9]=key[9]<<5|k1>>3;
            k1=key[0];
            k2=key[0];
            k2=k2>>4;
            k2=sBox[k2];
            k3=k1<<4;
            k2=k2<<4|k3>>4;
            key[0]=k2;

            if((j+1) % 2 == 1)
                key[8] ^= 128;
            key[7] = key[7]^((j+1)>>1);
        }

        //printf("\nKey");                            Test vectors
        //for (i = 0; i < 10; i++) {
        //    printf("\t%02X", key[i]);
        //}


        //Adding round key
        for(i=0;i<8;i++){
            state[i]=state[i]^key[i];
        }

        //printf("\nAfter adding round key\t");             Test vectors
        //for (i = 0; i < 8; i++) {
        //    printf("%02X", state[i]);
        //}




        //Permutation layer
        for(i=0;i<8;i++){
            tmpState[i]=0;
        }

        for(i=0;i<64;i++){
            bitPosition=(16*i)%63;
            if(i==63){
                bitPosition=63;
            }
            sourceByte=7-(i/8);
            sourceBit=i%8;
            destByte=7-(bitPosition/8);
            destBit=bitPosition%8;
            tmpState[sourceByte]= tmpState[sourceByte]|(((state[destByte]>>destBit)&0x1)<<sourceBit);
        }
        for(i=0;i<8;i++){
            state[i]=tmpState[i];
        }

        //printf("\nAfter permutation layer\t");             Test vectors
        //for (i = 0; i < 8; i++) {
        //    printf("%02X ", state[i]);
        //}

        //Sbox layer
        for(i=0;i<8;i++){
            state[i]=invSBox[state[i]>>4]<<4 | invSBox[state[i] & 0xF];
        }

        //printf("\nAfter SBox\t");             Test vectors
        //for (i = 0; i < 8; i++) {
        //    printf("%02X ", state[i]);
        //}
    }

    //Adding last round key
    for(i=0;i<8;i++){
        state[i]=state[i]^keyCp[i];
    }

    printf("\nDeciphered text\t\t");
    for (i = 0; i < 8; i++) {
        printf("%02X", state[i]);
    }



    return 0;
}
