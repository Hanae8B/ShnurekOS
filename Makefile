# Compiler and linker
CC := gcc
LD := ld
AR := ar

# Compiler flags (add -m32 or -m64 if you target specific arch)
CFLAGS := -Wall -Wextra -O0 -g -Iinclude -Ikernel/include -Ilibs -Ikernel/drivers -Ikernel/security -Ikernel/fs -Ikernel/ipc -Ikernel/process -Ikernel/memory -Ikernel/core -Ikernel/syscall -Ikernel/arch/x86 -Inet -Iservices -Iuser -Itools -Igui
LDFLAGS := -T linker.ld

# Find all source files recursively (adjust if you want)
SRCS := $(shell find . -name '*.c')

# Generate object files list
OBJS := $(SRCS:.c=.o)

# Default target
all: shnurekos

# Compile all sources
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link all objects into final binary
shnurekos: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# Clean build files
clean:
	rm -f $(OBJS) shnurekos

.PHONY: all clean
