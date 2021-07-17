CROSS_COMPILE ?= aarch64-linux-gnu-

PREFIX = /usr

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

CCFLAGS = -g -c -O0
ASFLAGS = -g
LDFLAGS = -g -static -O0
OBJPATH = $(PREFIX)/aarch64-linux-gnu/lib
LIBPATH = -L $(PREFIX)/lib/gcc-cross/aarch64-linux-gnu/9/ -L $(OBJPATH)
LIBS = -lgcc -lgcc_eh -lc -lm
PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

HEAD = stb_image.h stb_image_write.h
SRCS = Lab5_clang.c Lab5_ARM64.s
OBJS = Lab5_clang.o Lab5_ARM64.o

EXE = Lab5

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(OBJS): $(HEAD)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@

.c.o:
	$(CC) $(CCFLAGS) $< -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@