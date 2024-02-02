# Custom Block Cipher in SageMath

In this repository, you will find the implementation of my own cipher created as part of the Block Cipher Algorithms course during my studies.

## Table of Contents

1. [Introduction](#introduction)
2. [Parameters](#parameters)
3. [Versions of algorithm](#versions-of-algorithm)
4. [Setup and Requirements](#setup-and-requirements)
5. [Disclaimer](#disclaimer)
6. [License](#license)

## Introduction

The implemented algorithm was created using the Wide Trail Strategy. This allowed the construction of individual layers of the algorithm independently, along with their testing. Adopting such an approach ensured the algorithm's resilience against attacks utilizing linear and differential cryptanalysis. The implemented cipher is designed for use in devices with limited resources.

## Parameters

Key size: 64 or 128 bits\
Block size: 96 bits\
Structure: SPN\
Rounds: 10 or 12 (depending on key size)

## Versions of algorithm

1. **128bit key**
    - File: [cipher128.sage](./custom_cipher128.sage)
    - Description: Implementation of the custom cipher using 128bit.
  
2. **64bit key**
    - File: [cipher64.sage](./custom_cipher64.sage)
    - Description: Implementation of the custom cipher using 64bit.

## Test vectors

Test vectors can be found in the files: 
1.**128bit key**
      -File[test_vectors128.txt](./test_vectors128.txt)
2.**64bit key**
      -File[test_vectors64.txt](./test_vectors64.txt)

## Setup and Requirements

Before running the cipher, ensure you have SageMath installed on your system. SageMath is available for various platforms, and installation instructions can be found on the official [SageMath website](https://www.sagemath.org/download.html). You can also use [Sage Cell Server](https://sagecell.sagemath.org/)

## How to Run

To run a specific version, follow these steps:

1. Open the corresponding SageMath script using your preferred text editor or SageMath environment.
2. Adjust any parameters or configurations if necessary.
3. Execute the script in SageMath.

## Disclaimer

These implementations are provided for educational and experimental purposes. They are not intended for use in security-critical or production environments.

Use these implementations responsibly and avoid deploying them in applications where security is paramount. If you require a secure cipher for serious work, consider using well-established cryptographic libraries or consulting with cryptographic experts.

## License
This repository is licensed under the [MIT License](./LICENSE). You are free to use, modify, and distribute the code for both commercial and non-commercial purposes.
