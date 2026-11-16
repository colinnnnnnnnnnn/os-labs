#set document(
  title: "Laboratory Work 11: Track A: The Race and the Semaphore (Linux)",
  author: "Poiata Calin",
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.2cm, left: 2.5cm, right: 2.5cm),
  footer: context {
    let page-num = counter(page).get().first()
    if page-num > 0 {
      align(center)[
        #text(size: 10pt, font: "New Computer Modern")[#str(page-num)]
      ]
    }
  }
)

#set text(
  font: "New Computer Modern",
  size: 10.5pt,
  lang: "en",
)

#set par(
  justify: true,
  leading: 0.62em,
)

// Heading customization
#show heading.where(level: 1): it => block(
  above: 1.4em,
  below: 0.7em,
  text(size: 12.5pt, weight: "bold", it.body)
)

#show heading.where(level: 2): it => block(
  above: 1.1em,
  below: 0.5em,
  text(size: 11pt, weight: "bold", it.body)
)

#show heading.where(level: 3): it => block(
  above: 0.9em,
  below: 0.4em,
  text(size: 10.5pt, weight: "bold", it.body)
)

// Code block styling
#show raw: it => {
  if it.block {
    block(
      width: 100%,
      fill: rgb("#fafafa"),
      inset: (x: 9pt, y: 7pt),
      radius: 3pt,
      stroke: 0.4pt + rgb("#e0e0e0"),
      [
        #set text(font: "JetBrainsMono NF", size: 8pt, fill: rgb("#111827"))
        #set par(leading: 0.4em, justify: false)
        #it
      ]
    )
  } else {
    box(
      fill: rgb("#f3f4f6"),
      inset: (x: 3pt, y: 1pt),
      radius: 2pt,
      baseline: 0pt,
      text(font: "JetBrainsMono NF", size: 8pt, fill: rgb("#111827"))[#it]
    )
  }
}

// -------------------------------------------------------------
// Title Page
// -------------------------------------------------------------
#align(center)[
  #v(2cm)
  #text(size: 14pt, weight: "medium")[
    Ministerul Educației și Cercetării al Republicii Moldova\
    Universitatea Tehnică a Moldovei\
    Facultatea Calculatoare, Informatică și Microelectronică\
    Departamentul Ingineria Software și Automatică
  ]

  #v(5cm)

  #text(size: 15pt, weight: "regular")[Laboratory Work 11:]

  #v(0.3cm)

  #text(size: 13pt, weight: "regular")[Track A: The Race and the Semaphore (Linux)]

  #v(5.5cm)
]

#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #text(size: 11pt)[
      Elaborated:\
      Poiata Calin\
      \
      Verified:\
      Patricia Reițman\
      \
    ]
  ],
  [
    #text(size: 11pt)[
      gr. FAF-243
    ]
  ]
)

#v(2.5cm)
#align(center)[
  #text(size: 11pt)[Chișinău – 2026]
]

#pagebreak()

// -------------------------------------------------------------
// Table of Contents
// -------------------------------------------------------------
#v(1cm)
#outline(
  title: [Table of Contents],
  indent: auto,
  depth: 2,
)

#pagebreak()

// Reset page counter for main content
#counter(page).update(1)

// -------------------------------------------------------------
// Environment & Toolchain
// -------------------------------------------------------------
= Environment & Toolchain

- *Host Operating System:* Linux (Arch Linux x86_64, Kernel 7.2.9-arch1-1)
- *Host Shell:* GNU bash, version 5.3.20(1)-release (`x86_64-pc-linux-gnu`)
- *Host Compiler:* GNU GCC 15.2.1 (`gcc -Wall -Wextra -pthread`)
- *Concurrency Runtime:* POSIX Threads (`libpthread.so`), POSIX Real-time Extension Semaphores (`semaphore.h`), C11 Atomics (`stdatomic.h`)
- *Document Processor:* Typst 0.15.1 (`typst`)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Purpose of the Laboratory Work
// -------------------------------------------------------------
= Purpose of the Laboratory Work

1. Investigate the phenomenon of race conditions in multi-threaded shared-memory programming, examining how compiler instruction lowering decomposes atomic-looking statements into non-atomic CPU load-modify-store sequences.
2. Resolve race conditions through mutual exclusion primitives, utilizing POSIX Mutexes (`pthread_mutex_t`) to define strictly guarded critical sections.
3. Explore Dijkstra's counting semaphore abstraction (`sem_t`), verifying its behavior as a mutual exclusion lock when initialized to 1.
4. Benchmark the comparative execution latency and overhead of unprotected memory access, mutexes, semaphores, and hardware-level atomic instructions (`stdatomic.h`).
5. Employ a semaphore initialized to 0 as an inter-thread ordering signal (rendezvous pattern), enforcing strict temporal causality across concurrent threads.
6. Model bounded-capacity resource tracking using counting semaphores initialized to $N > 1$, simulating a multi-capacity parking lot and investigating binary degeneration.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 1: See the Race (race.c)
// -------------------------------------------------------------
= Part 1: See the Race (`race.c`)

== 1. Implementation

When multiple threads concurrently read and modify a shared variable without synchronization, data races occur. We implement `race.c` where two threads concurrently attempt to increment a global variable `counter` $1\,000\,000$ times each:

```c
/* race.c - two threads add to the same counter, with no protection.
 * Build: gcc -Wall -pthread -o race race.c   (no -O2: keep counter++ in memory)
 * Run:   ./race                              (several times)
 */
#include <stdio.h>
#include <pthread.h>

#define N 1000000

long counter = 0;              /* shared by both threads */

void *add(void *arg) {
    (void)arg;
    for (int i = 0; i < N; i++)
        counter++;             /* read, add 1, write back: three steps */
    return NULL;
}

int main(void) {
    pthread_t a, b;
    pthread_create(&a, NULL, add, NULL);
    pthread_create(&b, NULL, add, NULL);
    pthread_join(a, NULL);
    pthread_join(b, NULL);
    printf("counter = %ld (expected %d)\n", counter, 2 * N);
    return 0;
}
```

== 2. Execution and Empirical Observations

We compile without compiler optimizations (`-O2` omitted) so that `counter++` is evaluated directly in memory on every iteration:

```bash
$ gcc -Wall -Wextra -pthread -o race race.c
$ ./race
counter = 1177549 (expected 2000000)
$ ./race
counter = 1326398 (expected 2000000)
$ ./race
counter = 981166 (expected 2000000)
```

The observed total consistently falls drastically short of the theoretical $2\,000\,000$, and varies non-deterministically between successive executions.

== 3. Observe Answers for Part 1

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. `counter++` looks like one step. Write the three steps the CPU really does.*
    At the assembly/microarchitectural level, `counter++` decomposes into three discrete machine operations:
    1. *Load:* Read the current numeric value of `counter` from main memory / L1 cache into a hardware general-purpose register (`movq counter(%rip), %rax`).
    2. *Increment:* Add 1 to the register value within the CPU Arithmetic Logic Unit (`addq $1, %rax` or `incq %rax`).
    3. *Store:* Write the modified value from the CPU register back to the memory location of `counter` (`movq %rax, counter(%rip)`).

    *2. Describe, with those steps, how two threads can lose one addition.*
    Suppose `counter` currently contains 100:
    - *Step A1:* Thread A loads 100 into its register `%rax_A`.
    - *Step B1:* Before Thread A can store its computation, a context switch occurs or Thread B concurrently executes on another CPU core, loading 100 into `%rax_B`.
    - *Step A2 & A3:* Thread A increments `%rax_A` to 101 and stores 101 to `counter`.
    - *Step B2 & B3:* Thread B increments its private `%rax_B` to 101 and stores 101 to `counter`.
    Although two distinct additions occurred, the counter advanced only from 100 to 101. The increment performed by Thread A was completely overwritten and permanently lost.

    *3. Why is the result different at every run?*
    The operating system thread scheduler operates non-deterministically. Core frequencies, timer interrupt preemption points, memory bus arbitration latency, and cache-coherency invalidate-queue delays vary across consecutive runs, causing threads to interleave their load-modify-store sequences at unpredictable points.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 2: Fix It: Mutex, Then Semaphore
// -------------------------------------------------------------
= Part 2: Fix It: Mutex, Then Semaphore

== 1. Mutex Implementation (`mutex.c`)

We introduce a POSIX mutex (`pthread_mutex_t`) to create an exclusive critical section around `counter++`:

```c
/* mutex.c - the same counter, now protected by a mutex. */
#include <stdio.h>
#include <pthread.h>

#define N 1000000
long counter = 0;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void *add(void *arg) {
    (void)arg;
    for (int i = 0; i < N; i++) {
        pthread_mutex_lock(&lock);     /* entry protocol */
        counter++;                     /* critical section */
        pthread_mutex_unlock(&lock);   /* exit protocol */
    }
    return NULL;
}
```

== 2. Binary Semaphore Implementation (`sem.c`)

A counting semaphore (`sem_t`) initialized to 1 operates identically to a mutual exclusion lock. When a thread calls `sem_wait(&s)`, it decrements the value from 1 to 0 and enters. Any subsequent thread calling `sem_wait(&s)` finds 0 and blocks until `sem_post(&s)` increments the counter back to 1:

```c
/* sem.c - the same counter, protected by a semaphore that starts at 1. */
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define N 1000000
long counter = 0;
sem_t s;

void *add(void *arg) {
    (void)arg;
    for (int i = 0; i < N; i++) {
        sem_wait(&s);                  /* 1 -> 0: enter; at 0: wait */
        counter++;
        sem_post(&s);                  /* 0 -> 1: release */
    }
    return NULL;
}
```

== 3. Performance Benchmark: The Price of Synchronization

We benchmark `race`, `mutex`, `sem`, and the optional hardware-atomic implementation (`atomic.c` using `atomic_fetch_add`):

```bash
$ ./mutex
counter = 2000000 (expected 2000000)

$ ./sem
counter = 2000000 (expected 2000000)

$ time ./race
real    0m0.015s

$ time ./mutex
real    0m0.073s

$ time ./sem
real    0m0.125s

$ time ./atomic
real    0m0.022s
```

== 4. Observe Answers for Part 2

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. Run `mutex` and `sem` three times each. Is the answer always 2 000 000?*
    Yes. Both `mutex` and `sem` deterministically produce *`2000000`* on every run, because mutual exclusion prevents overlapping executions of the load-modify-store sequence.

    *2. Why is mutex faster than sem?*
    In GNU/Linux (glibc), `pthread_mutex_t` is implemented as an adaptive fast user-space lock (*futex*). When uncontended, lock acquisition and release require only a single user-space atomic assembly instruction (`lock cmpxchg` / `lock bts`), completely bypassing kernel context switches. A POSIX semaphore (`sem_t`), while also utilizing futexes for blocking, enforces generalized non-negative integer accounting and POSIX asynchronous signal safety guarantees, incurring higher overhead per cycle.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 3: A Semaphore as a Signal (order.c)
// -------------------------------------------------------------
= Part 3: A Semaphore as a Signal (`order.c`)

== 1. Implementation of the Rendezvous Pattern

A semaphore initialized to 0 enforces execution ordering (signaling). Thread B must not read `message` until Thread A has populated it:

```c
/* order.c - B must not read until A has written. */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

char message[32];
sem_t ready;                           /* starts at 0 */

void *writer(void *arg) {
    (void)arg;
    sleep(1);                          /* pretend the work takes a while */
    strcpy(message, "hello");
    printf("A: message written\n");
    sem_post(&ready);                  /* 0 -> 1: wake up B */
    return NULL;
}

void *reader(void *arg) {
    (void)arg;
    printf("B: waiting for the message...\n");
    sem_wait(&ready);                  /* blocks while value is 0 */
    printf("B: I read \"%s\"\n", message);
    return NULL;
}
```

== 2. Execution Trace

```bash
$ gcc -Wall -Wextra -pthread -o order order.c && ./order
B: waiting for the message...
A: message written
B: I read "hello"
```

Thread B starts first, prints its waiting message, blocks on `sem_wait(&ready)`, and yields the CPU. One second later, Thread A finishes writing, emits its log, and calls `sem_post(&ready)`, waking Thread B to read `"hello"`.

== 3. Observe Answers for Part 3

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. Change the start value to 1 (`sem_init(&ready, 0, 1)`), compile, run. What does B read now, and why?*
    When `ready` starts at 1, Thread B outputs:
    ```text
    B: waiting for the message...
    B: I read ""
    A: message written
    ```
    Thread B calls `sem_wait(&ready)`, decrements 1 to 0, and proceeds immediately without blocking. Because Thread A sleeps for 1 second (`sleep(1)`), Thread B reads `message` before Thread A has written to it, displaying the empty uninitialized buffer `""`.

    *2. Put it back to 0. In one sentence: what does a semaphore that starts at 0 mean?*
    A semaphore initialized to 0 represents a pure signaling event that forces calling consumers to sleep until a producer explicitly fires `sem_post()` to indicate that a shared resource or condition is ready.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 4: A Semaphore as a Counter: The Parking Lot (parking.c)
// -------------------------------------------------------------
= Part 4: A Semaphore as a Counter: The Parking Lot (`parking.c`)

== 1. Implementation

A counting semaphore initialized to $N = 3$ regulates concurrent access to a resource of bounded capacity. Six car threads attempt to park concurrently:

```c
/* parking.c - 6 cars, 3 places. */
#define PLACES 3
#define CARS   6

sem_t places;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
int inside = 0;

void *car(void *arg) {
    long id = (long)arg;
    sem_wait(&places);                 /* acquire 1 permit */

    pthread_mutex_lock(&lock);
    inside++;
    printf("car %ld enters (inside: %d)\n", id, inside);
    pthread_mutex_unlock(&lock);

    sleep(1);                          /* parked */

    pthread_mutex_lock(&lock);
    inside--;
    printf("car %ld leaves (inside: %d)\n", id, inside);
    pthread_mutex_unlock(&lock);

    sem_post(&places);                 /* release permit */
    return NULL;
}
```

== 2. Execution Trace

```bash
$ ./parking
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

== 3. Observe Answers for Part 4

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. What is the largest value of "inside" you see? Which line of code guarantees it?*
    The largest value observed is *`3`*. This upper bound is strictly guaranteed by:
    ```c
    sem_init(&places, 0, PLACES);  /* PLACES = 3 */
    ```
    along with `sem_wait(&places);` at the start of the `car` routine. Because the semaphore tracks available capacity and blocks when its internal integer drops to 0, no more than 3 threads can pass into the critical parking area simultaneously.

    *2. Set PLACES to 1. What does the semaphore become?*
    When initialized to 1, the counting semaphore degenerates into a *binary semaphore*, providing strict mutual exclusion equivalent to a mutex.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Comparative Analysis
// -------------------------------------------------------------
= Comparative Analysis of Synchronization Primitives

#table(
  columns: (1.2fr, 2fr, 2fr, 2fr),
  stroke: 0.4pt + rgb("#cbd5e1"),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
  align: (left, left, left, left),
  table.header(
    [*Primitive*],
    [*Initial Value / State*],
    [*Primary Semantics*],
    [*Ownership & Signaling*],
  ),
  [*Mutex*],
  [Unlocked (`0`).],
  [Strict mutual exclusion around critical code regions.],
  [Must be unlocked by the exact thread that locked it.],

  [*Binary Semaphore*],
  [`1` (or `0` for rendezvous).],
  [Mutual exclusion or one-way synchronization signal.],
  [Can be posted by any thread; has no thread ownership.],

  [*Counting Semaphore*],
  [$N > 1$ (e.g. 3, 4, 16).],
  [Bounded resource tracking and capacity management.],
  [Allows up to $N$ concurrent holders; no thread ownership.],

  [*Atomic Instructions*],
  [Hardware CPU cache-line lock (`LOCK CMPXCHG`).],
  [Single instruction read-modify-write without software blocking.],
  [Operates at CPU pipeline level; fastest possible synchronization.],
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Conclusion
// -------------------------------------------------------------
= Conclusion

Laboratory Work 11 demonstrated the mechanics, vulnerabilities, and solutions of concurrent programming in Unix:

1. *Mechanics of Data Races:* Deconstructed `counter++` into load, increment, and store assembly steps, proving why asynchronous interleaving destroys updates.
2. *Mutual Exclusion Solutions:* Successfully eradicated race conditions using `pthread_mutex_t` and `sem_t` initialized to 1, guaranteeing deterministic computation of $2\,000\,000$.
3. *Synchronization Patterns:* Implemented the semaphore rendezvous pattern (`ready` initialized to 0) to enforce temporal ordering without busy-waiting.
4. *Bounded Concurrency:* Modeled multi-capacity resource allocation using counting semaphores, confirming strict bounding of concurrent participants.
