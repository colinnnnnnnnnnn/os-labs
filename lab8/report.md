# Laboratory Work 8 Notes: The Same Calls Inside Your Own OS (xv6)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Reițman Patricia  
**Date:** Autumn Semester 2026  

---

## Part 1. `run`, Inside xv6

### Source Code: `user/run.c`

```c
#include "kernel/types.h"
#include "user/user.h"

// the three steps of the shell, inside xv6:  echo hello from the child
int
main(int argc, char *argv[])
{
  printf("parent: my pid is %d\n", getpid());
  int pid = fork();                     // step 1: copy myself
  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }
  if(pid == 0){                         // only the child runs this
    printf("child: my pid is %d\n", getpid());
    char *args[] = { "echo", "hello", "from", "the", "child", 0 };
    exec("echo", args);                 // step 2: become echo
    printf("exec failed\n");            // runs only if exec failed
    exit(1);
  }
  int status;
  wait(&status);                        // step 3: wait for the child
  printf("parent: child %d ended with status %d\n", pid, status);
  exit(0);
}
```

### Execution Output (QEMU)

```bash
$ run
parent: my pid is 3
child: my pid is 4
hello from the child
parent: child 4 ended with status 0
```

When executing `ls` instead of `echo`:
```bash
$ run
parent: my pid is 3
child: my pid is 4
.              1 1 1024
..             1 1 1024
README         2 2 2441
cat            2 3 35864
echo           2 4 34760
...
parent: child 4 ended with status 0
```

When executing a non-existent binary (`nosuchprog`):
```bash
$ run
parent: my pid is 3
child: my pid is 4
exec failed
parent: child 4 ended with status 1
```

### Observe Questions & Explanations

1. **Write the three calls that `run.c` uses in xv6 and the three calls `run.c` used on Linux in Lab 7. What is the same?**
   - **Calls in xv6 (Lab 8):** `fork()`, `exec()`, `wait(&status)`
   - **Calls in Linux (Lab 7):** `fork()`, `execlp()` (wrapper over `execve`), `waitpid(pid, &status, 0)`
   - **What is the same:** The core architectural pattern and semantics are identical. Both systems decouple process instantiation from binary execution: `fork()` creates an identical child process, an `exec()` variant substitutes the address space with a new program image, and `wait()` suspends the parent to synchronize and reap the child's exit status.

2. **Who prints "hello from the child": the code of `run`, or `echo`?**
   - **`echo`** prints it.
   - When `exec("echo", args)` succeeds, the instructions of `run.c` are discarded and replaced by the executable image of `/echo`. The `main()` routine of `echo` executes, iterating through `argv` and outputting `"hello from the child"` to descriptor 1.

3. **Why is the status 1 here and 127 on Linux? (Look at the exit line after exec in both programs.)**
   - On Linux in Lab 7, when `execlp()` failed, the child explicitly invoked `exit(127);` following standard POSIX shell conventions for command lookup failure.
   - In xv6 in Lab 8, the fallback error handler in `user/run.c` explicitly called `exit(1);`. The parent simply reports the exact integer value passed to `exit()` by the child.

---

## Part 2. `pingpong`

### Source Code: `user/pingpong.c`

```c
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p2c[2], c2p[2];     // parent-to-child, child-to-parent
  char b = 'x';

  if(pipe(p2c) < 0 || pipe(c2p) < 0){
    fprintf(2, "pipe failed\n");
    exit(1);
  }

  int pid = fork();
  if(pid < 0){
    fprintf(2, "fork failed\n");
    exit(1);
  }

  if(pid == 0){
    close(p2c[1]); close(c2p[0]);       // the ends the child does not use
    if(read(p2c[0], &b, 1) != 1){
      fprintf(2, "child read failed\n");
      exit(1);
    }
    printf("%d: received ping\n", getpid());
    if(write(c2p[1], &b, 1) != 1){
      fprintf(2, "child write failed\n");
      exit(1);
    }
    close(p2c[0]);
    close(c2p[1]);
    exit(0);
  }

  close(p2c[0]); close(c2p[1]);         // the ends the parent does not use
  if(write(p2c[1], &b, 1) != 1){
    fprintf(2, "parent write failed\n");
    exit(1);
  }
  if(read(c2p[0], &b, 1) != 1){
    fprintf(2, "parent read failed\n");
    exit(1);
  }
  printf("%d: received pong\n", getpid());
  close(p2c[1]);
  close(c2p[0]);
  wait(0);
  exit(0);
}
```

### Execution Output (QEMU)

```bash
$ pingpong
6: received ping
5: received pong
```

### Observe Questions & Explanations

1. **Why do you need TWO pipes, and not one for both directions?**
   - Pipes in Unix are strictly unidirectional (half-duplex). A single pipe has one shared in-kernel circular FIFO buffer. If only one pipe were used for bidirectional communication, a severe race condition would occur: when the parent wrote the byte into the pipe, the parent's subsequent `read()` call could read back its own byte before the child had a chance to run, or the child could read its own reply. Two dedicated pipes (`p2c` for parent-to-child and `c2p` for child-to-parent) guarantee deterministic, collision-free data transfer.

2. **Nothing in your code says "wait until the child has replied". Which call makes the parent wait?**
   - The `read(c2p[0], &b, 1)` call makes the parent wait.
   - Reading from a pipe in Unix is a blocking operation. If the pipe buffer is empty, the kernel puts the calling process to sleep in `sys_read()`, waking it only when the child writes a byte into `c2p[1]`.

---

## Stretch Goal: `primes` (Concurrent Sieve of Eratosthenes)

### Source Code: `user/primes.c`

```c
#include "kernel/types.h"
#include "user/user.h"

#pragma GCC diagnostic ignored "-Winfinite-recursion"

void
sieve(int pleft[2])
{
  int p;
  close(pleft[1]);
  if(read(pleft[0], &p, sizeof(p)) != sizeof(p)){
    close(pleft[0]);
    exit(0);
  }

  printf("prime %d\n", p);

  int pright[2];
  if(pipe(pright) < 0){
    fprintf(2, "pipe failed\n");
    close(pleft[0]);
    exit(1);
  }

  int pid = fork();
  if(pid < 0){
    fprintf(2, "fork failed\n");
    close(pleft[0]);
    close(pright[0]);
    close(pright[1]);
    exit(1);
  }

  if(pid == 0){
    close(pleft[0]);
    sieve(pright);
  } else {
    close(pright[0]);
    int n;
    while(read(pleft[0], &n, sizeof(n)) == sizeof(n)){
      if(n % p != 0){
        write(pright[1], &n, sizeof(n));
      }
    }
    close(pleft[0]);
    close(pright[1]);
    wait(0);
    exit(0);
  }
}

int
main(int argc, char *argv[])
{
  int p[2];
  if(pipe(p) < 0){
    fprintf(2, "pipe failed\n");
    exit(1);
  }

  int pid = fork();
  if(pid < 0){
    fprintf(2, "fork failed\n");
    exit(1);
  }

  if(pid == 0){
    sieve(p);
  } else {
    close(p[0]);
    for(int i = 2; i <= 35; i++){
      write(p[1], &i, sizeof(i));
    }
    close(p[1]);
    wait(0);
    exit(0);
  }
  exit(0);
}
```

### Execution Output (QEMU)

```bash
$ primes
prime 2
prime 3
prime 5
prime 7
prime 11
prime 13
prime 17
prime 19
prime 23
prime 29
prime 31
```
