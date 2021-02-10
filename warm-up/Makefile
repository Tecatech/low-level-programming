AS = aarch64-linux-gnu-as
CC = aarch64-linux-gnu-gcc
CFLAGS = -nostdlib -static

all: main

main: main.o
	$(CC) main.o -o main $(CFLAGS)

main.o: main.s
	$(AS) main.s -g -o main.o

clean:
	rm -rf *.o main