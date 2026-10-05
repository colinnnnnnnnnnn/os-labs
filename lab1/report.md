Part 1

The file I created is owned by the user and the group with the same name, in my case calin.
After chmod 600, the first 10 characters indicate that only the owner of the file can read or write to the file, witht the superuser being an exception.
In the root directory, the /etc directory holds the system-wide configuration, for example fstab holding the mounted filesystems.
The /usr directory holds the installed software and other read-only data that isn't essential when booting the system.

Interesting output:
echo "hello operating systems" > note.txt
No output but I like that I can echo stuff into files.


Part 2

The process with PID 1 is systemd, which is the system and service manager of my linux machine, and it is responsible of starting all the other servies and processes, while also managing them.
My machine has 361 running processes.
State: S (sleeping). The process is sleeping, not running on the CPU. In this state it waits for an event, in this case, the expiry of the 300 seconds timer.

Interesting output:
# ps aux | wc -l
# 361
Clever command of just getting the number of processes.


Part 3

I have a total of 14Gi, with 4.7 being free.
Swap is an "extention" of the RAM that will take some of the load when RAM is full. Currently 4GB are configured.
It takes roughly 4MB, quite surprising, given that it doesn't do anything but wait for an event to trigger it.

Interesting output:
# free -h
#                total        used        free      shared  buff/cache   available
# Mem:            14Gi       6.5Gi       4.7Gi       162Mi       4.2Gi       8.3Gi
# Swap:          4.0Gi          0B       4.0Gi

I like the -h because it literally stands for "human-readable", funny how free doesn't do that by default.


Part 4

The root filesystem is mounted on nvme0n1p2.
nvme0n1 is just my ssd, with different partitions like root or the home partition.
Everything is a file means that each piece of a system, including how it interacts with the hardware, is configured via a file.

Interesting output:
# df -h
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/nvme0n1p2   63G   43G   18G  71% /
# devtmpfs        7.4G     0  7.4G   0% /dev
# tmpfs           7.5G   40M  7.4G   1% /dev/shm
# efivarfs        154K   72K   78K  49% /sys/firmware/efi/efivars
# tmpfs           3.0G  2.1M  3.0G   1% /run
# none            1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
# none            1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
# tmpfs           7.5G   43M  7.4G   1% /tmp
# /dev/nvme0n1p1 1022M  279M  744M  28% /boot
# /dev/nvme0n1p3  405G  184G  200G  48% /home
# tmpfs           1.5G  196K  1.5G   1% /run/user/1000

Didn't know there was that much stuff that is mounted, only ever thought about the ssd.



1. CPU (processes) - can be managed with utilies like htop
2. RAM - the free command
3. Storage - df shows the mounted filesystems and the available storage
4. I/O devices - the lsusb command
