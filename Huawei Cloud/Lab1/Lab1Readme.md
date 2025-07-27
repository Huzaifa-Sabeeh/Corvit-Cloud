<h1>Huawei Cloud Storage Services Lab Report</h1>
Prepared by: Huzaifa Sabeeh
Introduction
This document details the hands-on lab exercises I completed to gain practical experience with Huawei Cloud's core storage services. The lab covered three main services: Elastic Volume Service (EVS), Object Storage Service (OBS), and Scalable File Service (SFS). The objective was to understand their distinct functionalities, from block storage for servers to object storage for unstructured data and shared file systems for collaborative access.
Part 1: Elastic Volume Service (EVS) Practice
This section covers EVS, the persistent block storage service for ECS (Elastic Cloud Server). The goal was to learn how to purchase, attach, initialize, and manage EVS disks on both Windows and Linux servers, and to utilize the snapshot feature.
1.1 Attaching an EVS Disk to a Windows ECS
The primary goal here was to test the portability of an EVS data disk between two separate servers.
Environment Setup:
Created a Virtual Private Cloud (VPC) in the AP-Singapore region.
Provisioned two Windows Server 2012 R2 ECS instances: ecs-vivi and ecs-test.
Purchasing an EVS Disk:
Navigated to the Elastic Volume Service page and purchased a new 20 GB General Purpose SSD data disk, named volume-vivi.
Attaching and Initializing on ecs-vivi:
Attached the volume-vivi disk to the ecs-vivi server.
Logged into ecs-vivi and opened Disk Management.
Brought the disk online, initialized it using the MBR partition style, and formatted it as a New Simple Volume (D:) with the NTFS file system.
Created a verification file: test.txt on the new D: drive.
Verification of Portability:
On ecs-vivi, took the D: drive offline within Disk Management.
From the Huawei Cloud console, detached the volume-vivi disk from ecs-vivi.
Attached the same volume-vivi disk to the second server, ecs-test.
Logged into ecs-test, opened Disk Management, and brought the disk online.
Success Verification:
Opened the D: drive on ecs-test and confirmed that the test.txt file was present and intact. This successfully demonstrated that EVS disks are portable and data persists when moved between servers.
1.2 Attaching an EVS Disk to a Linux ECS and Using Snapshots
This exercise extended the lab to a Linux environment and introduced EVS snapshots for data backup and recovery.
Environment Setup:
Created a Linux ECS (CentOS 7.6).
Purchased and attached a 10 GB EVS disk named volume-linuxadd.
Initializing the Disk on Linux:
Logged into the Linux ECS and verified the new disk was attached as /dev/vdb using fdisk -l.
Partitioned the disk using fdisk /dev/vdb. I created a new primary partition (n), made it partition 1, accepted the defaults, and wrote the changes (w).
Formatted the new partition (/dev/vdb1) with the ext4 file system:
Generated bash
mkfs -t ext4 /dev/vdb1
Use code with caution.
Bash
Created a mount point and mounted the partition:
Generated bash
mkdir /mnt/sdc
mount /dev/vdb1 /mnt/sdc
Use code with caution.
Bash
Using EVS Snapshots for Data Backup and Restore:
Created a test file on the mounted EVS disk:
Generated bash
cd /mnt/sdc
mkdir snapshot
echo "snapshot test" > snapshot/test.file
Use code with caution.
Bash
From the EVS console, I created a snapshot of the volume-linuxadd disk and named it volume-linuxdata.
I then used this snapshot to create a new disk, which I named volume-snapshot.
This new disk was attached to my Linux ECS, appearing as /dev/vdc.
I created a new mount point and mounted the restored disk's partition:
Generated bash
mkdir /mnt/mdc
mount /dev/vdc1 /mnt/mdc
Use code with caution.
Bash
Success Verification:
I checked the contents of the restored disk. The command cat /mnt/mdc/snapshot/test.file returned "snapshot test", confirming the snapshot successfully captured the data, which was then restored to a new disk.
Part 2: Object Storage Service (OBS) Practice
This exercise focused on managing unstructured data using OBS. My objectives were to create a bucket and perform basic object operations like uploading, downloading, and deleting.
Creating a Bucket:
Navigated to the OBS console in the AP-Singapore region.
Clicked "Create Bucket" and configured it with the name test-vivi-huzaifa.
Settings: Standard storage class and Private bucket policy.
Object Operations:
Upload: Entered the bucket, clicked "Upload Object," and uploaded a local file (background.jpg).
Download: After the upload, I selected the object and successfully downloaded it back to my local machine.
Delete: Finally, I selected the object again and deleted it from the bucket.
Success Verification:
This exercise demonstrated the simple and intuitive lifecycle of creating buckets and managing objects (upload, download, delete) in OBS.
Part 3: Scalable File Service (SFS) Practice
This lab explored SFS, a fully-managed, high-performance shared file storage service. The goal was to mount the same SFS file system on both a Linux and a Windows server to verify shared access.
Environment Setup:
Used one Linux ECS and one Windows ECS, both in the same VPC.
Created and bound Elastic IPs (EIPs) to each ECS.
In the SFS console, created a new SFS Turbo file system named sfs-mp using the NFS protocol.
Mounting SFS on the Linux ECS:
Logged into the Linux ECS and installed the NFS client: sudo yum -y install nfs-utils.
Created a local mount point: mkdir /localfolder.
Mounted the file system using its mount address from the SFS console:
Generated bash
mount -t nfs -o vers=3,timeo=600,nolock <sfs-mount-address> /localfolder
Use code with caution.
Bash
Created a test file in the shared directory: echo "Hello HuaweiCloud SFS" > /localfolder/new.
Mounting SFS on the Windows ECS:
Logged into the Windows ECS and used Server Manager to install the Client for NFS feature.
After a system restart, I opened Command Prompt.
Mounted the same SFS file system to the X: drive:
Generated powershell
mount -o nolock <sfs-mount-address> X:
Use code with caution.
Powershell
Success Verification:
On the Windows ECS, I navigated to the new X: drive and found the file named new that was created from the Linux server. I opened the file and confirmed its content was "Hello HuaweiCloud SFS." This successfully verified that SFS provides a shared file system accessible by both Linux and Windows servers simultaneously.
Overall Conclusion
Through these hands-on exercises, I have gained a solid practical understanding of Huawei Cloud's storage solutions. I successfully demonstrated:
The portability and data persistence of EVS disks.
The data protection capabilities of EVS snapshots.
The ease of use of OBS for managing unstructured object data.
The power of SFS for creating cross-platform shared file systems.
This experience is invaluable for designing and implementing robust and scalable storage architectures on Huawei Cloud.
