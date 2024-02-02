//JAKUB ZARODA - PRESENT ENCRYPTION 8Bit max 1kB
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
//Standard SBox
const uint8_t sBox[]={0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2};

int main()
{
    uint8_t key[] =	{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    volatile uint8_t state[] = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
    uint8_t tmpState[8];

    uint8_t round=0;
    uint8_t i;
    uint8_t bitPosition;
    uint8_t sourceByte;
    uint8_t sourceBit;
    uint8_t destByte;
    uint8_t destBit;

    printf("\nMESSAGE\t\t");
    for (i = 0; i < 8; i++) {
        printf("%02X", state[i]);
    }

    printf("\nKEY\t\t");
    for (i = 0; i < 10; i++) {
        printf("%02X", key[i]);
    }


    for(round=0;round<=30;round++){
        //printf("\Round =%d", round);                 Test vectors


        //Adding round key
        for(i=0;i<8;i++){
            state[i]=state[i]^key[i];
        }

        //printf("\nKey round\t");                  Test vectors
        //for (i = 0; i < 8; i++) {
        //    printf("%02X", key[i]);
        //}


        //printf("\nAfter adding round key\t");              Test vectors
        //for (i = 0; i < 8; i++) {
        //    printf("%02X", state[i]);
        //}


        //SBOXlayer
        for(i=0;i<8;i++){
            state[i]=sBox[state[i]>>4]<<4 | sBox[state[i] & 0xF];
        }

        //printf("\nAfter SBox\t");                        Test vectors
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
            tmpState[destByte]= tmpState[destByte]|(((state[sourceByte]>>sourceBit)&0x1)<<destBit);
        }
        for(i=0;i<8;i++){
            state[i]=tmpState[i];
        }

        //printf("\nAfter permutation\t");                  Test vectors
        //for (i = 0; i < 8; i++) {
        //    printf("%02X", state[i]);
        //}


        //Key schedule
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

        if((round+1) % 2 == 1)
            key[8] ^= 128;
        key[7] = key[7]^((round+1)>>1);
    }

    //Adding the last round key
    for(i=0;i<8;i++){
        state[i]=state[i]^key[i];
    }

    printf("\nCIPHERTEXT\t");
    for (i = 0; i < 8; ++i) {
        printf("%02X", state[i]);
    }

    return 0;
}
