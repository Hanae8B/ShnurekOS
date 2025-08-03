#!/bin/bash
set -e

echo "🔧 Cleaning previous build..."
rm -rf build kernel.bin

echo "🔧 Creating build directories..."
mkdir -p build

echo "🔧 Assembling boot.s..."
nasm -f elf32 kernel/boot.s -o build/boot.o

echo "🔧 Compiling kernel.c..."
i686-elf-gcc -m32 -ffreestanding -c kernel/kernel.c -o build/kernel.o

echo "🔧 Linking kernel..."
i686-elf-ld -T linker.ld -o kernel.bin build/boot.o build/kernel.o

echo "✅ kernel.bin ready!"
