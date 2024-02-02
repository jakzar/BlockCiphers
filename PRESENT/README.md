# PRESENT Block Cipher Implementations

This repository contains three implementations of the PRESENT block cipher, each serving a specific purpose:

1. **Fast Implementation:** Designed for fast operations.
2. **Memory-Efficient Implementation:** Tailored for efficient memory usage on resource-constrained devices.
3. **Sage Implementation:** Provided in Sage, a mathematical software system, for experimentation and analysis.

## Table of Contents

1. [PRESENT Cipher](#present-cipher)
    - [1. Implementation Details](#implementation-details)
2. [Files](#files)
    - [1. Fast Implementation](#fast-implementation)
    - [2. Memory-Efficient Implementation](#memory-efficient-implementation)
    - [3. Sage Implementation](#sage-implementation)
3. [Disclaimer](#disclaimer)
4. [License](#license)

## PRESENT Cipher

PRESENT is a lightweight block cipher designed for efficient implementation on devices with low computing power and limited memory. It operates on 64-bit blocks and supports key sizes of 80 or 128 bits. The cipher is known for its simplicity, making it suitable for resource-constrained environments such as RFID tags, sensor nodes, and other embedded systems.

### Implementation Details

The implementations in this repository cater to specific requirements:

- **Fast Implementation:** Designed for devices where speed is a priority.
- **Memory-Efficient Implementation:** Optimized for devices with limited memory resources.
- **Sage Implementation:** Provided in Sage for experimentation and mathematical analysis.

## Files

### Fast Implementation

- [fast_present_encrypt.c](./present_fast_32bit_enc.c): C file containing the implementation of the fast PRESENT block cipher encryption algorithm.
- [fast_present_decrypt.c](./present_fast_32bit_dec.c): C file containing the implementation of the fast PRESENT block cipher decryption algorithm.

### Memory-Efficient Implementation

- [memory_present_encrypt.c](./present_8bit_enc.c): C file containing the implementation of the memory-efficient PRESENT block cipher encryption algorithm.
- [memory_present_decrypt.c](./present_8bit_dec.c): C file containing the implementation of the memory-efficient PRESENT block cipher decryption algorithm.

### Sage Implementation

- [present_sage.sage](./present.sage): Sage script providing an implementation of the PRESENT cipher for experimentation and analysis.

## Disclaimer

These implementations are provided for educational and experimental purposes. They are not intended for use in security-critical or production environments. The primary goal is to showcase the inner workings of the PRESENT cipher for different optimization strategies.

Use these implementations responsibly and avoid deploying them in applications where security is paramount. If you require a secure implementation of the PRESENT cipher for serious work, consider using well-established cryptographic libraries or consulting with cryptographic experts.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to modify and distribute it according to the terms of the license.
