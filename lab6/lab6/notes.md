# Laboratory Work 6 Notes: Inside the xv6 File System
**Course:** Operating Systems  
**Institution:** Universitatea Tehnică a Moldovei (FCIM / FAF)  
**Author:** Poiata Calin (gr. FAF-243)  
**Instructor:** Reițman Patricia  
**Date:** Autumn Semester 2026  

---

## Part 1. Read What xv6 Shows You

### Terminal Commands & Output

```bash
$ ls
.              1 1 1024
..             1 1 1024
README         2 2 2441
cat            2 3 35864
echo           2 4 34760
sleep          2 5 34440
forktest       2 6 17704
grep           2 7 43288
init           2 8 35112
kill           2 9 34664
ln             2 10 34456
ls             2 11 41944
mkdir          2 12 34712
rm             2 13 34696
sh             2 14 57072
stressfs       2 15 35536
usertests      2 16 201520
grind          2 17 50336
wc             2 18 36832
zombie         2 19 34008
logstress      2 20 36680
forphan        2 21 35472
dorphan        2 22 34936
sync           2 23 34112
args           2 24 34424
mystat         2 25 35616
find           2 26 42048
console        3 27 0

$ mkdir a
$ ls a
.              1 28 32
..             1 1 1024
```

### Observe Questions & Explanations

1. **What do types 1, 2 and 3 mean (`kernel/stat.h`)?**
   - Inspecting `kernel/stat.h`:
     ```c
     #define T_DIR     1   // Directory
     #define T_FILE    2   // File
     #define T_DEVICE  3   // Device
     ```
   - **Type 1 (`T_DIR`):** A directory whose data blocks contain an array of fixed-size 16-byte `struct dirent` records.
   - **Type 2 (`T_FILE`):** A regular file consisting of an unformatted stream of user bytes indexed by direct and indirect block pointers.
   - **Type 3 (`T_DEVICE`):** A special character or block device (e.g. console) mapped to major and minor device driver routines rather than persistent disk blocks.

2. **Which inode number does the root directory have, and why are `.` and `..` the same there?**
   - The root directory has inode number **1** (`. 1 1 1024` and `.. 1 1 1024`).
   - Root is the top of the directory hierarchy with no parent directory above it. In Unix convention, the parent pointer `..` of the root directory loops back to refer to the root directory itself, making both `.` and `..` resolve to inode 1.

3. **An empty directory `a` has size 32. A directory entry has a fixed size. How big is one entry, and which two entries does `a` contain?**
   - One directory entry (`struct dirent` in `kernel/fs.h`) consists of:
     - `ushort inum` (2 bytes)
     - `char name[DIRSIZ]` with `DIRSIZ = 14` (14 bytes)
     - Total entry size = $2 + 14 = \mathbf{16 \text{ bytes}}$.
   - An empty directory has a size of **32 bytes** because it contains exactly two entries ($2 \times 16 = 32$ bytes):
     1. `.` (current directory, pointing to inode 28).
     2. `..` (parent directory, pointing to root inode 1).

---

## Part 2. Write `mystat`

### User Implementation (`user/mystat.c`)

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char *
typename(int t)
{
  if(t == T_DIR)
    return "directory";
  if(t == T_FILE)
    return "file";
  if(t == T_DEVICE)
    return "device";
  return "?";
}

int
main(int argc, char *argv[])
{
  struct stat st;
  if(argc < 2){
    fprintf(2, "usage: mystat <path>...\n");
    exit(1);
  }
  for(int i = 1; i < argc; i++){
    if(stat(argv[i], &st) < 0){
      fprintf(2, "mystat: cannot stat %s\n", argv[i]);
      continue;
    }
    printf("%s: %s, inode %d, links %d, size %d bytes\n",
           argv[i], typename(st.type), st.ino, st.nlink, (int)st.size);
  }
  exit(0);
}
```

### Watching Hard Links at Work

```bash
$ mystat README . console
README: file, inode 2, links 1, size 2441 bytes
.: directory, inode 1, links 2, size 1024 bytes
console: device, inode 27, links 1, size 0 bytes

$ ln README r2
$ mystat README r2
README: file, inode 2, links 2, size 2441 bytes
r2: file, inode 2, links 2, size 2441 bytes

$ rm README
$ mystat r2
r2: file, inode 2, links 1, size 2441 bytes

$ cat r2 | wc
48 336 2441
```

### Observe Questions & Explanations

1. **Outputs after `ln` and after `rm`. What changed and what did not?**
   - **What changed:** When `ln README r2` was executed, the link count (`links`) of inode 2 increased from 1 to 2. Both `README` and `r2` refer to the identical inode 2. After `rm README` executed, the link count of inode 2 decremented from 2 back to 1.
   - **What did not change:** The inode number (`2`), file type (`file`), file size (`2441 bytes`), and contents (`48 336 2441`) remained completely unchanged.

2. **Find the line in `kernel/sysfile.c` (`sys_unlink`) that decrements the link count. When are the data blocks freed?**
   - Line **244** in `kernel/sysfile.c`:
     ```c
     ip->nlink--;
     iupdate(ip);
     ```
   - **When data blocks are freed:** Data blocks are not freed by `sys_unlink`. Data blocks are only freed inside `iput(ip)` in `kernel/fs.c` via `itrunc(ip)` when two conditions hold true:
     1. `ip->nlink == 0` (no directory entries point to this inode).
     2. `ip->ref == 1` (no active file descriptors hold a reference to this inode).

3. **xv6 has no symbolic links and no permissions. Look at `struct dinode` in `kernel/fs.h`: which fields does an xv6 inode have?**
   - In `kernel/fs.h`:
     ```c
     struct dinode {
       short type;              // File type
       short major;             // Major device number (T_DEVICE only)
       short minor;             // Minor device number (T_DEVICE only)
       short nlink;             // Number of links to inode in file system
       uint size;               // Size of file (bytes)
       uint addrs[NDIRECT + 1]; // Data block addresses
     };
     ```
   - **Fields present:** `type`, `major`, `minor`, `nlink`, `size`, and `addrs[13]`.
   - **Fields absent compared to Linux:** No owner UID/GID, no permission mode bits, no access/modification/change timestamps, and no symlink target buffer.

---

## Part 3. Measure the Limits

### Terminal Commands & Output

```bash
$ grep -n "define BSIZE\|define NDIRECT\|define NINDIRECT\|define DIRSIZ" kernel/fs.h
5:#define BSIZE   1024 // block size
26:#define NDIRECT   12
27:#define NINDIRECT (BSIZE / sizeof(uint))
54:#define DIRSIZ 14

$ make fs.img 2>&1 | grep nmeta
nmeta 47 (boot, super, log blocks 31, inode blocks 13, bitmap blocks 1) blocks 1953 total 2000

$ mkdir averyveryverylongname
$ ls
.              1 1 1024
..             1 1 1024
averyveryveryl 1 29 32
cat            2 3 35864
...
```

### Observe Questions & Explanations

1. **What does `ls` show for `averyveryverylongname`, and which constant explains it?**
   - `ls` displays: **`averyveryveryl`** (truncated to exactly 14 characters).
   - **Constant:** `#define DIRSIZ 14` in `kernel/fs.h`. xv6 directory entries allocate a fixed 14-byte array (`char name[DIRSIZ]`). Characters exceeding the 14th index are dropped during directory link insertion (`dirlink()`).

2. **Compute the largest file xv6 can hold: 12 direct blocks plus one indirect block that holds block numbers of 4 bytes each, blocks of BSIZE bytes. Show the calculation.**
   - `BSIZE = 1024 bytes`
   - Pointer size = `sizeof(uint) = 4 bytes`
   - Direct blocks: $12 \text{ blocks}$
   - Indirect blocks: $\frac{\text{BSIZE}}{\text{sizeof(uint)}} = \frac{1024}{4} = 256 \text{ blocks}$
   - Total addressable blocks: $12 + 256 = \mathbf{268 \text{ blocks}}$
   - Maximum byte size:
     $$268 \times 1024 \text{ bytes} = \mathbf{274,432 \text{ bytes}} \approx 268 \text{ KB}$$

3. **From the `nmeta` line: how many blocks does the whole disk have, and how many are for the log, the inodes, and the data?**
   - `nmeta 47 (boot, super, log blocks 31, inode blocks 13, bitmap blocks 1) blocks 1953 total 2000`
   - **Total disk blocks:** **2000 blocks** (`FSSIZE = 2000`).
   - **Metadata blocks (`nmeta`):** **47 blocks**:
     - Boot block: **1 block** (block 0)
     - Superblock: **1 block** (block 1)
     - Journal log blocks: **31 blocks** (blocks 2 to 32)
     - Inode blocks: **13 blocks** (blocks 33 to 45, holding $13 \times 16 = 208$ inodes)
     - Free bitmap blocks: **1 block** (block 46)
   - **Data blocks:** **1953 blocks** (blocks 47 to 1999).
   - Verification: $1 + 1 + 31 + 13 + 1 + 1953 = 2000 \text{ blocks}$.

---

## Part 4. Write `find`

### User Implementation (`user/find.c`)

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void
find(char *path, char *target, int show_inode)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  if(st.type != T_DIR){
    close(fd);
    return;
  }

  if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
    fprintf(2, "find: path too long\n");
    close(fd);
    return;
  }

  strcpy(buf, path);
  p = buf + strlen(buf);
  *p++ = '/';

  while(read(fd, &de, sizeof(de)) == sizeof(de)){
    if(de.inum == 0)
      continue;

    char name[DIRSIZ + 1];
    memmove(name, de.name, DIRSIZ);
    name[DIRSIZ] = 0;

    // Skip . and .. to prevent infinite recursion
    if(strcmp(name, ".") == 0 || strcmp(name, "..") == 0)
      continue;

    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;

    // Trim trailing padding spaces
    int len = strlen(p);
    while(len > 0 && p[len - 1] == ' ') {
      p[len - 1] = '\0';
      len--;
    }

    if(stat(buf, &st) < 0){
      fprintf(2, "find: cannot stat %s\n", buf);
      continue;
    }

    if(strcmp(name, target) == 0){
      if(show_inode)
        printf("%s %d\n", buf, st.ino);
      else
        printf("%s\n", buf);
    }

    if(st.type == T_DIR){
      find(buf, target, show_inode);
    }
  }

  close(fd);
}

int
main(int argc, char *argv[])
{
  int show_inode = 0;

  if(argc < 3){
    fprintf(2, "usage: find <path> <name> [-n]\n");
    exit(1);
  }

  if(argc >= 4 && strcmp(argv[3], "-n") == 0)
    show_inode = 1;

  find(argv[1], argv[2], show_inode);
  exit(0);
}
```

### Execution Output on Fresh Disk

```bash
$ mkdir a
$ mkdir a/b
$ echo x > a/b/r2
$ echo y > a/r2
$ ln cat r2
$ find . r2
./a/b/r2
./a/r2
./r2

$ find a b
a/b
```

---

## Stretch Goal: Inode Display via `-n`

```bash
$ find . r2 -n
./a/b/r2 30
./a/r2 31
./r2 3
```

### Observe Explanation
- In the `ls` output, `cat` has inode number **3** (`cat 2 3 35864`).
- `./r2` has inode number **3**, identical to `cat`. This proves that `./r2` is a hard link directly sharing inode 3 with the executable `cat`, rather than a duplicated copy of data blocks.
- In contrast, `./a/b/r2` (inode 30) and `./a/r2` (inode 31) are distinct regular files created independently with their own allocated inodes and data blocks.
