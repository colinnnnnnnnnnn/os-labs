CC = gcc
CFLAGS = -Wall -Wextra -pthread

PROGS = race mutex sem order parking atomic

all: $(PROGS)

race: race.c
	$(CC) $(CFLAGS) -o race race.c

mutex: mutex.c
	$(CC) $(CFLAGS) -o mutex mutex.c

sem: sem.c
	$(CC) $(CFLAGS) -o sem sem.c

order: order.c
	$(CC) $(CFLAGS) -o order order.c

parking: parking.c
	$(CC) $(CFLAGS) -o parking parking.c

atomic: atomic.c
	$(CC) $(CFLAGS) -o atomic atomic.c

clean:
	rm -f $(PROGS)

.PHONY: all clean
