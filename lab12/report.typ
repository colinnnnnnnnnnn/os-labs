#set document(
  title: "Laboratory Work 12: Track A: Producer, Consumer and the Other Tools (Linux)",
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

  #text(size: 15pt, weight: "regular")[Laboratory Work 12:]

  #v(0.3cm)

  #text(size: 13pt, weight: "regular")[Track A: Producer, Consumer and the Other Tools (Linux)]

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
- *Concurrency Runtime:* POSIX Threads (`libpthread.so`), POSIX Real-time Extension Semaphores (`semaphore.h`), POSIX Condition Variables (`pthread_cond_t`)
- *Document Processor:* Typst 0.15.1 (`typst`)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Purpose of the Laboratory Work
// -------------------------------------------------------------
= Purpose of the Laboratory Work

1. Implement the canonical bounded-buffer Producer-Consumer pattern using a combination of two counting semaphores (`empty`, `full`) and a mutex for circular queue buffer protection.
2. Investigate lock acquisition order constraints within Producer-Consumer systems and demonstrate how inverting semaphore wait operations and mutex acquisitions produces catastrophic circular deadlocks.
3. Master state-based thread synchronization using POSIX Condition Variables (`pthread_cond_t`), analyzing atomic sleep-and-release mechanics and the necessity of predicate re-checking within `while` loops.
4. Construct a Readers-Writers synchronization protocol prioritizing concurrent readers while ensuring mutual exclusion for writers, examining how read-lock counts manage the write-lock room.
5. Synthesize, analyze, and diagnose Coffman deadlocks resulting from inverted lock acquisition order, and enforce compile-time/run-time hierarchical locking to eliminate deadlock risks.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 1: Producer and Consumer (prodcons.c)
// -------------------------------------------------------------
= Part 1: Producer and Consumer (`prodcons.c`)

== 1. Bounded-Buffer Architecture

The bounded-buffer problem is fundamental to operating system design, mirroring the internal implementation of Unix pipes and socket buffers. A circular buffer of capacity $N = 4$ is shared between an asynchronous producer thread and a slow consumer thread.

Synchronization relies on three cooperating primitives:
1. `sem_t empty`: Initialized to 4, counting available unwritten slots.
2. `sem_t full`: Initialized to 0, counting populated slots ready for consumption.
3. `pthread_mutex_t lock`: Guards index manipulation (`in`, `out`) and data insertion/removal against concurrent access.

```c
/* prodcons.c - producer and consumer around a buffer of 4 slots. */
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define SIZE 4
#define ITEMS 8

int buf[SIZE];
int in = 0, out = 0, count = 0;
sem_t empty, full;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void *producer(void *arg) {
    (void)arg;
    for (int item = 1; item <= ITEMS; item++) {
        sem_wait(&empty);              /* wait for a free slot */
        pthread_mutex_lock(&lock);
        buf[in] = item;
        in = (in + 1) % SIZE;
        count++;
        printf("put %d\t\t(in buffer: %d)\n", item, count);
        pthread_mutex_unlock(&lock);
        sem_post(&full);               /* one more filled slot */
    }
    return NULL;
}

void *consumer(void *arg) {
    (void)arg;
    for (int k = 0; k < ITEMS; k++) {
        sem_wait(&full);               /* wait for something to take */
        pthread_mutex_lock(&lock);
        int item = buf[out];
        out = (out + 1) % SIZE;
        count--;
        printf("\ttake %d\t(in buffer: %d)\n", item, count);
        pthread_mutex_unlock(&lock);
        sem_post(&empty);              /* one more free slot */
        usleep(300000);                /* consumer is slow */
    }
    return NULL;
}
```

== 2. Execution Trace

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

The producer rapidly populates slots 1 to 4. Once `empty` reaches 0, the producer halts until the slow consumer takes item 1 and signals `sem_post(&empty)`.

== 3. Observe Answers for Part 1

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. The producer is fast, yet "in buffer" never goes above 4. Which call stops it?*
    The call *`sem_wait(&empty);`* in `producer()`. Because `empty` is initialized to 4 (`SIZE`), after 4 consecutive insertions without consumption, `empty` decrements to 0. The 5th invocation blocks the producer until the consumer calls `sem_post(&empty)`.

    *2. Who waits at the start: the consumer or the producer? Which call makes it wait?*
    The *consumer* waits at the start. The call *`sem_wait(&full);`* makes it wait because `full` is initialized to 0.

    *3. In `producer()`, swap the first two lines: lock the mutex BEFORE `sem_wait(&empty)`. Run it. What happens when the buffer is full, and why?*
    A fatal *deadlock* occurs, freezing the program permanently:
    - *Mechanism:* The producer acquires `lock`, inserts 4 items, and on item 5 acquires `lock` and then blocks in `sem_wait(&empty)` because the buffer is full. It sleeps *while holding `lock`*.
    - *The Trap:* The consumer wakes up and attempts to retrieve an item to create a free slot, but immediately blocks attempting to acquire `lock` (`pthread_mutex_lock(&lock)`).
    - The producer cannot proceed without the consumer calling `sem_post(&empty)`, and the consumer cannot proceed without the producer releasing `lock`.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 2: The Condition Variable (condvar.c)
// -------------------------------------------------------------
= Part 2: The Condition Variable (`condvar.c`)

== 1. Implementation

Condition variables (`pthread_cond_t`) allow threads to suspend execution until specific application-level state predicates become true:

```c
/* condvar.c - solved with a mutex and a condition variable. */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>

char message[32];
int ready = 0;                         /* state predicate */
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t changed = PTHREAD_COND_INITIALIZER;

void *writer(void *arg) {
    (void)arg;
    sleep(1);
    pthread_mutex_lock(&lock);
    strcpy(message, "hello");
    ready = 1;                         /* predicate true */
    printf("A: message written\n");
    pthread_cond_signal(&changed);     /* notify waiting thread */
    pthread_mutex_unlock(&lock);
    return NULL;
}

void *reader(void *arg) {
    (void)arg;
    pthread_mutex_lock(&lock);
    printf("B: waiting for the message...\n");
    while (!ready)
        pthread_cond_wait(&changed, &lock);
    printf("B: I read \"%s\"\n", message);
    pthread_mutex_unlock(&lock);
    return NULL;
}
```

== 2. Execution Trace

```bash
$ gcc -Wall -Wextra -pthread -o condvar condvar.c && ./condvar
B: waiting for the message...
A: message written
B: I read "hello"
```

== 3. Observe Answers for Part 2

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. Why does `pthread_cond_wait` need the mutex as an argument? (What does it do with it while sleeping, and what does it do with it just before returning?)*
    - *While sleeping:* `pthread_cond_wait(&changed, &lock)` atomically unlocks `lock` and puts the thread to sleep on the condition variable. Unlocking the mutex is essential so that the writer thread can acquire it, update `ready = 1`, and signal `changed`.
    - *Before returning:* `pthread_cond_wait` re-acquires `lock` before returning control to the caller. This guarantees that the calling thread re-enters the critical section with exclusive ownership of the shared state.

    *2. In `reader()`, why is the test "while (!ready)", and not "if (!ready)"? (This rule is so important it has a name: always wait in a while loop.)*
    Re-evaluating the predicate inside a `while` loop is required because of:
    1. *Spurious Wakeups:* POSIX and kernel scheduler mechanics permit threads to wake up from condition variables even in the absence of an explicit signal.
    2. *Mesa Semantics & Race Conditions:* In systems with multiple consumers, another thread could wake up first, consume the resource, and reset `ready = 0` before this thread acquires the mutex. Checking `while (!ready)` ensures safety under all scheduling paths.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 3: Readers and Writers (readers.c)
// -------------------------------------------------------------
= Part 3: Readers and Writers (`readers.c`)

== 1. Implementation

Multiple concurrent readers may access shared data concurrently, but writers require exclusive access:

```c
/* readers.c - readers and writers. */
#define READERS 3
#define WRITERS 2

int value = 0;                         /* shared data */
int readers = 0;                       /* active reader count */
sem_t rlock;                           /* protects readers counter */
sem_t room;                            /* 1 = room free for a writer */

void *reader(void *arg) {
    long id = (long)arg;
    sem_wait(&rlock);
    if (++readers == 1)
        sem_wait(&room);               /* first reader locks out writers */
    sem_post(&rlock);

    printf("reader %ld reads %d\t(readers inside: %d)\n", id, value, readers);
    usleep(200000);

    sem_wait(&rlock);
    if (--readers == 0)
        sem_post(&room);               /* last reader lets writers in */
    sem_post(&rlock);
    return NULL;
}

void *writer(void *arg) {
    long id = (long)arg;
    sem_wait(&room);                   /* alone in the room */
    value += 10;
    printf("writer %ld writes %d\t(alone)\n", id, value);
    usleep(200000);
    sem_post(&room);
    return NULL;
}
```

== 2. Execution Trace

```bash
$ gcc -Wall -Wextra -pthread -o readers readers.c && ./readers
writer 1 writes 10	(alone)
reader 1 reads 10	(readers inside: 1)
reader 2 reads 10	(readers inside: 2)
reader 3 reads 10	(readers inside: 3)
writer 2 writes 20	(alone)
```

== 3. Observe Answers for Part 3

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. Three readers are inside at the same time, but a writer is always alone. Which two lines of `reader()` make that possible?*
    - *Entry line:* `if (++readers == 1) sem_wait(&room);`
      The first reader acquires the write permit `room`. Subsequent readers bypass this check, joining concurrently.
    - *Exit line:* `if (--readers == 0) sem_post(&room);`
      Only the final departing reader releases `room`, admitting pending writers.

    *2. Why does the counter `readers` need its own lock (`rlock`)? What could go wrong without it?*
    `readers` is a shared global counter. Without `rlock`, concurrent executions of `++readers` or `--readers` cause race conditions. Two readers entering simultaneously could both read `readers == 0`, both increment to 1, and both call `sem_wait(&room)`, causing the second reader to hang indefinitely.

    *3. Imagine readers that keep arriving without a pause. What happens to writer 2? (This problem has a name: starvation.)*
    Writer 2 experiences *writer starvation* (livelock). As long as active readers remain in the room (`readers >= 1`), `room` remains locked. If new readers continuously arrive before the count reaches zero, writers are locked out indefinitely.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 4: Deadlock Synthesis & Prevention (deadlock.c)
// -------------------------------------------------------------
= Part 4: Deadlock Synthesis and Prevention (`deadlock.c`)

== 1. Inducing Deadlock via Inverted Lock Ordering

Two threads acquire mutexes $A$ and $B$ in opposite sequences:

```c
/* Thread 1: A then B */
pthread_mutex_lock(&A);
sleep(1);
pthread_mutex_lock(&B);

/* Thread 2: B then A (inverted) */
pthread_mutex_lock(&B);
sleep(1);
pthread_mutex_lock(&A);
```

Running with `timeout 5`:

```bash
$ timeout 5 ./deadlock_buggy; echo "exit code: $?"
one: I have A, I want B
two: I have B, I want A
exit code: 124
```

== 2. The Solution: Consistent Global Lock Ordering

Enforcing that Thread 2 locks $A$ first, then $B$:

```c
void *two(void *arg) {
    pthread_mutex_lock(&A);            /* consistent ordering */
    pthread_mutex_lock(&B);
    pthread_mutex_unlock(&B);
    pthread_mutex_unlock(&A);
    return NULL;
}
```

```bash
$ gcc -Wall -Wextra -pthread -o deadlock deadlock.c && ./deadlock; echo "exit code: $?"
two: I have A, I want B
two: I have both
one: I have A, I want B
one: I have both
done
exit code: 0
```

== 3. Observe Answers for Part 4

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. In the stuck run, which thread holds which mutex, and which one is each thread waiting for? Draw the circle.*
    - Thread `one` holds Mutex `A` and waits for Mutex `B`.
    - Thread `two` holds Mutex `B` and waits for Mutex `A`.
    - *Circular Wait Cycle:*
      ```text
      Thread one  ──(holds)──>  Mutex A  ──(wanted by)──>  Thread two
          ▲                                                     │
          │                                                     │
        (wanted by)                                           (holds)
          │                                                     │
          └─────────────  Mutex B  <────────────────────────────┘
      ```

    *2. Remove both `sleep(1)` lines from the ORIGINAL version and run it ten times. Does it still always hang? Why is that worse, not better?*
    Without `sleep(1)`, one thread often executes fast enough to acquire both locks and complete before the other thread begins, so the program often exits with 0.
    This is *far worse* because it conceals a fatal architectural flaw behind timing flukes, turning an easily reproducible bug into a rare, unpredictable Heisenbug that evades testing and crashes production systems.

    *3. In one sentence: why can taking the locks in the same order never deadlock?*
    Enforcing a strict, global lock acquisition order eliminates the circular-wait condition, making circular dependencies in the resource allocation graph mathematically impossible.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Comparative Analysis
// -------------------------------------------------------------
= Comparative Analysis of Synchronization Patterns

#table(
  columns: (1.3fr, 2fr, 2fr),
  stroke: 0.4pt + rgb("#cbd5e1"),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
  align: (left, left, left),
  table.header(
    [*Pattern*],
    [*Primary Synchronization Tool*],
    [*Key Invariant Maintained*],
  ),
  [*Producer-Consumer*],
  [Two counting semaphores (`empty`, `full`) + Mutex.],
  [Buffer never overflows ($<= 4$); consumer never reads unwritten slots.],

  [*Condition Variable*],
  [`pthread_cond_t` + Mutex + boolean predicate.],
  [Consumer sleeps with lock released; always re-evaluates predicate in `while`.],

  [*Readers-Writers*],
  [Two binary semaphores (`rlock`, `room`) + counter.],
  [Multiple readers allowed simultaneously; writers maintain strict mutual exclusion.],

  [*Deadlock Prevention*],
  [Strict global lock ordering hierarchy.],
  [Eliminates circular-wait condition across all concurrent threads.],
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Conclusion
// -------------------------------------------------------------
= Conclusion

Laboratory Work 12 combined synchronization tools to solve classical operating system challenges:

1. *Producer-Consumer:* Coordinated producer and consumer threads using counting semaphores and a mutex, preventing buffer underflow/overflow.
2. *Condition Variables:* Demonstrated state-driven thread blocking with `pthread_cond_wait`, establishing why predicates must be evaluated in `while` loops.
3. *Readers-Writers:* Solved reader-preference concurrency and analyzed reader-induced writer starvation.
4. *Deadlock Mechanics:* Synthesized an intentional circular wait resulting in timeout exit code 124, and proved that imposing strict lock ordering hierarchies guarantees deadlock-free execution.
