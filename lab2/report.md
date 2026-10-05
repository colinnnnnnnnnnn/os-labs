Part 2

Three programs that ship with xv6 are cat, echo and grep, among others.
For a pipe to work, we need processes (one on each side) and inter-process communication (the pipe itself).
xv6 is way tiny version of the Linux shell and it supports basic commands. I noticed it lack autocompletion.


Part 3
The calls are read, write, open, close and exit.
read - copy bytes from the open file fd into buf
write - copy bytes from buf into the open file
open - asks the kernel to look up the file and give the process a new file descriptor
close - asks the kernel to release that file descriptor
exit - terminate the process and return the status

It is in kernel/sysfile.c, line number 69

Code in kernel/ is in privileged mode and has full control of the hardware and manages stuff for everyone.
Code in user/ are oridnary unprivileged programs that require system calls to the kernel.
