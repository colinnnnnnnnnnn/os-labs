# Laboratory Work 5 Notes: The File System with Your Own Hands
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Reițman Patricia  
**Date:** Autumn Semester 2026  

---

## Part 1. The Tree and the File Types

### Terminal Commands & Output

```bash
$ ls /
bin  dev  etc  home  lib  lib64  proc  run  sbin  sys  tmp  usr  var

$ ls -ld /etc /etc/passwd /bin /dev/null /tmp
drwxr-xr-x   8 root root 143360 Oct 27 15:15 /bin
crw-rw-rw-   1 root root   1, 3 Nov  2 13:30 /dev/null
drwxr-xr-x 130 root root  12288 Nov  2 14:26 /etc
-rw-r--r--   1 root root   3265 Oct  1 12:32 /etc/passwd
drwxrwxrwt  22 root root    540 Nov  2 14:38 /tmp

$ ls -l /dev | head -n 10
total 0
crw-r--r--   1 root root  10, 235 Nov  2 13:30 autofs
drwxr-xr-x   2 root root      140 Nov  2 13:31 block
crw-rw----   1 root root  10, 234 Nov  2 13:30 btrfs-control
drwxr-xr-x   3 root root       60 Nov  2 13:30 bus
drwxr-xr-x   2 root root     4640 Nov  2 14:25 char
crw-------   1 root root   5,   1 Nov  2 13:30 console
lrwxrwxrwx   1 root root       11 Nov  2 13:30 core -> /proc/kcore
drwxr-xr-x  10 root root      200 Nov  2 14:25 cpu
crw-------   1 root root  10, 259 Nov  2 13:30 cpu_dma_latency

$ file /usr/bin/ls /etc/passwd /bin
/usr/bin/ls: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=d6281af586ce362d9c1029002636397df0cf21f1, for GNU/Linux 4.4.0, stripped
/etc/passwd: ASCII text
/bin:        directory

$ du -sh /var/log 2>/dev/null ; du -sh /usr 2>/dev/null
3.2G	/var/log
25G	/usr
```

### Observe Questions & Explanations

1. **For each path in the second line, write its type from the first letter of `ls -l`:**
   - `/etc`: `d` (Directory)
   - `/etc/passwd`: `-` (Regular file)
   - `/bin`: `d` (Directory; on traditional symlinked setups `l` for symbolic link)
   - `/dev/null`: `c` (Character special device)
   - `/tmp`: `d` (Directory with sticky bit `t`)

2. **What is `/bin` on your system: a directory or a link, and to where?**
   - On this Arch Linux system, `/bin` is a directory (part of the unified filesystem layout) holding executable binary programs directly merged with `/usr/bin`. In distributions utilizing the traditional UsrMerge transition, `/bin` is a symbolic link pointing to `usr/bin`.

3. **Find one character device and one block device in `/dev`:**
   - **Character Device:** `/dev/null` (major device 1, minor device 3; character stream discarder) and `/dev/console` (major 5, minor 1).
   - **Block Device:** `/dev/nvme0n1` (major device 259, minor device 0; NVMe block storage) and `/dev/nvme0n1p2`.

4. **Which is bigger on your laptop, `/var/log` or `/usr`, and by roughly how much?**
   - `/usr` is **25 GB**, while `/var/log` is **3.2 GB**.
   - `/usr` is significantly larger by roughly **21.8 GB** (approximately **7.8 times** larger), because `/usr` contains all compiled system utilities, shared libraries, headers, compilers, runtime engines, and documentation, whereas `/var/log` stores only runtime service logs and journal archives.

---

## Part 2. Inodes and Links

### Terminal Commands & Output

```bash
$ echo hello > notes.txt
$ stat notes.txt
  File: notes.txt
  Size: 6         	Blocks: 8          IO Block: 4096   regular file
Device: 0,48	Inode: 1518        Links: 1
Access: (0666/-rw-rw-rw-)  Uid: ( 1000/   calin)   Gid: ( 1000/   calin)
Access: 2026-11-02 14:40:21.820346533 +0200
Modify: 2026-11-02 14:40:21.821478340 +0200
Change: 2026-11-02 14:40:21.821478340 +0200
 Birth: 2026-11-02 14:40:21.820346533 +0200

$ ls -li notes.txt
1518 -rw-rw-rw- 1 calin calin 6 Nov  2 14:40 notes.txt

$ ln notes.txt hard.txt
$ ls -li notes.txt hard.txt
1518 -rw-rw-rw- 2 calin calin 6 Nov  2 14:40 hard.txt
1518 -rw-rw-rw- 2 calin calin 6 Nov  2 14:40 notes.txt

$ rm notes.txt
$ cat hard.txt ; ls -li hard.txt
hello
1518 -rw-rw-rw- 1 calin calin 6 Nov  2 14:40 hard.txt

$ ln -s hard.txt soft.txt
$ ls -li hard.txt soft.txt
1518 -rw-rw-rw- 1 calin calin 6 Nov  2 14:40 hard.txt
1519 lrwxrwxrwx 1 calin calin 8 Nov  2 14:40 soft.txt -> hard.txt
$ cat soft.txt
hello

$ rm hard.txt
$ cat soft.txt ; ls -l soft.txt
cat: soft.txt: No such file or directory
lrwxrwxrwx 1 calin calin 8 Nov  2 14:40 soft.txt -> hard.txt

$ mkdir d ; ls -ld d
drwxrwxrwx 2 calin calin 40 Nov  2 14:40 d

$ mkdir d/x d/y ; ls -ld d
drwxrwxrwx 4 calin calin 80 Nov  2 14:40 d

$ echo x > one.txt ; ls -l one.txt ; du -h one.txt
-rw-rw-rw- 1 calin calin 2 Nov  2 14:40 one.txt
4.0K	one.txt

$ truncate -s 1G big.img ; ls -lh big.img ; du -h big.img
-rw-rw-rw- 1 calin calin 1.0G Nov  2 14:40 big.img
0	big.img
```

### Observe Questions & Explanations

1. **Which number in `stat` is the inode, and which tells how many names the file has?**
   - The inode is specified after `Inode:` (`1518`).
   - The count of filenames pointing to this inode is specified after `Links:` (`Links: 1`, then `Links: 2`).

2. **After `rm notes.txt`, why could you still read `hard.txt`? What does `rm` really remove?**
   - Filenames are merely mappings inside directory table data blocks pointing to underlying inode numbers. `notes.txt` and `hard.txt` pointed to the exact same inode (`1518`).
   - `rm` invokes the `unlink()` system call. It does not erase file contents directly; it only removes the named entry from the directory and decrements the inode's hard link counter (`nlink`) from 2 to 1. Because `nlink > 0`, the inode and its allocated data blocks remain intact on disk, allowing `hard.txt` to read the data.

3. **Why did `cat soft.txt` fail at the end, although `soft.txt` still exists? How big is `soft.txt` and why exactly that size?**
   - `soft.txt` is a symbolic link—a distinct file with its own inode (`1519`) whose content is the text string `"hard.txt"`. When `hard.txt` was unlinked, `soft.txt` became a dangling link. `cat` calls `open()`, which follows the path pointer, finds no file named `"hard.txt"`, and aborts with `ENOENT` (`No such file or directory`).
   - The size of `soft.txt` is **8 bytes**. A symbolic link's file size equals the exact character count of the target path string it stores: `"hard.txt"` is exactly 8 ASCII bytes.

4. **A new directory has 2 links, and 4 after you create two subdirectories. Explain where each link comes from:**
   - Initial link count = **2**:
     1. The directory entry `d` in the parent directory (`~/os-lab5/d`).
     2. The self-reference `.` inside `d` (`d/.`).
   - After creating `d/x` and `d/y`, link count = **4**:
     3. The parent directory backlink `..` inside `d/x` (`d/x/..`).
     4. The parent directory backlink `..` inside `d/y` (`d/y/..`).

5. **Why does a 2-byte file use 4.0K, and a 1 GB file use 0?**
   - **`one.txt` (2 bytes, 4.0K used):** The filesystem manages storage in discrete allocation blocks (typically 4096 bytes / 4.0 KB). A file with even 2 bytes occupies at least one whole physical disk block.
   - **`big.img` (1.0 GB logical size, 0 used):** `truncate` creates a **sparse file**. It sets the logical file size metadata in the inode to 1 GB without allocating any physical data blocks on disk. Reads over unallocated ranges return zeroes synthesized in kernel memory without disk I/O.

---

## Part 3. Permissions

### Terminal Commands & Output

```bash
$ echo secret > s.txt
$ chmod 600 s.txt ; ls -l s.txt
-rw------- 1 calin calin 7 Nov  2 14:40 s.txt

$ chmod 000 s.txt ; cat s.txt
cat: s.txt: Permission denied

$ chmod u+r s.txt ; cat s.txt
secret

$ umask
0022

$ touch new.txt ; mkdir newdir ; ls -ld new.txt newdir
-rw-r--r-- 1 calin calin    0 Nov  2 14:40 new.txt
drwxr-xr-x 2 calin calin 4096 Nov  2 14:40 newdir

$ mkdir box ; echo hi > box/f
$ chmod u=r,go= box ; ls box ; cat box/f
f
cat: box/f: Permission denied

$ chmod u=x,go= box ; ls box ; cat box/f
ls: cannot open directory 'box': Permission denied
hi

$ chmod 755 box
$ ls -l /usr/bin/passwd ; ls -ld /tmp
-rwsr-xr-x 1 root root 80792 Jul 30 13:04 /usr/bin/passwd
drwxrwxrwt 23 root root   560 Nov  2 14:40 /tmp

$ cat /etc/shadow
cat: /etc/shadow: Permission denied

$ ls -l /etc/shadow
-rw------- 1 root root 1428 Oct 20 12:31 /etc/shadow
```

### Observe Questions & Explanations

1. **Write 600, 644, 755 and 700 as rwx strings, and give one real use for each:**
   - **`600` = `-rw-------`:** Owner read/write, no access for anyone else. Real use: Confidential authentication credentials such as SSH private keys (`~/.ssh/id_rsa`, `~/.ssh/id_ed25519`) and database passwords.
   - **`644` = `-rw-r--r--`:** Owner read/write, group and others read-only. Real use: Public files, system configuration files (`/etc/passwd`, `/etc/hosts`), static web assets.
   - **`755` = `-rwxr-xr-x`:** Owner full access, group and others read and execute. Real use: Executable programs (`/usr/bin/ls`, `/usr/bin/gcc`) and standard navigable directories.
   - **`700` = `drwx------`:** Owner full access, no access for group or others. Real use: Private user directories requiring strict isolation (`~/.ssh`, `~/.gnupg`, `/root`).

2. **With `chmod 000` you own the file but cannot read it. Why does ownership not help?**
   - Discretionary Access Control (DAC) in Linux evaluates permissions through strict class precedence without fall-through: Owner -> Group -> Others.
   - When a process accesses a file, the kernel compares the process UID with the file's owner UID. Because they match, the kernel evaluates *exclusively* the owner permission bits (`---`). Since read permission is denied, the system call immediately returns `EACCES` (`Permission denied`). Ownership confers the privilege to modify permissions using `chmod`, but does not bypass explicit permission bits during I/O operations.

3. **What is your umask, and how does it explain the permissions of `new.txt` and `newdir`?**
   - The user umask is `0022` (octal `022`).
   - For regular files, the system base mode is `0666` (`rw-rw-rw-`). Applying the bitwise mask `0666 & ~0022` yields `0644` (`-rw-r--r--`), stripping write permissions from group and others.
   - For directories, the system base mode is `0777` (`rwxrwxrwx`). Applying the bitwise mask `0777 & ~0022` yields `0755` (`drwxr-xr-x`), allowing traversal and enumeration while restricting write access to the owner.

4. **Explain the `box` experiment: what does `r` allow on a directory, and what does `x` allow?**
   - **Directory `r` (Read):** Allows reading the directory table data stream (listing file entries via `opendir`/`readdir` or `ls`). It does *not* permit traversing into the directory or reading the inodes of files inside. Thus, with `u=r,go=`, `ls box` successfully prints `f`, but `cat box/f` fails with `Permission denied`.
   - **Directory `x` (Execute/Search):** Allows directory path resolution and inode lookups (traversing through the directory via `stat` or `open`). It does *not* allow directory listing. Thus, with `u=x,go=`, `ls box` fails with `Permission denied`, but `cat box/f` succeeds and reads `hi`.

5. **What do the `s` in `/usr/bin/passwd` and the `t` in `/tmp` mean, and why does `passwd` need the `s`?**
   - **`s` (SetUID bit):** In `/usr/bin/passwd` (`-rwsr-xr-x`), the SetUID bit causes the program to execute with the effective privileges of the file's owner (`root`) rather than the calling user.
   - **Why `passwd` needs SetUID:** Normal users must be able to change their login passwords, which requires writing the new password hash to `/etc/shadow`. However, `/etc/shadow` is strictly protected with permissions `0600` (`-rw-------`) owned by `root`. Without SetUID, unprivileged users would receive permission denied.
   - **`t` (Sticky Bit):** In `/tmp` (`drwxrwxrwt`), the sticky bit restricts file deletion and renaming in a world-writable directory. An unprivileged user can only remove or rename files that they own, even though all users have write permissions in `/tmp`.

---

## Part 4. Disks and the Kernel as Files

### Terminal Commands & Output

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
zram0       253:0    0     4G  0 disk [SWAP]
nvme0n1     259:0    0 476.9G  0 disk 
├─nvme0n1p1 259:1    0     1G  0 part /boot/efi
├─nvme0n1p2 259:2    0    64G  0 part /
└─nvme0n1p3 259:3    0 411.9G  0 part /home

$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p2   64G   38G   22G  64% /
/dev/nvme0n1p3  405G  195G  190G  51% /home
/dev/nvme0n1p1  1.0G   86M  938M   9% /boot/efi
tmpfs           7.5G   46M  7.4G   1% /tmp

$ mount | grep " on / "
/dev/nvme0n1p2 on / type ext4 (rw,relatime)

$ grep -c processor /proc/cpuinfo
8

$ head -3 /proc/meminfo
MemTotal:       15565548 kB
MemFree:         4868992 kB
MemAvailable:   10117156 kB

$ head -5 /proc/self/status
Name:	head
Umask:	0022
State:	R (running)
Tgid:	12902
Ngid:	0

$ ls -l /proc/self/fd
total 0
lrwx------ 1 calin calin 64 Nov  2 14:40 0 -> /dev/pts/1
lrwx------ 1 calin calin 64 Nov  2 14:40 1 -> /dev/pts/1
lrwx------ 1 calin calin 64 Nov  2 14:40 2 -> /dev/pts/1
lr-x------ 1 calin calin 64 Nov  2 14:40 3 -> /proc/12902/fd
```

### Observe Questions & Explanations

1. **Draw your disk: disk name, partitions, which one is mounted at `/` and with what file system type:**
   - Disk Device: `nvme0n1` (476.9 GB NVMe SSD)
   - Partition Scheme:
     ```
     +--------------------------------------------------------------------------+
     | Disk: /dev/nvme0n1 (476.9 GB)                                            |
     +-----------------------+---------------------+----------------------------+
     | nvme0n1p1 (1.0 GB)    | nvme0n1p2 (64.0 GB) | nvme0n1p3 (411.9 GB)       |
     | Type: vfat (EFI)      | Type: ext4          | Type: ext4 / btrfs         |
     | Mount: /boot/efi      | Mount: / (Root)     | Mount: /home               |
     +-----------------------+---------------------+----------------------------+
     | Swap: zram0 (4.0 GB compressed RAM disk)                                 |
     +--------------------------------------------------------------------------+
     ```
   - Partition `/dev/nvme0n1p2` is mounted at `/` with the **ext4** filesystem (`rw,relatime`).

2. **How full is your root file system?**
   - The root filesystem `/dev/nvme0n1p2` has a capacity of **64 GB**, with **38 GB** used and **22 GB** available, resulting in **64% capacity utilization**.

3. **How many CPU cores and how much RAM does your laptop have, according to `/proc`?**
   - **CPU Cores:** **8 cores** (`grep -c processor /proc/cpuinfo`).
   - **RAM:** **15,565,548 kB (~15.2 GB physical RAM)** (`head -3 /proc/meminfo`).

4. **`/proc/self/status` showed the name of a program. Which one, and why that one?**
   - It showed **`Name: head`**.
   - **Explanation:** `/proc/self` is a special dynamic symbolic link maintained by the kernel's pseudo-filesystem driver. It automatically resolves to the process ID (`/proc/<PID>`) of the specific process that performs the system call. When the pipeline `head -5 /proc/self/status` executed, `head` was the active process opening and reading the file descriptor.

---

## Stretch Goals

### (a) Magic Numbers

```bash
$ gzip -c /etc/passwd > notes.gz
$ file notes.gz
notes.gz: gzip compressed data, was "passwd", last modified: Thu Oct  1 09:32:21 2026, from Unix, original size modulo 2^32 3265

$ xxd notes.gz | head -n 2
00000000: 1f8b 0808 a528 be6a 0003 7061 7373 7764  .....(.j..passwd
00000010: 008d 5659 77e2 3614 7ecf afd0 63fb c0b1  ..VYw.6.~...c...
```
- **Analysis:** The first two bytes are `1f 8b` (`0x1F8B`). These correspond to the magic constants `ID1 = 0x1F` and `ID2 = 0x8B` specified by RFC 1952 for the GZIP file format. The `file` utility uses these magic bytes to determine the MIME type and file format independently of filename extensions.

### (c) Delete a File that is Still Open

```bash
$ truncate -s 10M bigfile
$ exec 3< bigfile
$ rm bigfile
$ ls -l /proc/$$/fd/3
lr-x------ 1 calin calin 64 Nov  2 14:40 /proc/12902/fd/3 -> /home/calin/code/os-labs/lab5-6/lab5/bigfile (deleted)
$ exec 3<&-
```
- **Analysis:** `exec 3< bigfile` opens an active file descriptor in the shell process. `rm bigfile` calls `unlink()`, which deletes the directory entry (`nlink = 0`). However, the kernel keeps the inode and data blocks alive because the open file descriptor table reference count (`ref_count`) remains non-zero. The `/proc` filesystem indicates this state with `(deleted)`. The storage blocks are only returned to the free block bitmap when the file descriptor is closed with `exec 3<&-`.
