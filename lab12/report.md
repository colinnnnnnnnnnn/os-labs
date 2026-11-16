# Laboratory Work 12 Notes: Producer, Consumer and the Other Tools (Linux)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Patricia Reițman  
**Date:** Autumn Semester 2026  

---

## Part 1. Producer and Consumer (`prodcons.c`)

### Execution Run
```bash
$ gcc -Wall -Wextra -pthread -o prodcons prodcons.c && ./prodcons
put 1		(in buffer: 1)
put 2		(in buffer: 2)
put 3		(in buffer: 3)
put 4		(in buffer: 4)
	take 1	(in buffer: 3)
put 5		(in buffer: 4)
	take 2	(in buffer: 3)
put 6		(in buffer: 4)
	take 3	(in buffer: 3)
put 7		(in buffer: 4)
	take 4	(in buffer: 3)
put 8		(in buffer: 4)
	take 5	(in buffer: 3)
	take 6	(in buffer: 2)
	take 7	(in buffer: 1)
	take 8	(in buffer: 0)
```

### Observe Questions & Answers
1. **The producer is fast, yet "in buffer" never goes above 4. Which call stops it?**
   - The call `sem_wait(&empty);` inside `producer()`.
   - The semaphore `empty` is initialized to 4 (`SIZE`). Each `put` decrements `empty`. Once 4 items reside in the buffer without being consumed, `empty` reaches 0. The subsequent invocation of `sem_wait(&empty)` puts the producer to sleep until the consumer removes an item and signals `sem_post(&empty)`.

2. **Who waits at the start: the consumer or the producer? Which call makes it wait?**
   - The **consumer** waits at the start.
   - The call `sem_wait(&full);` makes it wait. Because `full` is initialized to 0, attempting to decrement it blocks the consumer until the producer inserts the first item and executes `sem_post(&full)`.

3. **In producer(), swap the first two lines: lock the mutex BEFORE `sem_wait(&empty)`. Run it. What happens when the buffer is full, and why?**
   - A catastrophic **deadlock** occurs, causing the program to hang indefinitely until terminated.
   - **Reason:** The producer acquires `lock` first, then attempts `sem_wait(&empty)`. When the buffer is full (`empty == 0`), the producer blocks while still holding `lock`. The consumer wakes up, attempts to retrieve an item to free a slot, but immediately blocks attempting to acquire `lock` (`pthread_mutex_lock(&lock)`). The producer is waiting for the consumer to call `sem_post(&empty)`, while the consumer is waiting for the producer to release `lock`. Neither thread can make progress.

---

## Part 2. The Condition Variable (`condvar.c`)

### Execution Run
```bash
$ gcc -Wall -Wextra -pthread -o condvar condvar.c && ./condvar
B: waiting for the message...
A: message written
B: I read "hello"
```

### Observe Questions & Answers
1. **Why does `pthread_cond_wait` need the mutex as an argument? (What does it do with it while sleeping, and what does it do with it just before returning?)**
   - `pthread_cond_wait(&changed, &lock)` must atomically release the mutex and place the calling thread onto the condition variable's wait queue.
   - **While sleeping:** The mutex is released so that another thread (the writer) can acquire it, update the shared state (`ready = 1`), and signal the condition variable. If the mutex remained held, the writer could never acquire the lock to change the predicate, causing permanent deadlock.
   - **Before returning:** `pthread_cond_wait` automatically re-acquires the mutex, ensuring that the reader re-enters user code exclusively holding the lock so it can safely examine or modify protected shared variables.

2. **In reader(), why is the test "while (!ready)", and not "if (!ready)"? (This rule is so important it has a name: always wait in a while loop.)**
   - Waiting inside a `while` loop protects against two critical concurrency phenomena:
     1. **Spurious Wakeups:** Under POSIX and Linux kernel implementations, a waiting thread may occasionally wake up without an explicit `pthread_cond_signal` or `broadcast` having occurred.
     2. **State Invalidation / Race Conditions:** In multi-consumer setups, between the moment a thread is signaled and the moment it re-acquires the mutex, another thread could run and reset the predicate (`ready = 0`). The `while` loop re-evaluates the boolean condition to guarantee that the invariant actually holds before continuing.

---

## Part 3. Readers and Writers (`readers.c`)

### Execution Run
```bash
$ gcc -Wall -Wextra -pthread -o readers readers.c && ./readers
writer 1 writes 10	(alone)
reader 1 reads 10	(readers inside: 1)
reader 2 reads 10	(readers inside: 2)
reader 3 reads 10	(readers inside: 3)
writer 2 writes 20	(alone)
```

### Observe Questions & Answers
1. **Three readers are inside at the same time, but a writer is always alone. Which two lines of reader() make that possible?**
   - Line 1: `if (++readers == 1) sem_wait(&room);`
     - When the first reader enters, it acquires the `room` semaphore, locking out all writers. Subsequent readers increment `readers` but bypass `sem_wait(&room)`, entering simultaneously.
   - Line 2: `if (--readers == 0) sem_post(&room);`
     - Departing readers decrement `readers`. Only the very last reader out releases `room`, allowing waiting writers to enter.

2. **Why does the counter readers need its own lock (rlock)? What could go wrong without it?**
   - `readers` is a shared global integer updated by multiple concurrent reader threads. Without `rlock`, the operations `++readers` and `--readers` suffer data races (lost updates). If two readers concurrently enter, both might see `readers == 1` and both call `sem_wait(&room)` (which would cause the second to deadlock on `room`), or reader count corruption could result in `readers` never reaching 0, locking out writers forever.

3. **Imagine readers that keep arriving without a pause. What happens to writer 2? (This problem has a name: starvation.)**
   - Writer 2 suffers from **writer starvation** (indefinite postponement). Because readers do not yield to waiting writers and subsequent readers can enter as long as `readers > 0`, a continuous stream of readers keeps `room` locked perpetually, preventing writer 2 from ever executing.

---

## Part 4. Build a Deadlock, Then Remove It (`deadlock.c`)

### Buggy Run (Opposite Lock Ordering)
```bash
$ timeout 5 ./deadlock_buggy; echo "exit code: $?"
one: I have A, I want B
two: I have B, I want A
exit code: 124
```

### Fixed Run (Consistent Global Lock Ordering)
```bash
$ gcc -Wall -Wextra -pthread -o deadlock deadlock.c && ./deadlock; echo "exit code: $?"
two: I have A, I want B
two: I have both
one: I have A, I want B
one: I have both
done
exit code: 0
```

### Observe Questions & Answers
1. **In the stuck run, which thread holds which mutex, and which one is each thread waiting for? Draw the circle.**
   - Thread `one` holds mutex `A` and is blocked waiting for mutex `B`.
   - Thread `two` holds mutex `B` and is blocked waiting for mutex `A`.
   - **Circular Wait Cycle:**
     $$\text{Thread 1} \xrightarrow{\text{holds}} \text{Mutex A} \xrightarrow{\text{wanted by}} \text{Thread 2} \xrightarrow{\text{holds}} \text{Mutex B} \xrightarrow{\text{wanted by}} \text{Thread 1}$$

2. **Remove both sleep(1) lines from the ORIGINAL version and run it ten times. Does it still always hang? Why is that worse, not better?**
   - Without `sleep(1)`, the program does not always hang; on many runs, one thread runs fast enough to acquire both mutexes before the other begins, allowing the program to exit normally with code 0.
   - This intermittent behavior is **far worse** than a deterministic deadlock because it turns a detectable, reproducible bug into a silent Heisenbug that escapes integration testing and manifests randomly under heavy production load.

3. **In one sentence: why can taking the locks in the same order never deadlock?**
   - Enforcing a uniform global lock acquisition hierarchy prevents the circular-wait condition, making cycles in the resource allocation graph mathematically impossible.
