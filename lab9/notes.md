# Laboratory Work 9 Notes: Watching System Calls (Linux)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Patricia Reițman  
**Date:** Autumn Semester 2026  

---

## Part 1. See the Calls of a Real Command (`ls -l`)

### Terminal Commands & Output

Filtering for core I/O system calls:
```bash
$ strace -f -e trace=openat,read,write,close ls -l
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
write(1, "-rw-r--r-- 1 calin calin 346894 "..., 101) = 101
write(1, "-rw-r--r-- 1 calin calin 306916 "..., 99) = 99
close(1)                                = 0
close(2)                                = 0
+++ exited with 0 +++
```

### Observe Questions & Explanations

1. **Which system call does `ls` use to print to the screen? To which descriptor does it write?**
   - **System call:** `write()`
   - **Descriptor:** Descriptor `1` (which corresponds to `stdout` / standard output).
   - **Explanation:** In Unix, screen output is fundamentally treated as writing a sequential stream of bytes to standard output, which by default is file descriptor 1 mapped to the active pseudoterminal (`/dev/pts/X`). Even though higher-level code in coreutils may invoke `fputs()` or `printf()`, glibc flushes its user-space line/block buffers by issuing the `write(1, buf, count)` system call.

---

## Part 2. Direct Kernel Invocations (`syscalls.c`)

### Source Code: `syscalls.c`

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

### Compilation & Normal Execution

```bash
$ gcc -Wall -Wextra -O2 -o syscalls syscalls.c
$ ./syscalls
open returned descriptor 3
write sent 14 bytes
read got 14 bytes: hello, kernel
```

### Watching the Execution with `strace`

```bash
$ strace -e trace=openat,write,read,close ./syscalls
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300y\2\0\0\0\0\0"..., 1024) = 1024
close(3)                                = 0
openat(AT_FDCWD, "note.txt", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 3
write(1, "open returned descriptor 3\n", 27open returned descriptor 3
) = 27
write(3, "hello, kernel\n", 14)         = 14
write(1, "write sent 14 bytes\n", 20write sent 14 bytes
)   = 20
close(3)                                = 0
openat(AT_FDCWD, "note.txt", O_RDONLY)  = 3
read(3, "hello, kernel\n", 63)          = 14
write(1, "read got 14 bytes: hello, kernel"..., 33read got 14 bytes: hello, kernel
) = 33
close(3)                                = 0
+++ exited with 0 +++
```

### Observe Questions & Explanations

2. **The descriptor returned by the first openat is 3, not 0, 1 or 2. Why are those three already taken?**
   - **Reason:** File descriptors `0`, `1`, and `2` are pre-allocated by convention for every newly spawned Unix process during process instantiation:
     - `0` is assigned to **`stdin`** (Standard Input).
     - `1` is assigned to **`stdout`** (Standard Output).
     - `2` is assigned to **`stderr`** (Standard Error).
   - **Lowest-Free-Descriptor Rule:** POSIX guarantees that when a process opens a file, the kernel scans the per-process descriptor table starting from index 0 and assigns the lowest unused non-negative integer. Because 0, 1, and 2 are already allocated and open when `main()` begins, the first free index is `3`. Once descriptor 3 is closed with `close(3)`, its slot becomes free again, which is why the second `open("note.txt", O_RDONLY)` also returns descriptor `3`.

---

## Part 3. Aggregate Call Profiling (`strace -c`)

### System Call Histogram for `ls -l`

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
...
------ ----------- ----------- --------- --------- ----------------
100.00    0.001493           5       260        32 total
```

### System Call Histogram for `./syscalls`

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

### Profiling Insights
1. **Setup Overhead:** A compiled C binary dynamically linked against `glibc` issues approximately 35-40 system calls purely during initialization (`execve`, memory mappings via `mmap`/`mprotect`, thread-local storage setup via `arch_prctl`, `set_tid_address`, `rseq`, security random entropy via `getrandom`, and dynamic shared library location via `openat`).
2. **Direct vs Library I/O:** The 4 user-initiated file system calls in `syscalls.c` (`open`, `write`, `close`, `open`, `read`, `close`) map 1:1 to kernel system calls without buffering intermediaries. Conversely, `printf()` buffers output in user space and invokes `write(1, ...)` once per newline or flush.
