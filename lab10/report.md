# Laboratory Work 10 Report: Add Your Own System Call: trace (xv6)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Patricia Reițman  
**Date:** Autumn Semester 2026  

---

## Part 1. The Number and the User Side

### Edits Summary
1. `kernel/syscall.h`: Defined `#define SYS_trace 23`
2. `user/user.h`: Declared user-space prototype `int trace(int);`
3. `user/usys.pl`: Registered stub generation `entry("trace");` producing assembly:
   ```riscv
   .global trace
   trace:
    li a7, SYS_trace
    ecall
    ret
   ```
4. `user/trace.c`: Implemented tracing launcher utility:
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
5. `Makefile`: Added `$U/_trace\` to `UPROGS`.

### Check 1: The Number Reaches the Kernel

```bash
$ trace 32 grep hello README
3 trace: unknown sys call 23
trace: failed
```
Verification: The user program executed `ecall` with register `a7 = 23`. The kernel intercepted the trap in `kernel/syscall.c`, recognized `num = 23` had no table entry, output the unknown system call diagnostic, and returned `-1` to register `a0`, triggering `trace: failed`.

---

## Part 2. The Kernel Side

### Edits Summary
1. `kernel/proc.h`: Extended `struct proc` with `int trace_mask;` to preserve process mask state across executions.
2. `kernel/sysproc.c`: Implemented system call handler:
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
3. `kernel/syscall.c`: Declared `extern uint64 sys_trace(void);` and registered `[SYS_trace] = sys_trace` in table `syscalls[]`.
4. `kernel/syscall.c`: Added string table `syscallnames[]` and trace interception inside `syscall()`:
   ```c
   p->trapframe->a0 = syscalls[num]();
   if ((p->trace_mask >> num) & 1)
     printk("%d: syscall %s -> %ld\n",
            p->pid, syscallnames[num], p->trapframe->a0);
   ```
5. `kernel/proc.c`: Propagated trace mask across address space clones in `fork()`:
   ```c
   safestrcpy(np->name, p->name, sizeof(p->name));
   np->trace_mask = p->trace_mask;
   ```

### Check 2: trace Works

```bash
$ trace 32 grep hello README
3: syscall read -> 1023
3: syscall read -> 965
3: syscall read -> 453
3: syscall read -> 0
```
Verification: `1023 + 965 + 453 = 2441` bytes read, exactly matching the byte size of `README`, followed by return code 0 indicating EOF.

---

## Part 3. Play with the Mask

### 3.1 All Calls Enabled (Mask 2147483647 = 0x7FFFFFFF)

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

### 3.2 Only fork (Mask 2 = 1 << 1)

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

### 3.3 Only write (Mask 65536 = 1 << 16)

```bash
$ trace 65536 echo hi
hi3: syscall write -> 2

3: syscall write -> 1
```

### 3.4 Open and Close Only (Mask 2129920 = (1 << 15) | (1 << 21))

```bash
$ trace 2129920 grep hello README
3: syscall open -> 3
3: syscall close -> 0
```

---

## Observe Questions & Answers

### 1. In `trace 32 grep hello README` why do you see only read, and not open or close?
The mask argument `32` is $2^5$, which in binary representation is `00000000000000000000000000100000` (only bit 5 is 1). In xv6, system call numbers are defined in `kernel/syscall.h`:
- `SYS_read` is 5 (`1 << 5 = 32`).
- `SYS_open` is 15 (`1 << 15 = 32768`).
- `SYS_close` is 21 (`1 << 21 = 2097152`).
The kernel inspects whether a system call should be traced using the bitwise expression `(p->trace_mask >> num) & 1`. For `num = 5`, `(32 >> 5) & 1 == 1`, so the line is printed. For `num = 15` or `num = 21`, shifting mask 32 right by 15 or 21 positions produces 0, so the condition evaluates to false and the kernel silently executes the calls without logging.

### 2. In `forkforkfork`, three different pids print lines. Which line of code from Part 2 makes that possible?
The assignment added in `kernel/proc.c` inside `fork()`:
```c
np->trace_mask = p->trace_mask;
```
When a process forks, `np` is the newly created child process structure. Copying `p->trace_mask` directly ensures that child processes inherit their parent's exact active tracing configuration. As `forkforkfork` creates children, grandchildren, and further descendants across multiple distinct PIDs (e.g. 3, 4, 5, 6, 7), every newly spawned process inherits the non-zero mask and logs its own subsequent `fork()` invocations.

### 3. In `trace 65536 echo hi` the trace line is printed between "hi" and the new line. Why? (How many times does echo call write?)
`echo` invokes the `write()` system call **twice**:
1. First call: `write(1, "hi", 2)` to output the argument string `"hi"`. The bytes `"hi"` are transmitted to the console UART. Right as this system call completes inside `syscall()`, the kernel executes `printk("%d: syscall write -> %ld\n", ...)`. Because the console has already output `"hi"` without a trailing newline, the kernel diagnostic `3: syscall write -> 2\n` is printed immediately adjacent to `"hi"`, on the very same line: `"hi3: syscall write -> 2"`.
2. Second call: `write(1, "\n", 1)` to emit the trailing newline. After this second call completes, the kernel prints the second trace line `3: syscall write -> 1\n`.

### 4. Which mask traces both open (15) and close (21), and nothing else?
To trace exclusively system calls 15 and 21, the mask must have bit 15 and bit 21 set to 1, and all other 30 bits set to 0:
$$\text{Mask} = (1 \ll 15) \mid (1 \ll 21) = 2^{15} + 2^{21} = 32768 + 2097152 = \mathbf{2129920}$$
In hexadecimal, this corresponds to `0x208000`. Running `trace 2129920 grep hello README` prints:
```
3: syscall open -> 3
3: syscall close -> 0
```
and nothing else.
