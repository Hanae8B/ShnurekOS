g++ -std=gnu++17 -ffreestanding -O2 -Wall -Wextra -c kernel\kernel.cpp -o kernel\kernel.o
g++ -T linker.ld -nostdlib -o kernel.bin kernel\kernel.o
