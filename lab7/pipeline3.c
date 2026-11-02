#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

/* does the same as the shell command:
   ls /usr/bin | grep x | wc -l
*/
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
