CROSS_COMPILE ?= aarch64-linux-gnu-

PREFIX = /usr

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

ASFLAGS = -g
LDFLAGS = -g -static
OBJPATH = $(PREFIX)/aarch64-linux-gnu/lib
LIBPATH = -L $(PREFIX)/lib/gcc-cross/aarch64-linux-gnu/9/ -L $(OBJPATH)
LIBS = -lgcc -lgcc_eh -lc -lm
PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

SRCS = Lab4.s
OBJS = $(SRCS:.s=.o)

EXE = Lab4

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@