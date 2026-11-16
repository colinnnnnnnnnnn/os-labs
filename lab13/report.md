# Laboratory Work 13 Notes: Semaphores in Your Own Kernel (xv6)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Patricia Reițman  
**Date:** Autumn Semester 2026  

---

## Part 1. The Numbers and the User Side

### Edits Summary
1. `kernel/syscall.h`: Defined system call numbers 24, 25, 26:
   ```c
   #define SYS_sem_init 24
   #define SYS_sem_down 25
   #define SYS_sem_up   26
   ```
2. `user/user.h`: Declared prototypes:
   ```c
   int sem_init(int, int);
   int sem_down(int);
   int sem_up(int);
   ```
3. `user/usys.pl`: Registered stubs:
   ```perl
   entry("sem_init");
   entry("sem_down");
   entry("sem_up");
   ```
4. `user/semtest.c`: Created unit test for child waiting (order) and bidirectional turn-taking (ping-pong).
5. `user/mix.c`: Created character-interleaving concurrency test utility.
6. `Makefile`: Added `$U/_semtest\` and `$U/_mix\` to `UPROGS`.

### Check 1: The Calls Reach the Kernel
```bash
$ semtest
3 semtest: unknown sys call 24
4 semtest: unknown sys call 25
child: I ran after the parent
parent: done, I let the child go
```
Verification: The user program executed `ecall` with registers `a7 = 24` and `a7 = 25`. The kernel caught the unhandled syscall numbers, emitted the unknown syscall diagnostic, and returned -1. Because semaphores did not yet function, the child ran before the parent.

---

## Part 2. The Kernel Side

### Edits Summary
1. `kernel/sem.c`: Implemented counting semaphore subsystem with 8 global semaphores (`NSEM = 8`), each protected by a spinlock:
   - `sys_sem_init`: Validates bounds (`0 <= id < 8`, `value >= 0`), acquires spinlock, sets `value`, releases spinlock.
   - `sys_sem_down`: Acquires spinlock; while `value == 0`, calls `sleep_prepare(s)`, releases spinlock, sleeps with `sleep()`, and re-acquires spinlock; checks `killed(myproc())`; decrements `value` and releases spinlock.
   - `sys_sem_up`: Acquires spinlock, increments `value`, calls `wakeup(s)`, releases spinlock.
2. `Makefile`: Added `$K/sem.o \` to `OBJS`.
3. `kernel/syscall.c`: Declared extern handlers, mapped in table `syscalls[]`, and added names to `syscallnames[]`.

### Check 2: semtest Works
```bash
$ semtest
parent: done, I let the child go
child: I ran after the parent
ping 1
 pong 1
ping 2
 pong 2
ping 3
 pong 3
semtest: OK
```
Verification:
- The parent slept for 10 ticks, yet the child printed second because it was blocked asleep in `sem_down(0)`.
- Ping and pong alternated deterministically across 3 cycles via semaphores 1 and 2.
- The test concluded with `semtest: OK`.

---

## Part 3. A Semaphore as a Lock: mix

### 3.1 Without Lock (`mix`)
```bash
$ mix
AAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAb
bA
AbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbA
bAbA
AAbAAbbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAbAb
bAbAb
bbbbbbbbbbbbbbbbbbbAbAbAbAbAbAbAbAbAbAbAbA
AbAAbAbAbAbAbAbAbAbAbAbAbAbAbAb
bAbAbAbAbAbAbAbAbAbAbAbAbAbAbA
AAAAAAAAAAAAAAA
```

### 3.2 With Lock (`mix lock`)
```bash
$ mix lock
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
```

---

## Observe Questions & Answers

### 1. Without the lock, why do the letters mix? (How many system calls does one line cost?)
- `lines()` outputs characters one byte at a time: `for (char *p = s; *p; p++) write(1, p, 1);`.
- A 30-character string plus newline costs **31 separate `write()` system calls** per line.
- Because QEMU runs xv6 on multiple simulated hardware cores (`CPUS=3`), the parent and child processes execute simultaneously in parallel. Without synchronization, the individual 1-byte writes interleave arbitrarily inside the kernel console UART driver, scrambling the characters on the screen.

### 2. With the lock every line is whole. Which two lines of mix.c make one line a critical section?
- The entry protocol:
  ```c
  if (uselock) sem_down(3);
  ```
- The exit protocol:
  ```c
  if (uselock) sem_up(3);
  ```
- Because semaphore 3 is initialized to 1 (`sem_init(3, 1)`), it acts as a binary mutual exclusion lock. Whichever process enters the 31-syscall loop holds the lock exclusively until the entire line is printed.

### 3. In sem_down the test is "while (s->value == 0)", not "if". Why can a process wake up and still find 0?
- In xv6, `wakeup(s)` marks sleeping processes as runnable (`RUNNABLE`), but does not grant them immediate execution with the semaphore lock held.
- When an unblocked process wakes up from `sleep()`, it must re-acquire the spinlock (`acquire(&s->lock)`).
- In the time between `wakeup(s)` and lock re-acquisition, another active process running on a third CPU core (or scheduled first) could call `sem_down(id)`, acquire `s->lock`, decrement `s->value` back to 0, and release the lock.
- If `sem_down` used `if`, the awakened process would proceed to decrement 0 to -1, violating the non-negative semaphore invariant. A `while` loop ensures the thread re-evaluates the predicate and goes back to sleep if `s->value` has returned to 0.

### 4. sem_down calls release(&s->lock) BEFORE sleep(). What would go wrong if it slept holding the spinlock?
- Sleeping while holding a spinlock causes an immediate, unrecoverable **kernel deadlock**:
  1. Spinlocks disable interrupts on the holding CPU core and busy-wait on other cores. If a process went to sleep holding `s->lock`, no other process could ever acquire `s->lock`.
  2. Crucially, the only way for the sleeping process to be woken up is for another thread or process to call `sem_up(id)`. But `sem_up()` begins with `acquire(&s->lock)`. If the sleeping process holds `s->lock`, `sem_up()` would spin forever in `acquire()` trying to obtain the lock, unable to ever reach `wakeup(s)`.
  3. The sleeping process would sleep forever, the waking process would spin forever, and the operating system would freeze.
