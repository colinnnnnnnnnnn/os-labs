CC = gcc
CFLAGS = -Wall -Wextra -O2

all: syscalls

syscalls: syscalls.c
	$(CC) $(CFLAGS) -o syscalls syscalls.c

run: syscalls
	./syscalls

trace: syscalls
	PATH="/tmp:$$PATH" strace -e trace=openat,write,read,close ./syscalls

trace-ls:
	PATH="/tmp:$$PATH" strace -f -e trace=openat,read,write,close ls -l

trace-count: syscalls
	PATH="/tmp:$$PATH" strace -c ./syscalls

clean:
	rm -f syscalls note.txt

.PHONY: all run trace trace-ls trace-count clean
