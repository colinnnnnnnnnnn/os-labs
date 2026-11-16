#set document(
  title: "Laboratory Work 10: Track B: Add a System Call, trace (xv6)",
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

  #text(size: 15pt, weight: "regular")[Laboratory Work 10:]

  #v(0.3cm)

  #text(size: 13pt, weight: "regular")[Track B: Add a System Call, trace (xv6)]

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
- *Emulator:* QEMU emulator version 10.2.1 (`qemu-system-riscv64`)
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

1. Extend the core operating system kernel with a novel system call, following the complete lifecycle of a software trap from user space down to the kernel dispatch table and hardware trapframe.
2. Implement system call number 23 (`SYS_trace`) in xv6, establishing user-space function prototypes, Perl-generated assembly trampolines (`ecall`), and user-level utility orchestration.
3. Augment the process control block (`struct proc`) with tracing metadata (`trace_mask`) that persists across program execution substitutions (`exec`) and propagates across process replication (`fork`).
4. Implement the kernel-side system call handler (`sys_trace`) in `kernel/sysproc.c`, retrieving arguments safely from user-space CPU register `a0` via `argint()`.
5. Instrument the kernel system call dispatcher (`kernel/syscall.c`) to intercept every returning system call, evaluate bitmask criteria, and output process ID, system call name, and return value to the kernel console via `printk`.
6. Empirically verify system call tracing with selective bitmasks, analyzing process hierarchies under stress testing (`forkforkfork`), output interleaving in `echo`, and precise multi-call bit filtering.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 1: The Number and the User Side
// -------------------------------------------------------------
= Part 1: The Number and the User Side

== 1. Architecture of an xv6 System Call

In xv6 on RISC-V, user programs execute in unprivileged User Mode (U-mode). When a user application requires operating system services, it loads the numeric system call identifier into register `a7`, places call arguments into registers `a0`, `a1`, etc., and executes the `ecall` (environment call) instruction. This elevates processor execution privilege into Supervisor Mode (S-mode) and vectors into the kernel trap handler.

To add `trace`, five edits establish the user-space contract and assembly invocation.

== 2. Step-by-Step Implementation

=== 2.1 Syscall Number Definition (`kernel/syscall.h`)
We assign identifier 23 to `SYS_trace`, placing it directly after UTM's existing `SYS_sync` (22):

```c
#define SYS_sync   22
#define SYS_trace  23
```

=== 2.2 User-Space Declaration (`user/user.h`)
We declare the function prototype accessible to user applications:

```c
int sync(void);
int trace(int);
```

=== 2.3 Assembly Stub Generation (`user/usys.pl`)
During compilation, `user/usys.pl` writes `user/usys.S`. Adding `entry("trace");` generates the exact assembly stub:

```perl
entry("sync");
entry("trace");
```

The resulting assembly code in `usys.S` is:

```riscv
.global trace
trace:
 li a7, SYS_trace
 ecall
 ret
```

=== 2.4 User Launcher Utility (`user/trace.c`)
We implement the user-level command launcher `user/trace.c`. It parses the integer mask, invokes `trace(mask)`, and replaces itself with the requested command via `exec()`:

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argc < 3) {
    fprintf(2, "usage: trace mask command [args...]\n");
    exit(1);
  }
  if (trace(atoi(argv[1])) < 0) {
    fprintf(2, "trace: failed\n");
    exit(1);
  }
  exec(argv[2], argv + 2);
  fprintf(2, "trace: exec %s failed\n", argv[2]);
  exit(1);
}
```

Because `exec()` preserves the process ID and memory allocation state of the process struct, the tracing mask established on the process persists into the newly executed binary.

=== 2.5 Disk Image Integration (`Makefile`)
We add `$U/_trace\` to `UPROGS` in `Makefile` to include the binary in `fs.img`:

```make
	$U/_zombie\
	$U/_trace\
```

== 3. Check 1: Verification of User-to-Kernel Trap Transition

We build xv6 and boot QEMU. Because the user side is wired to issue syscall 23, but the kernel dispatch table does not yet recognise it, the kernel must catch the unhandled number in `kernel/syscall.c`:

```bash
$ trace 32 grep hello README
3 trace: unknown sys call 23
trace: failed
```

*Verification Result:* This confirms that `ecall` was successfully executed with `a7 = 23`, transferred through `usertrap()`, arrived at `syscall()`, failed the lookup table check, returned `-1`, and triggered `trace: failed`.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 2: The Kernel Side
// -------------------------------------------------------------
= Part 2: The Kernel Side

== 1. Kernel Implementation Steps

=== 2.1 Process State Storage (`kernel/proc.h`)
Each process must track which system calls it should print. We add `int trace_mask;` to `struct proc`:

```c
  char name[16];               // Process name (debugging)
  int trace_mask;              // new: which calls to print
};
```

=== 2.2 System Call Handler (`kernel/sysproc.c`)
We implement `sys_trace()` at the end of `kernel/sysproc.c`. The helper `argint(0, &mask)` fetches the 32-bit integer passed in register `a0`:

```c
uint64
sys_trace(void)
{
  int mask;
  argint(0, &mask);
  myproc()->trace_mask = mask;
  return 0;
}
```

=== 2.3 Dispatch Table Registration (`kernel/syscall.c`)
We declare the handler and map index `[SYS_trace]` in the function pointer table:

```c
extern uint64 sys_sync(void);
extern uint64 sys_trace(void);

static uint64 (*syscalls[])(void) = {
...
  [SYS_sync]    = sys_sync,
  [SYS_trace]   = sys_trace,
};
```

=== 2.4 Name Resolution and Trace Emission (`kernel/syscall.c`)
Because numbers are opaque, we add `syscallnames[]` above `syscall()`:

```c
static char *syscallnames[] = {
[SYS_fork]    "fork",
[SYS_exit]    "exit",
[SYS_wait]    "wait",
[SYS_pipe]    "pipe",
[SYS_read]    "read",
[SYS_kill]    "kill",
[SYS_exec]    "exec",
[SYS_fstat]   "fstat",
[SYS_chdir]   "chdir",
[SYS_dup]     "dup",
[SYS_getpid]  "getpid", [SYS_sbrk] "sbrk",
[SYS_pause]   "pause",  [SYS_uptime] "uptime", [SYS_open] "open",
[SYS_write]   "write",  [SYS_mknod] "mknod",
[SYS_unlink]  "unlink",
[SYS_link]    "link",
[SYS_mkdir]   "mkdir",
[SYS_close]   "close",
[SYS_sync]    "sync",
[SYS_trace]   "trace",
};
```

Then, inside `syscall()`, immediately following the execution of `syscalls[num]()`, we evaluate whether the bit at position `num` is set in `trace_mask`, and log using UTM xv6's `printk`:

```c
  p->trapframe->a0 = syscalls[num]();
  if ((p->trace_mask >> num) & 1)
    printk("%d: syscall %s -> %ld\n",
           p->pid, syscallnames[num], p->trapframe->a0);
```

Placing this check after `syscalls[num]()` ensures that register `a0` already holds the final return value of the system call.

=== 2.5 Inheritance Across Process Cloning (`kernel/proc.c`)
To ensure that child processes created by `fork()` inherit the tracing mask of their parent, we copy `trace_mask` inside `fork()` right after copying the process name:

```c
  safestrcpy(np->name, p->name, sizeof(p->name));
  np->trace_mask = p->trace_mask;
```

== 2. Check 2: Functional Verification

We rebuild xv6 and run `trace 32 grep hello README`:

```bash
$ trace 32 grep hello README
3: syscall read -> 1023
3: syscall read -> 965
3: syscall read -> 453
3: syscall read -> 0
```

*Verification Result:* The output verifies complete correctness. The three chunk sizes ($1023 + 965 + 453 = 2441$) sum to the exact byte size of `README`. The final return value of `0` denotes End-Of-File (EOF).

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 3: Play with the Mask
// -------------------------------------------------------------
= Part 3: Play with the Mask

== 1. Empirical Experiments

=== 3.1 All Calls Enabled (Mask `2147483647` = $2^{31} - 1$)

We execute `trace` with every positive 31-bit mask position active:

```bash
$ trace 2147483647 grep hello README
3: syscall trace -> 0
3: syscall exec -> 3
3: syscall open -> 3
3: syscall read -> 1023
3: syscall read -> 965
3: syscall read -> 453
3: syscall read -> 0
3: syscall close -> 0
```

Every stage of command execution is revealed: initial `trace` setup, `exec` loading `/grep`, opening `README` on descriptor 3, reading until EOF, and closing descriptor 3.

=== 3.2 Process Replication Tracing (Mask `2` = $2^1$, `SYS_fork`)

We test recursive process instantiation using `usertests forkforkfork`:

```bash
$ trace 2 usertests forkforkfork
usertests starting
test forkforkfork: 3: syscall fork -> 4
4: syscall fork -> 5
5: syscall fork -> 6
5: syscall fork -> 7
6: syscall fork -> 8
5: syscall fork -> 9
...
5: syscall fork -> 64
6: syscall fork -> -1
5: syscall fork -> -1
7: syscall fork -> -1
OK
ALL TESTS PASSED
```

When the maximum process limit is reached (`NPROC = 64`), `sys_fork` fails and returns `-1`.

=== 3.3 Output Interleaving (Mask `65536` = $2^{16}$, `SYS_write`)

We test tracing on `echo hi`:

```bash
$ trace 65536 echo hi
hi3: syscall write -> 2

3: syscall write -> 1
```

Notice that `"hi"` is printed first, followed immediately by `3: syscall write -> 2` on the exact same line, followed by the newline and `3: syscall write -> 1`.

=== 3.4 Selective Filtering: Open and Close Only (Mask `2129920`)

We compute the mask to trace exclusively `open` (15) and `close` (21):

$$\text{Mask} = 2^{15} + 2^{21} = 32768 + 2097152 = 2129920$$

Executing in xv6:

```bash
$ trace 2129920 grep hello README
3: syscall open -> 3
3: syscall close -> 0
```

Only `open` and `close` are captured; all intermediate `read` calls are suppressed.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Observe Questions and Answers
// -------------------------------------------------------------
= Observe Questions & Detailed Answers

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *Question 1: In `trace 32 grep hello README` why do you see only read, and not open or close?*

    *Answer:*
    The trace mask `32` equals $2^5$ (`0b00000000000000000000000000100000`), meaning that exclusively bit index 5 is active. In xv6, system call numbers are defined as integer constants in `kernel/syscall.h`:
    - `SYS_read` is 5 ($2^5 = 32$)
    - `SYS_open` is 15 ($2^{15} = 32768$)
    - `SYS_close` is 21 ($2^{21} = 2097152$)

    Inside `kernel/syscall.c`, the kernel determines whether to log each call using the bitwise test:
    ```c
    if ((p->trace_mask >> num) & 1)
    ```
    For `num = 5`, `(32 >> 5) & 1` evaluates to `1`, triggering `printk`. For `num = 15` or `num = 21`, shifting 32 right by 15 or 21 bit positions yields `0`, which evaluates to false. Thus, `open` and `close` execute normally in the kernel without producing any console log output.
  ]
)

#v(0.2cm)

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *Question 2: In `forkforkfork`, three different pids print lines. Which line of code from Part 2 makes that possible?*

    *Answer:*
    The line added inside `kernel/proc.c` within the `fork()` function:
    ```c
    np->trace_mask = p->trace_mask;
    ```
    When a parent process forks, `np` represents the newly allocated child `struct proc`. Copying `p->trace_mask` directly ensures that child processes inherit their parent's active tracing mask. As child processes subsequently fork their own children (producing grandchildren with distinct PIDs like 3, 4, 5, 6, 7), the non-zero mask persists through every generation, enabling all descendants to emit trace messages for their respective `fork` calls.
  ]
)

#v(0.2cm)

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *Question 3: In `trace 65536 echo hi` the trace line is printed between "hi" and the new line. Why? (How many times does echo call write?)*

    *Answer:*
    `echo` calls `write()` *two times*:
    1. *First Call:* `write(1, "hi", 2)` emits the word `"hi"`. The two bytes are copied into the UART transmit FIFO and displayed on the console immediately. When `syscalls[SYS_write]()` completes, the kernel executes `printk("%d: syscall write -> %ld\n", ...)`. Because the preceding user write did not contain a trailing newline, the kernel's trace output `3: syscall write -> 2\n` is concatenated directly onto the same line: `"hi3: syscall write -> 2"`.
    2. *Second Call:* `write(1, "\n", 1)` emits the trailing newline. Once completed, the kernel emits the second trace line `3: syscall write -> 1\n`.
  ]
)

#v(0.2cm)

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *Question 4: Which mask traces both open (15) and close (21), and nothing else?*

    *Answer:*
    To trace exclusively system call 15 (`SYS_open`) and system call 21 (`SYS_close`), the mask must have bit 15 and bit 21 set to 1, with all other bits cleared:
    $$
    \text{Mask} = (1 \ll 15) \mid (1 \ll 21) = 2^{15} + 2^{21} = 32768 + 2097152 = \mathbf{2129920}
    $$
    In hexadecimal representation, this corresponds to `0x208000`. When executed in xv6:
    ```bash
    $ trace 2129920 grep hello README
    3: syscall open -> 3
    3: syscall close -> 0
    ```
    This confirms that exclusively `open` and `close` are traced.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Comparative Analysis: Linux strace vs xv6 trace
// -------------------------------------------------------------
= Comparative Analysis: Linux `strace` vs xv6 `trace`

#table(
  columns: (1.2fr, 2fr, 2fr),
  stroke: 0.4pt + rgb("#cbd5e1"),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
  align: (left, left, left),
  table.header(
    [*Dimension*],
    [*Linux `strace` (Lab 9)*],
    [*xv6 `trace` (Lab 10)*],
  ),
  [*Architecture*],
  [External debugging utility operating via `ptrace(2)` system call mechanism.],
  [Kernel-native instrumentation baked into `syscall()` dispatch loop.],

  [*Execution Overhead*],
  [Substantial: two context switches per syscall (stop at entry, stop at exit).],
  [Minimal: single in-kernel bitmask check `(trace_mask >> num) & 1` and `printk`.],

  [*Filtering Primitives*],
  [String-based expression parser (`-e trace=openat,read`, `-e trace=desc`).],
  [Lightweight integer bitmask (`1 << SYS_num`), evaluated via bitwise shift.],

  [*Argument Introspection*],
  [Decodes structs, string pointers, flags (`O_RDONLY`, `O_CLOEXEC`), and buffer previews.],
  [Displays numeric register return value (`a0`) and symbolic syscall name.],

  [*Process Inheritance*],
  [Controlled by user flag (`-f` tracks children via `PTRACE_O_TRACEFORK`).],
  [Always inherited: `np->trace_mask = p->trace_mask` inside `kfork()` in `proc.c`.],
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Conclusion
// -------------------------------------------------------------
= Conclusion

Laboratory Work 10 completed the exploration of operating system call interfaces by taking us inside the kernel implementation:

1. *The System Call Pipeline:* Traced the complete path of system call 23 (`SYS_trace`) from high-level C code, through assembly stub generation (`ecall`), CPU mode elevation, trap vectoring, kernel dispatch tables, and register return values in `p->trapframe->a0`.
2. *State Persistence and Inheritance:* Demonstrated how adding fields to `struct proc` enables persistent per-process kernel configurations across address space substitution (`exec`) and how explicit copying in `fork()` ensures automatic child inheritance.
3. *Bitmask Interception:* Utilized binary bitmasks to build high-performance, selective filtering directly inside the kernel dispatcher without complex string matching.
4. *Empirical Verification:* Successfully verified all lab milestones in QEMU, proving that xv6's modular monolithic design allows clean, robust kernel extensions.
