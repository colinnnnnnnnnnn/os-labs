# Laboratory Work 11 Notes: The Race and the Semaphore (Linux)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Patricia Reițman  
**Date:** Autumn Semester 2026  

---

## Part 1. See the Race (`race.c`)

### Execution Runs
```bash
$ gcc -Wall -Wextra -pthread -o race race.c
$ ./race
counter = 1177549 (expected 2000000)
$ ./race
counter = 1326398 (expected 2000000)
$ ./race
counter = 981166 (expected 2000000)
```

### Observe Questions & Answers
1. **counter++ looks like one step. Write the three steps the CPU really does.**
   - **Step 1 (Load):** Read the current value of `counter` from shared RAM/cache into a local CPU register (`mov counter(%rip), %rax`).
   - **Step 2 (Increment):** Add 1 to the register value within the CPU ALU (`add $1, %rax`).
   - **Step 3 (Store):** Write the updated register value back to shared memory (`mov %rax, counter(%rip)`).

2. **Describe, with those steps, how two threads can lose one addition.**
   - Suppose `counter` holds the value 100.
   - Thread A executes Step 1, loading 100 into its register `%rax_A`.
   - Before Thread A stores the result, a thread context switch or simultaneous core execution allows Thread B to execute Step 1, also loading 100 into its register `%rax_B`.
   - Thread A executes Step 2 (`%rax_A` becomes 101) and Step 3 (writes 101 to `counter`).
   - Thread B executes Step 2 (`%rax_B` becomes 101) and Step 3 (writes 101 to `counter`), overwriting Thread A's modification with the exact same number.
   - Two separate increments occurred, but the counter only advanced by 1. One addition is permanently lost.

3. **Why is the result different at every run?**
   - The OS thread scheduler is non-deterministic, varying slice intervals, core assignments, hardware interrupts, and cache line bus arbitration between runs. Consequently, the points where threads interleave instruction steps vary on every execution.

---

## Part 2. Fix It: Mutex, Then Semaphore

### Execution Runs
```bash
$ gcc -Wall -Wextra -pthread -o mutex mutex.c && ./mutex
counter = 2000000 (expected 2000000)

$ gcc -Wall -Wextra -pthread -o sem sem.c && ./sem
counter = 2000000 (expected 2000000)
```

### Performance Benchmark
```bash
$ time ./race
real    0m0.015s

$ time ./mutex
real    0m0.073s

$ time ./sem
real    0m0.125s

$ time ./atomic
real    0m0.022s
```

### Observe Questions & Answers
1. **Run mutex and sem three times each. Is the answer always 2 000 000?**
   - Yes, both `mutex` and `sem` yield exactly `2000000` on every single invocation because both primitives guarantee strict mutual exclusion: exactly one thread can enter the critical section to read, increment, and write back `counter`.
2. **Why is mutex faster than sem?**
   - POSIX mutexes (`pthread_mutex_t`) use Linux fast userspace locking (futexes), resolving uncontended lock acquisitions purely via a single atomic instruction in user space without entering the kernel. Semaphores (`sem_t`) implement a generalized non-negative integer counter mechanism that incurs greater bookkeeping and synchronization overhead per invocation.

---

## Part 3. A Semaphore as a Signal (`order.c`)

### Execution Runs
With `sem_init(&ready, 0, 0)`:
```bash
$ gcc -Wall -Wextra -pthread -o order order.c && ./order
B: waiting for the message...
A: message written
B: I read "hello"
```

With `sem_init(&ready, 0, 1)`:
```bash
B: waiting for the message...
B: I read ""
A: message written
```

### Observe Questions & Answers
1. **Change the start value to 1 (`sem_init(&ready, 0, 1)`), compile, run. What does B read now, and why?**
   - Reader B reads an empty string `""` (`B: I read ""`). When the semaphore starts at 1, `sem_wait(&ready)` in reader thread B decrements 1 to 0 and proceeds immediately without waiting for writer thread A. Because writer A sleeps for 1 second (`sleep(1)`), reader B executes its read and print before writer A has copied `"hello"` into `message`.
2. **Put it back to 0. In one sentence: what does a semaphore that starts at 0 mean?**
   - A semaphore initialized to 0 acts as a pure synchronization signal (rendezvous), forcing any waiting thread to block until another thread explicitly signals completion by calling `sem_post()`.

---

## Part 4. A Semaphore as a Counter: The Parking Lot (`parking.c`)

### Execution Run
```bash
$ gcc -Wall -Wextra -pthread -o parking parking.c && ./parking
car 1 enters (inside: 1)
car 3 enters (inside: 2)
car 2 enters (inside: 3)
car 1 leaves (inside: 2)
car 4 enters (inside: 3)
car 2 leaves (inside: 2)
car 3 leaves (inside: 1)
car 5 enters (inside: 2)
car 6 enters (inside: 3)
car 4 leaves (inside: 2)
car 5 leaves (inside: 1)
car 6 leaves (inside: 0)
```

### Observe Questions & Answers
1. **What is the largest value of "inside" you see? Which line of code guarantees it?**
   - The largest value of `inside` is **3**.
   - It is guaranteed by `sem_init(&places, 0, PLACES);` (where `PLACES` is 3) along with `sem_wait(&places);` at the entry of the `car()` thread function, which prevents more than 3 threads from acquiring a slot concurrently.
2. **Set PLACES to 1. What does the semaphore become?**
   - When initialized to 1, the counting semaphore degenerates into a **binary semaphore**, functioning as a mutual exclusion lock (mutex).
