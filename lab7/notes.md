# Laboratory Work 7 Notes: Three Small Programs (Linux)
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Reițman Patricia  
**Date:** Autumn Semester 2026  

---

## Part 1. fork + exec + wait

### Source Code: `run.c`

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

/* the three steps of the shell for the command:
   ls -l
*/
int main(void)
{
    printf("parent: my PID is %d\n", getpid());
    fflush(stdout);

    pid_t pid = fork();                          /* step 1: copy myself */
    if (pid < 0) { perror("fork"); return 1; }

    if (pid == 0) {                              /* only the child runs this */
        printf("child:  my PID is %d, my parent is %d\n", getpid(), getppid());
        fflush(stdout);
        execlp("ls", "ls", "-l", (char *)NULL);  /* step 2: become ls */
        perror("exec");                          /* runs only if exec failed */
        exit(127);
    }

    int status;
    waitpid(pid, &status, 0);                    /* step 3: wait for the child */
    printf("parent: child %d ended with status %d\n", pid, WEXITSTATUS(status));
    return 0;
}
```

### Terminal Output

```bash
$ gcc -Wall -Wextra -o run run.c && ./run
parent: my PID is 49
child:  my PID is 50, my parent is 49
total 112
-rwxrwxrwx 1 calin calin 16376 Nov  2 15:10 pipeline
-rwxrwxrwx 1 calin calin 16376 Nov  2 15:10 pipeline3
-rw-rw-rw- 1 calin calin  1319 Nov  2 15:10 pipeline3.c
-rw-rw-rw- 1 calin calin  1012 Nov  2 15:10 pipeline.c
-rwxrwxrwx 1 calin calin 16416 Nov  2 15:10 redirect
-rw-rw-rw- 1 calin calin   751 Nov  2 15:10 redirect.c
-rwxrwxrwx 1 calin calin 16472 Nov  2 15:10 run
-rw-rw-rw- 1 calin calin   910 Nov  2 15:10 run.c
-rwxrwxrwx 1 calin calin 16528 Nov  2 15:10 zombie
-rw-rw-rw- 1 calin calin   725 Nov  2 15:10 zombie.c
parent: child 50 ended with status 0

$ ./run_date
parent: my PID is 29
child:  my PID is 30, my parent is 29
Mon Nov  2 03:10:14 PM EET 2026
parent: child 30 ended with status 0

$ ./run_bad
parent: my PID is 22
child:  my PID is 37, my parent is 22
exec: No such file or directory
parent: child 37 ended with status 127
```

### Observe Questions & Explanations

1. **The line `perror("exec")` is in the child, right after `execlp`. Why is it printed only with `nosuchprog`?**
   - On success, `execlp` overwrites the child process image (code, data, heap, and stack) with the newly loaded executable. The original program text following `execlp` is discarded and never executes. If and only if `execlp` fails (as with `nosuchprog`, which does not exist in PATH), `execlp` returns `-1`, allowing control to fall through to `perror("exec")` and `exit(127)`.

2. **Which number does the child print as "my parent", and whose PID is it?**
   - The child prints `my parent is 49`. This is the Process ID (PID) of the parent process that invoked `fork()`, retrieved by the child via `getppid()`.

3. **What status does the parent see with `ls`, and what status with `nosuchprog`?**
   - With `ls`, the parent sees status **0** (`EXIT_SUCCESS`), indicating clean completion.
   - With `nosuchprog`, the parent sees status **127**, which was explicitly passed to `exit(127)` in the fallback handler when `exec` failed.

---

## Part 2. A Zombie, on Purpose

### Source Code: `zombie.c`

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
    printf("parent: my PID is %d\n", getpid());
    fflush(stdout);

    pid_t pid = fork();
    if (pid < 0) { perror("fork"); return 1; }

    if (pid == 0) {
        printf("child:  my PID is %d, my parent is %d\n", getpid(), getppid());
        fflush(stdout);
        execlp("ls", "ls", "-l", (char *)NULL);
        perror("exec");
        exit(127);
    }

    int status;
    sleep(20);                                   /* the new line */
    waitpid(pid, &status, 0);                    /* step 3: wait for the child */
    printf("parent: child %d ended with status %d\n", pid, WEXITSTATUS(status));
    return 0;
}
```

### Terminal Output

```bash
$ gcc -Wall -Wextra -o zombie zombie.c
$ ./zombie > /dev/null &
$ sleep 2; ps -o pid,ppid,stat,cmd
    PID    PPID STAT CMD
     23       1 Ss+  bash -c cd /tmp/os-lab7 ./zombie > /dev/null & sleep 2 ps -
     24      23 S+   ./zombie
     26      24 Z+   [ls] <defunct>
     27      23 R+   ps -o pid,ppid,stat,cmd

$ sleep 20; ps -o pid,ppid,stat,cmd
    PID    PPID STAT CMD
     23       1 Rs+  ps -o pid,ppid,stat,cmd
```

### Observe Questions & Explanations

1. **Which letter does `ls` have in the STAT column, and what does it mean?**
   - `ls` has the letter **`Z`** (or `Z+`).
   - `Z` denotes a **Zombie** process. The child process has finished executing its instructions and terminated via `exit()`, relinquishing its virtual memory and open files, but its entry remains in the kernel process table (`task_struct`) so the parent can inspect its termination status.

2. **After 20 seconds, is the `[ls] <defunct>` line still there? Which line of `zombie.c` made it disappear?**
   - No, after 20 seconds the `[ls] <defunct>` entry has disappeared.
   - The line `waitpid(pid, &status, 0);` made it disappear. When the parent wakes from `sleep(20)` and executes `waitpid()`, the kernel yields the child's exit status to the parent and frees the child's process table slot.

---

## Part 3. Redirection: `ls -l > out.txt`

### Source Code: `redirect.c`

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
    pid_t pid = fork();
    if (pid < 0) { perror("fork"); return 1; }

    if (pid == 0) {
        close(1);                                /* descriptor 1 is now free */
        int fd = open("out.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd < 0) { perror("open"); exit(1); }
        fprintf(stderr, "open gave descriptor %d\n", fd);
        execlp("ls", "ls", "-l", (char *)NULL);  /* ls writes to 1, as always */
        perror("exec");
        exit(127);
    }

    waitpid(pid, NULL, 0);
    printf("done: the listing is in out.txt\n");
    return 0;
}
```

### Terminal Output

```bash
$ gcc -Wall -Wextra -o redirect redirect.c && ./redirect
open gave descriptor 1
done: the listing is in out.txt

$ head -n 5 out.txt
total 112
-rw-r--r-- 1 calin calin     0 Nov  2 15:10 out.txt
-rwxrwxrwx 1 calin calin 16376 Nov  2 15:10 pipeline
-rwxrwxrwx 1 calin calin 16376 Nov  2 15:10 pipeline3
-rw-rw-rw- 1 calin calin  1319 Nov  2 15:10 pipeline3.c
```

### Observe Questions & Explanations

1. **Which number did `open` give, and why exactly that one?**
   - `open` gave descriptor **1**.
   - POSIX guarantees that `open()` always assigns the lowest-numbered unallocated file descriptor in the process descriptor table. Because `close(1)` was executed right before `open()`, slot 1 was the smallest available index (slots 0 and 2 were occupied by stdin and stderr).

2. **`ls` was not changed at all. Why does its listing not appear on the screen?**
   - By convention, user programs write their primary output to file descriptor 1. Because the child process bound file descriptor 1 to `out.txt` before executing `ls`, all output written by `ls` via `write(1, ...)` was directed into the kernel file description for `out.txt`.

3. **To redirect the errors instead (like `2> err.txt`), which descriptor would you close before `open`?**
   - You would close file descriptor **2** (`close(2);`), which corresponds to `stderr`. The subsequent `open()` call would allocate descriptor 2.

---

## Part 4. A Pipe: `ls /etc | wc -l`

### Source Code: `pipeline.c`

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
    int p[2];
    if (pipe(p) < 0) { perror("pipe"); return 1; }

    if (fork() == 0) {                           /* ls: its 1 becomes p[1] */
        close(1);
        dup(p[1]);                               /* smallest free number: 1 */
        close(p[0]);
        close(p[1]);
        execlp("ls", "ls", "/etc", (char *)NULL);
        perror("exec ls");
        exit(127);
    }

    if (fork() == 0) {                           /* wc: its 0 becomes p[0] */
        close(0);
        dup(p[0]);                               /* smallest free number: 0 */
        close(p[0]);
        close(p[1]);
        execlp("wc", "wc", "-l", (char *)NULL);
        perror("exec wc");
        exit(127);
    }

    close(p[0]);                                 /* the parent uses neither end */
    close(p[1]);
    wait(NULL);
    wait(NULL);
    return 0;
}
```

### Terminal Output

```bash
$ gcc -Wall -Wextra -o pipeline pipeline.c && ./pipeline
230

$ ls /etc | wc -l
230
```

### Observe Questions & Explanations

1. **Did `./pipeline` and `ls /etc | wc -l` give the same number?**
   - Yes, both produced the exact same count: **230**.

2. **After the change (commenting out `close(p[1])` in parent), which of the two children never ends, `ls` or `wc`?**
   - **`wc`** never ends (hangs indefinitely).

3. **Why, in one sentence: what is `wc` waiting for?**
   - `wc` is waiting for an End-Of-File (EOF) indication on its standard input pipe, which the kernel only delivers when all open file descriptors referencing the write end (`p[1]`) are closed, but the parent process still retains an open reference to `p[1]`.

---

## Stretch Goal: `pipeline3.c` (`ls /usr/bin | grep x | wc -l`)

### Source Code: `pipeline3.c`

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
    int p1[2], p2[2];
    if (pipe(p1) < 0) { perror("pipe 1"); return 1; }
    if (pipe(p2) < 0) { perror("pipe 2"); return 1; }

    /* Stage 1: ls /usr/bin -> p1[1] */
    if (fork() == 0) {
        close(1);
        dup(p1[1]);
        close(p1[0]); close(p1[1]);
        close(p2[0]); close(p2[1]);
        execlp("ls", "ls", "/usr/bin", (char *)NULL);
        perror("exec ls");
        exit(127);
    }

    /* Stage 2: grep x (reads p1[0] -> writes p2[1]) */
    if (fork() == 0) {
        close(0);
        dup(p1[0]);
        close(1);
        dup(p2[1]);
        close(p1[0]); close(p1[1]);
        close(p2[0]); close(p2[1]);
        execlp("grep", "grep", "x", (char *)NULL);
        perror("exec grep");
        exit(127);
    }

    /* Stage 3: wc -l (reads p2[0]) */
    if (fork() == 0) {
        close(0);
        dup(p2[0]);
        close(p1[0]); close(p1[1]);
        close(p2[0]); close(p2[1]);
        execlp("wc", "wc", "-l", (char *)NULL);
        perror("exec wc");
        exit(127);
    }

    close(p1[0]); close(p1[1]);
    close(p2[0]); close(p2[1]);

    wait(NULL);
    wait(NULL);
    wait(NULL);
    return 0;
}
```

### Terminal Output

```bash
$ gcc -Wall -Wextra -o pipeline3 pipeline3.c && ./pipeline3
675

$ ls /usr/bin | grep x | wc -l
675
```
