SYSROOT=$(NDK)/build/tools/$(toolchain)-$(api)/sysroot/usr
CC=$(toolchain)-gcc
AR=$(toolchain)-ar
RANLIB=$(toolchain)-ranlib
CFLAGS=--prefix=$(SYSROOT) -I./include -I$(SYSROOT)/include -Wall -Wextra
LDFLAGS=-fpie -lm

SRCS=$(wildcard *.c)

OBJS=$(SRCS:.c=.o)

.PHONY: all

all: libcomplex.a libcomplex.so

libcomplex.a: $(OBJS)
	$(AR) $(ARFLAGS) $@ $^
	$(RANLIB) $@

libcomplex.so: libcomplex.a
	$(CC) -shared -Xlinker -soname=$@ -o $@ -Wl,-whole-archive $^ -Wl,-no-whole-archive $(LDFLAGS)

.PHONY: clean

clean:
	rm -f $(OBJS) libcomplex.a libcomplex.so

install:
	@echo "installing..."
	@echo ""
	mkdir -p $(SYSROOT)/lib
	install -m 644 -p libcomplex.so libcomplex.a $(SYSROOT)/lib
	install -m 644 -p include/complex.h $(SYSROOT)/include
