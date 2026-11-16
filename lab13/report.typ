#set document(
  title: "Laboratory Work 13: Track B: Semaphores in Your Own Kernel (xv6)",
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

  #text(size: 15pt, weight: "regular")[Laboratory Work 13:]

  #v(0.3cm)

  #text(size: 13pt, weight: "regular")[Track B: Semaphores in Your Own Kernel (xv6)]

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

- *Operating System Kernel:* xv6-riscv (MIT teaching operating system, 64-bit RISC-V)
- *Host Machine:* Arch Linux x86_64, Linux Kernel 7.2.9-arch1-1
- *Emulator:* QEMU emulator version 10.2.1 (`qemu-system-riscv64`, simulated 3-core SMP: `CPUS=3`)
- *Cross-Compiler:* `riscv64-linux-gnu-gcc` (GCC 15.2.1)
- *Linker & Binary Utilities:* GNU binutils for RISC-V 64-bit (`riscv64-linux-gnu-ld`, `objdump`)
- *Document Processor:* Typst 0.15.1 (`typst`)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Purpose of the Laboratory Work
// -------------------------------------------------------------
= Purpose of the Laboratory Work

1. Transition from consuming user-space synchronization primitives to constructing an in-kernel counting semaphore subsystem inside the xv6 operating system.
2. Implement three new system calls: `SYS_sem_init` (24), `SYS_sem_down` (25), and `SYS_sem_up` (26), connecting user-space invocation down to kernel dispatch handlers.
3. Design the in-kernel semaphore data structure (`struct sem`), pairing an integer capacity count with a kernel spinlock to guarantee atomicity on symmetric multiprocessing (SMP) hardware.
4. Implement non-busy waiting using xv6's two-step sleep architecture (`sleep_prepare` and `sleep`), ensuring blocked processes surrender the CPU completely without busy-spinning.
5. Prevent kernel deadlocks by rigorously releasing semaphore spinlocks before sleeping and handling process termination signals (`killed()`).
6. Validate semaphore signaling and mutual exclusion under true SMP execution via `semtest` (order synchronization and alternating ping-pong) and `mix` (character-level UART interleaving versus protected critical sections).

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 1: The Numbers and the User Side
// -------------------------------------------------------------
= Part 1: The Numbers and the User Side

== 1. System Call Interface Registration

In xv6, semaphores are numbered $0$ to $7$ (`NSEM = 8`) and shared system-wide across all processes. We register system call identifiers 24, 25, and 26:

=== 1.1 Syscall Identifiers (`kernel/syscall.h`)
```c
#define SYS_sync      22
#define SYS_trace     23
#define SYS_sem_init  24
#define SYS_sem_down  25
#define SYS_sem_up    26
```

=== 1.2 User Function Prototypes (`user/user.h`)
```c
int sync(void);
int trace(int);
int sem_init(int, int);
int sem_down(int);
int sem_up(int);
```

=== 1.3 Assembly Stub Generation (`user/usys.pl`)
```perl
entry("sync");
entry("trace");
entry("sem_init");
entry("sem_down");
entry("sem_up");
```

=== 1.4 Test Utilities
We construct two test programs:
- `user/semtest.c`: Validates process ordering (parent pauses 10 ticks while child sleeps in `sem_down(0)`) and ping-pong synchronization across child and parent using semaphores 1 and 2.
- `user/mix.c`: Demonstrates fine-grained multi-core concurrency by emitting lines character-by-character (`write(1, p, 1)`), showing character corruption without synchronization versus perfectly serialized lines when protected by `sem_down(3)` and `sem_up(3)`.

=== 1.5 Disk Registration (`Makefile`)
We register `$U/_semtest\` and `$U/_mix\` in `UPROGS` in `Makefile`.

== 2. Check 1: Trapping to the Unimplemented Calls

Before implementing the kernel handlers, we boot QEMU and execute `semtest`. Because the kernel has no table entries for 24, 25, 26, it catches the undefined syscalls:

```bash
$ semtest
3 semtest: unknown sys call 24
4 semtest: unknown sys call 25
child: I ran after the parent
parent: done, I let the child go
```

*Verification Result:* The output verifies that user programs successfully executed `ecall` with registers `a7 = 24` and `a7 = 25`. Because semaphores did not yet block the child, the child executed before the parent.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 2: The Kernel Side
// -------------------------------------------------------------
= Part 2: The Kernel Side

== 1. Semaphore Architecture (`kernel/sem.c`)

We implement the complete semaphore subsystem in `kernel/sem.c`:

```c
// sem.c: counting semaphores inside the xv6 kernel (Lab 12).
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "proc.h"

#define NSEM 8

struct sem {
  struct spinlock lock;  // protects the counter
  int value;             // capacity count
};

static struct sem sems[NSEM];

uint64
sys_sem_init(void)
{
  int id, value;
  argint(0, &id);
  argint(1, &value);
  if (id < 0 || id >= NSEM || value < 0)
    return -1;
  acquire(&sems[id].lock);
  sems[id].value = value;
  release(&sems[id].lock);
  return 0;
}

uint64
sys_sem_down(void)
{
  int id;
  argint(0, &id);
  if (id < 0 || id >= NSEM)
    return -1;
  struct sem *s = &sems[id];
  acquire(&s->lock);
  while (s->value == 0) {
    sleep_prepare(s);      // register sleep channel on &sems[id]
    release(&s->lock);     // release spinlock before sleeping
    sleep();               // deschedule until wakeup
    acquire(&s->lock);     // re-acquire spinlock upon waking
    if (killed(myproc())) {
      release(&s->lock);
      return -1;
    }
  }
  s->value--;
  release(&s->lock);
  return 0;
}

uint64
sys_sem_up(void)
{
  int id;
  argint(0, &id);
  if (id < 0 || id >= NSEM)
    return -1;
  struct sem *s = &sems[id];
  acquire(&s->lock);
  s->value++;
  wakeup(s);              // wake all processes sleeping on &sems[id]
  release(&s->lock);
  return 0;
}
```

== 2. Kernel Integration

1. In `Makefile`, we add `$K/sem.o \` to `OBJS`.
2. In `kernel/syscall.c`, we declare externs and add `[SYS_sem_init]`, `[SYS_sem_down]`, and `[SYS_sem_up]` to both `syscalls[]` and `syscallnames[]`.

== 3. Check 2: Validation of `semtest`

We compile and boot QEMU, executing `semtest`:

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

*Verification Result:*
- The parent pauses for 10 ticks, yet the child outputs second. The child was descheduled asleep inside `sys_sem_down(0)` without burning CPU cycles until awakened by the parent's `sem_up(0)`.
- Test 2 proves bidirectional signaling: Ping and Pong alternate deterministically across three iterations without race conditions.
- The program concludes with `semtest: OK`.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 3: A Semaphore as a Lock: mix
// -------------------------------------------------------------
= Part 3: A Semaphore as a Lock: `mix`

== 1. Concurrency Stress Test

The utility `user/mix.c` executes two concurrent processes on a 3-CPU SMP virtual machine. Each process prints 5 lines, emitting one character per `write(1, p, 1)` system call (31 system calls per line).

=== 3.1 Execution Without Lock (`mix`)
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

=== 3.2 Execution With Lock (`mix lock`)
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

== 2. Observe Questions & Answers

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. Without the lock, why do the letters mix? (How many system calls does one line cost?)*
    `lines()` prints strings character-by-character: `for (char *p = s; *p; p++) write(1, p, 1);`.
    Printing a 30-character line plus newline requires *31 separate `write()` system calls*.
    Because xv6 runs on 3 simulated CPU cores (`CPUS=3`), the parent and child processes execute genuinely in parallel. Without a synchronization lock, individual 1-byte system calls interleave arbitrarily at the console UART FIFO queue, producing mixed character output on the terminal.

    *2. With the lock every line is whole. Which two lines of `mix.c` make one line a critical section?*
    The critical section boundaries are:
    - *Entry protocol:* `if (uselock) sem_down(3);`
    - *Exit protocol:* `if (uselock) sem_up(3);`
    Because semaphore 3 is initialized to 1 (`sem_init(3, 1)`), it acts as a mutual exclusion lock. Whichever process acquires semaphore 3 holds exclusive console access until the entire 31-character loop finishes.

    *3. In `sem_down` the test is "while (s->value == 0)", not "if". Why can a process wake up and still find 0?*
    When a thread wakes up from `sleep()`, it is merely placed back onto the `RUNNABLE` list; it does not atomically re-enter execution with the lock held. Upon resuming, it must call `acquire(&s->lock)`. In the window between `wakeup(s)` and lock acquisition, another process on another CPU core could execute `sem_down()`, acquire `s->lock`, decrement `s->value` back to 0, and release the lock. If `sem_down` used `if`, the awakened process would decrement 0 to -1, corrupting the semaphore. A `while` loop forces it to re-evaluate the predicate and return to sleep if no capacity remains.

    *4. `sem_down` calls `release(&s->lock)` BEFORE `sleep()`. What would go wrong if it slept holding the spinlock?*
    Sleeping while holding a spinlock violates xv6's fundamental concurrency model and causes an immediate, catastrophic *kernel deadlock*:
    1. Spinlocks disable interrupts on the holding core. If a process slept with `s->lock` held, no other thread on any core could acquire `s->lock`.
    2. Crucially, the only way for the sleeping process to be awakened is for another process to execute `sys_sem_up()`. But `sys_sem_up()` begins with `acquire(&s->lock)`. If the sleeping process holds `s->lock`, `sys_sem_up()` spins indefinitely in `acquire()` with interrupts disabled, unable to ever reach `wakeup(s)`. The operating system freezes permanently.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Comparative Analysis: Linux vs xv6 Semaphores
// -------------------------------------------------------------
= Comparative Analysis: Linux vs xv6 Semaphores

#table(
  columns: (1.2fr, 2fr, 2fr),
  stroke: 0.4pt + rgb("#cbd5e1"),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
  align: (left, left, left),
  table.header(
    [*Dimension*],
    [*Linux POSIX Semaphores (`sem_t`)*],
    [*xv6 In-Kernel Semaphores (`struct sem`)*],
  ),
  [*Implementation Domain*],
  [User-space library (`glibc`), backed by the Linux `futex(2)` system call.],
  [Kernel space, directly integrated into the monolithic kernel table.],

  [*Blocking Primitives*],
  [Futex wait queues managed by the kernel scheduler (`sys_futex`).],
  [Kernel sleep channels (`sleep_prepare`, `sleep`, `wakeup`) on `struct proc`.],

  [*Mutual Exclusion*],
  [Atomic compare-and-swap assembly instructions (`lock cmpxchg`).],
  [Hardware-level RISC-V spinlocks (`acquire`, `release` via `amoswap`).],

  [*Process Sharing*],
  [Shared via memory-mapped regions (`mmap` with `MAP_SHARED`).],
  [Global system array (`sems[NSEM]`), shared by all processes by integer ID.],

  [*Resource Reclamation*],
  [Explicit destruction with `sem_destroy()` or unlinking named semaphores.],
  [Fixed static kernel array (`NSEM = 8`); survives process termination.],
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Conclusion
// -------------------------------------------------------------
= Conclusion

Laboratory Work 13 demystified the internal mechanics of operating system synchronization by constructing counting semaphores inside the xv6 kernel:

1. *System Call Mechanics:* Successfully added system calls 24, 25, and 26, tracing their execution from user stubs to kernel dispatch handlers.
2. *Non-Busy Waiting:* Implemented true kernel-level sleeping with `sleep_prepare()` and `sleep()`, guaranteeing that blocked processes surrender the CPU without consuming cycles.
3. *Concurrency Safety:* Enforced strict spinlock discipline, avoiding kernel deadlocks by releasing locks prior to sleeping and re-evaluating predicates inside `while` loops.
4. *Symmetric Multiprocessing Verification:* Validated multi-core synchronization on 3 CPUs, proving that in-kernel semaphores eliminate race conditions and serialize hardware I/O.
