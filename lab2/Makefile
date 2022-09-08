CROSS-COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS-COMPILE)as
LD = $(CROSS-COMPILE)ld

ASFLAGS = -g
LDFLAGS = -g -static

SRCS = lab2.s
OBJS = $(SRCS:.s=.o)

EXE = lab2

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@