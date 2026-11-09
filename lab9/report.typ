#set document(
  title: "Laboratory Work 9: Track A: Watching System Calls with strace (Linux)",
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

  #text(size: 15pt, weight: "regular")[Laboratory Work 9:]

  #v(0.3cm)

  #text(size: 13pt, weight: "regular")[Track A: Watching System Calls with strace (Linux)]

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
- *Host Compiler:* GNU GCC 15.2.1 (`gcc -Wall -Wextra -O2`)
- *System Call Tracer:* `strace` version 5.6 (`x86_64`, ptrace-based syscall interception)
- *Introspection Utilities:* GNU Coreutils 9.6 (`ls`), `file`, `readelf`
- *Document Processor:* Typst 0.15.1 (`typst`)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Purpose of the Laboratory Work
// -------------------------------------------------------------
= Purpose of the Laboratory Work

1. Demystify the software boundary between user-space application execution and kernel-space privileged services mediated by hardware system call mechanisms (`syscall` instruction on x86_64).
2. Utilize `strace` to intercept, decode, and analyze raw system call invocations, argument registers, and return codes emitted by standard Unix utilities (`ls -l`).
3. Construct a low-level C program (`syscalls.c`) performing file creation, data persistence, and retrieval exclusively via fundamental POSIX system calls (`open`, `write`, `read`, `close`) without library stream abstractions (`FILE*`).
4. Trace `syscalls.c` from the exterior to empirically correlate high-level C system call invocations with kernel-level traps (`openat`, `write`, `read`, `close`).
5. Investigate the POSIX lowest-numbered file descriptor allocation guarantee and explain why newly allocated file descriptors start at index 3 instead of 0, 1, or 2.
6. Conduct aggregate profiling using `strace -c` to assess system call frequencies, error rates, and kernel time distributions across simple and complex user-space programs.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 1: Tracing a Real Command (ls -l)
// -------------------------------------------------------------
= Part 1: See the Calls of a Real Command (`ls -l`)

== 1. Background & Methodology

When a user executes a command such as `ls -l`, user code cannot directly interact with storage hardware or the video display controller. Every directory entry lookup, security credential verification, and terminal character display must traverse the kernel through system calls.

The `strace` utility relies on the `ptrace(2)` Linux system call (`PTRACE_SYSCALL`) to intercept child process execution before and after every transition through the CPU's `syscall` gate, capturing the arguments in CPU registers (`%rdi`, `%rsi`, `%rdx`, `%r10`, `%r8`, `%r9`) and the return code in `%rax`.

We filter the output of `ls -l` using `-e trace=openat,read,write,close` and `-f` to trace child threads or child processes:

```bash
$ strace -f -e trace=openat,read,write,close ls -l
```

== 2. Execution Trace

```text
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/libcap.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320{\0\0\0\0\0\0"..., 1024) = 1024
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300y\2\0\0\0\0\0"..., 1024) = 1024
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
close(3)                                = 0
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
read(3, "# Locale name alias data base.\n#"..., 4096) = 2998
read(3, "", 4096)                       = 0
close(3)                                = 0
openat(AT_FDCWD, ".", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 4
read(4, "# Name Service Switch configurat"..., 4096) = 359
read(4, "", 4096)                       = 0
close(4)                                = 0
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 4
read(4, "root:x:0:0::/root:/usr/bin/bash\n"..., 4096) = 3265
close(4)                                = 0
openat(AT_FDCWD, "/etc/group", O_RDONLY|O_CLOEXEC) = 4
read(4, "root:x:0:brltty,root\nsys:x:3:bin"..., 4096) = 1507
close(4)                                = 0
write(1, "total 652\n", 10)             = 10
openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\20\0\0\0\20\0\0\0\0"..., 4096) = 2424
close(3)                                = 0
write(1, "-rw-r--r-- 1 calin calin 346894 Nov  2 16:25 'OS 2026 - Lab 10 - Add a System Call, trace (xv6).pdf'\n", 101) = 101
write(1, "-rw-r--r-- 1 calin calin 306916 Nov  2 16:25 'OS 2026 - Lab 9 - Watching System Calls (Linux).pdf'\n", 99) = 99
close(1)                                = 0
close(2)                                = 0
+++ exited with 0 +++
```

== 3. Observe Answers for Part 1

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *1. Which system call does `ls` use to print to the screen?*
    `ls` uses the *`write()`* system call (specifically, the 64-bit Linux system call entry `sys_write`, syscall number 1 on x86_64).

    *2. To which descriptor does it write?*
    It writes to file descriptor *`1`*, which corresponds to standard output (*`stdout`* / `STDOUT_FILENO`). Under normal execution attached to a terminal, file descriptor 1 refers to the character device representing the active terminal or pseudo-terminal (`/dev/pts/X`).
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 2: Program Calling Kernel Directly (syscalls.c)
// -------------------------------------------------------------
= Part 2: Direct Kernel File I/O (`syscalls.c`)

== 1. Implementation

Standard C applications frequently interact with files through standard library abstractions such as `fopen()`, `fprintf()`, and `fread()`. While convenient, these library calls introduce user-space buffering (`FILE` struct) and wrapper overhead. 

The program `syscalls.c` bypasses standard I/O streams for file persistence, directly invoking kernel entry points declared in `<fcntl.h>` and `<unistd.h>`:

```c
/* syscalls.c - open, write, read and close, using only system calls.
 * Build: gcc -Wall -Wextra -o syscalls syscalls.c
 * Run:   ./syscalls
 * See the calls: strace ./syscalls
 */
#include <fcntl.h>   /* open */
#include <unistd.h>  /* write, read, close */
#include <string.h>  /* strlen */
#include <stdio.h>   /* printf */

int main(void) {
    const char *msg = "hello, kernel\n";

    /* open() is a system call: ask the kernel for a file, get back a descriptor */
    int fd = open("note.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if (fd < 0) { perror("open"); return 1; }
    printf("open returned descriptor %d\n", fd);

    /* write() is a system call: hand the bytes to the kernel */
    ssize_t n = write(fd, msg, strlen(msg));
    printf("write sent %zd bytes\n", n);
    close(fd);

    /* read it back, through the kernel again */
    fd = open("note.txt", O_RDONLY);
    char buf[64];
    n = read(fd, buf, sizeof(buf) - 1);
    buf[n] = '\0';
    printf("read got %zd bytes: %s", n, buf);
    close(fd);

    return 0;
}
```

== 2. Compilation and Native Execution

We compile `syscalls.c` under strict compiler flags (`-Wall -Wextra -O2`) and execute it directly:

```bash
$ gcc -Wall -Wextra -O2 -o syscalls syscalls.c
$ ./syscalls
open returned descriptor 3
write sent 14 bytes
read got 14 bytes: hello, kernel
```

The output confirms:
- The initial file creation via `open("note.txt", ...)` successfully yielded descriptor `3`.
- The call `write(3, "hello, kernel\n", 14)` successfully committed all 14 bytes to the kernel filesystem buffer cache.
- The subsequent read reopened the file and populated the stack buffer with the exact 14 bytes.

== 3. Introspection via `strace`

We run `syscalls` under `strace`, filtering for `openat,write,read,close`:

```bash
$ strace -e trace=openat,write,read,close ./syscalls
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300y\2\0\0\0\0\0"..., 1024) = 1024
close(3)                                = 0
openat(AT_FDCWD, "note.txt", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 3
write(1, "open returned descriptor 3\n", 27) = 27
write(3, "hello, kernel\n", 14)         = 14
write(1, "write sent 14 bytes\n", 20)   = 20
close(3)                                = 0
openat(AT_FDCWD, "note.txt", O_RDONLY)  = 3
read(3, "hello, kernel\n", 63)          = 14
write(1, "read got 14 bytes: hello, kernel\n", 33) = 33
close(3)                                = 0
+++ exited with 0 +++
```

=== Mapping C Functions to System Calls:
1. `open("note.txt", O_CREAT|O_WRONLY|O_TRUNC, 0644)` translates in Linux glibc to the modern `openat(AT_FDCWD, "note.txt", ...)` call, returning descriptor `3`.
2. `printf("open returned descriptor %d\n", fd)` internally flushes to `write(1, "open returned descriptor 3\n", 27)`.
3. `write(fd, msg, strlen(msg))` produces `write(3, "hello, kernel\n", 14) = 14`.
4. `close(fd)` issues `close(3) = 0`.
5. The second `open("note.txt", O_RDONLY)` reallocates index `3` (`openat(...) = 3`).
6. `read(fd, buf, 63)` invokes `read(3, "hello, kernel\n", 63) = 14`.
7. `close(fd)` finalizes file descriptor reclamation (`close(3) = 0`).

== 4. Observe Answers for Part 2

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 10pt,
  radius: 4pt,
  [
    *Observe: The descriptor returned by the first openat is 3, not 0, 1 or 2. Why are those three already taken?*

    Under standard POSIX / Unix operating system design, when a process is spawned (via `fork` followed by `execve`), the runtime environment inherits three standard streams that occupy the lowest file descriptor slots in the process's file descriptor table:
    - *Descriptor `0` (`STDIN_FILENO`):* Standard Input (attached to keyboard input or upstream pipe).
    - *Descriptor `1` (`STDOUT_FILENO`):* Standard Output (attached to the display console or downstream pipe).
    - *Descriptor `2` (`STDERR_FILENO`):* Standard Error (unbuffered diagnostic channel attached to console).

    *The Lowest-Free-Descriptor Guarantee:*
    POSIX specifies that any system call creating or opening a new file descriptor (`open`, `openat`, `dup`, `pipe`, `socket`) MUST allocate the *lowest-numbered unused file descriptor* available to that process. Because slots `0`, `1`, and `2` are already occupied when `main()` commences execution, the first free integer index is *`3`*.

    Furthermore, when `close(3)` is called after writing, slot `3` returns to the pool of unused descriptors. Consequently, when `open("note.txt", O_RDONLY)` is called immediately afterwards, the lowest free descriptor is again *`3`*, which is why both `open` calls deterministically receive descriptor 3.
  ]
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Part 3: Aggregate Call Profiling (strace -c)
// -------------------------------------------------------------
= Part 3: Aggregate Call Profiling (`strace -c`)

== 1. Profiling Commands & Methodology

The `-c` (summary) option of `strace` attaches to the target process, measures execution wall-clock time spent inside kernel mode for each distinct system call, counts total invocations, and computes error frequencies.

== 2. Profile Summary for `ls -l`

```bash
$ strace -c ls -l
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 42.67    0.000637           9        69        27 openat
 12.19    0.000182           4        44           close
  9.38    0.000140           4        32           statx
  5.96    0.000089           4        21           mmap
  3.88    0.000058           9         6           mprotect
  3.75    0.000056           3        17           fstat
  3.42    0.000051           3        13           read
  3.22    0.000048          12         4           getdents64
  3.15    0.000047           9         5           write
  1.94    0.000029           3         8           lseek
  1.94    0.000029           3         9           newfstatat
  1.61    0.000024           4         6         4 prctl
  1.61    0.000024           6         4           llistxattr
  1.27    0.000019           9         2           getrandom
  1.00    0.000015           3         4           rt_sigprocmask
  0.67    0.000010           3         3           brk
  0.54    0.000008           8         1           ioctl
  0.54    0.000008           4         2           fcntl
  0.54    0.000008           4         2           futex
  0.40    0.000006           6         1           clock_gettime
  0.33    0.000005           5         1           prlimit64
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0         1           set_robust_list
  0.00    0.000000           0         1           rseq
------ ----------- ----------- --------- --------- ----------------
100.00    0.001493           5       260        32 total
```

== 3. Profile Summary for `./syscalls`

```bash
$ strace -c ./syscalls
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 42.34    0.000307         307         1           execve
 16.00    0.000116          29         4           openat
 10.07    0.000073          18         4           close
  9.66    0.000070           8         8           mmap
  5.93    0.000043          10         4           write
  3.17    0.000023          11         2           newfstatat
  2.62    0.000019           6         3           mprotect
  2.07    0.000015           5         3           brk
  1.93    0.000014          14         1         1 access
  1.66    0.000012           4         3           fstat
  1.38    0.000010           5         2           read
  0.97    0.000007           3         2           getrandom
  0.55    0.000004           4         1           prlimit64
  0.41    0.000003           3         1           arch_prctl
  0.41    0.000003           3         1           set_tid_address
  0.41    0.000003           3         1           set_robust_list
  0.41    0.000003           3         1           rseq
------ ----------- ----------- --------- --------- ----------------
100.00    0.000725          17        42         1 total
```

== 4. Detailed Analysis of System Call Aggregation

1. *Dynamic Linker Overhead:* In both programs, over 80% of total system call occurrences stem from the dynamic linker (`/lib64/ld-linux-x86-64.so.2`) loading shared objects (`libc.so.6`, `libcap.so.2`), mapping text and data sections into memory (`mmap`, `mprotect`), setting thread structures (`arch_prctl`, `set_tid_address`, `rseq`), and seeding security cookies (`getrandom`).
2. *Filesystem Discovery in `ls`:* `ls` executes 260 system calls. It uses `openat` and `getdents64` to retrieve directory entries, and `statx` to query file metadata (permissions, owner UID/GID, timestamps, file sizes) for every listed entity. Furthermore, resolving numeric UIDs/GIDs to human-readable strings requires reading `/etc/nsswitch.conf`, `/etc/passwd`, and `/etc/group`.
3. *Error Codes Are Normal:* Notice that `ls` reports 32 system call errors (primarily in `openat` and `prctl`). These are not application crashes; they represent standard fallback lookups (e.g., trying localization files `/usr/share/locale/en_US.UTF-8/...` which return `-1 ENOENT` before defaulting to C locale).
4. *Direct System Call Purity in `syscalls`:* For `syscalls.c`, out of 42 calls, exactly 6 system calls represent our explicit file interactions (`openat` x 2, `write` x 1, `read` x 1, `close` x 2), while 3 `write` calls correspond to `printf` screen logging.

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Comparative Analysis
// -------------------------------------------------------------
= Comparative Analysis: Standard I/O vs Direct Kernel System Calls

#table(
  columns: (1.3fr, 2fr, 2fr),
  stroke: 0.4pt + rgb("#cbd5e1"),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
  align: (left, left, left),
  table.header(
    [*Dimension*],
    [*Direct POSIX System Calls (`unistd.h`)*],
    [*C Standard Library I/O (`stdio.h`)*],
  ),
  [*Interface & Abstraction*],
  [`open()`, `read()`, `write()`, `close()`. Operates on integer file descriptors (`int fd`).],
  [`fopen()`, `fread()`, `fwrite()`, `fclose()`. Operates on abstract stream handles (`FILE*`).],

  [*Buffering Mechanism*],
  [Unbuffered in user space. Every invocation immediately traps into the kernel via `syscall`.],
  [Buffered in user memory (fully buffered for files, line buffered for TTY, unbuffered for stderr).],

  [*Context Switch Overhead*],
  [High per-byte cost if called with small byte counts due to mode switch (user <-> kernel).],
  [Low per-operation cost: aggregates multiple small user writes into single large `write()` syscalls.],

  [*Atomicity & Control*],
  [Immediate control over descriptor flags (`O_DIRECT`, `O_SYNC`, `O_CLOEXEC`, `O_NONBLOCK`).],
  [Controlled by runtime library state; flushing requires explicit `fflush()` or stream closure.],

  [*Portability*],
  [POSIX / Unix standard; requires adaptation layer on Windows (`_open`, `_write`).],
  [Universal ANSI C standard (portable across POSIX, Windows, embedded RTOS).],
)

#v(0.3cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.3cm)

// -------------------------------------------------------------
// Conclusion
// -------------------------------------------------------------
= Conclusion

Laboratory Work 9 provided hands-on experience inspecting and instrumenting the system call interface between Linux applications and the kernel:

1. *System Call Interception:* Verified that standard Linux commands (`ls`) rely on fundamental system calls (`openat`, `getdents64`, `statx`, `write`) to discover and display filesystem state.
2. *Direct System Call Usage:* Developed `syscalls.c` to perform file creation, writing, reading, and closure purely through `open`, `write`, `read`, and `close`.
3. *Descriptor Table Semantics:* Empirically verified why initial descriptors are numbered 3: standard streams (`stdin` = 0, `stdout` = 1, `stderr` = 2) are pre-allocated at startup, and POSIX mandates allocating the lowest free integer index.
4. *Kernel Profiling with strace:* Demonstrated through `strace -c` that application startup is dominated by dynamic linker ELF mappings, while user code I/O maps directly to predictable system calls.
