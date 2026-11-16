CC = gcc
CFLAGS = -Wall -Wextra -pthread

PROGS = prodcons condvar readers deadlock

all: $(PROGS)

prodcons: prodcons.c
	$(CC) $(CFLAGS) -o prodcons prodcons.c

condvar: condvar.c
	$(CC) $(CFLAGS) -o condvar condvar.c

readers: readers.c
	$(CC) $(CFLAGS) -o readers readers.c

deadlock: deadlock.c
	$(CC) $(CFLAGS) -o deadlock deadlock.c

clean:
	rm -f $(PROGS)

.PHONY: all clean
