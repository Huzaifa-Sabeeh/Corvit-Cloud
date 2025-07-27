<title>Huawei Cloud Storage Services Lab Report</title>


<h1>Huawei Cloud Storage Services Lab Report</h1>
<p><strong>Prepared by:</strong> Huzaifa Sabeeh</p>

<h2>Introduction</h2>
<p>This document details the hands-on lab exercises I completed to gain practical experience with Huawei Cloud's core storage services. The lab covered three main services: Elastic Volume Service (EVS), Object Storage Service (OBS), and Scalable File Service (SFS). The objective was to understand their distinct functionalities, from block storage for servers to object storage for unstructured data and shared file systems for collaborative access.</p>

<h2>Part 1: Elastic Volume Service (EVS) Practice</h2>
<p>This section covers EVS, the persistent block storage service for ECS (Elastic Cloud Server). The goal was to learn how to purchase, attach, initialize, and manage EVS disks on both Windows and Linux servers, and to utilize the snapshot feature.</p>

<h3>1.1 Attaching an EVS Disk to a Windows ECS</h3>
<p>The primary goal here was to test the portability of an EVS data disk between two separate servers.</p>

<h4>Environment Setup:</h4>
<ul>
<li>Created a Virtual Private Cloud (VPC) in the AP-Singapore region.</li>
<li>Provisioned two Windows Server 2012 R2 ECS instances: <code>ecs-vivi</code> and <code>ecs-test</code>.</li>
</ul>

<h4>Purchasing an EVS Disk:</h4>
<ul>
<li>Navigated to the Elastic Volume Service page and purchased a new 20 GB General Purpose SSD data disk, named <code>volume-vivi</code>.</li>
</ul>

<h4>Attaching and Initializing on ecs-vivi:</h4>
<ul>
        <li>Attached the <code>volume-vivi</code> disk to the <code>ecs-vivi</code> server.</li>
        <li>Logged into <code>ecs-vivi</code> and opened Disk Management.</li>
        <li>Brought the disk online, initialized it using the MBR partition style, and formatted it as a New Simple Volume (D:) with the NTFS file system.</li>
        <li>Created a verification file: <code>test.txt</code> on the new D: drive.</li>
    </ul>

<h4>Verification of Portability:</h4>
    <ul>
        <li>On <code>ecs-vivi</code>, took the D: drive offline within Disk Management.</li>
        <li>From the Huawei Cloud console, detached the <code>volume-vivi</code> disk from <code>ecs-vivi</code>.</li>
        <li>Attached the same <code>volume-vivi</code> disk to the second server, <code>ecs-test</code>.</li>
        <li>Logged into <code>ecs-test</code>, opened Disk Management, and brought the disk online.</li>
    </ul>

<h4><strong>Success Verification:</strong></h4>
    <p>Opened the D: drive on <code>ecs-test</code> and confirmed that the <code>test.txt</code> file was present and intact. This successfully demonstrated that EVS disks are portable and data persists when moved between servers.</p>

<h3>1.2 Attaching an EVS Disk to a Linux ECS and Using Snapshots</h3>
    <p>This exercise extended the lab to a Linux environment and introduced EVS snapshots for data backup and recovery.</p>

<h4>Environment Setup:</h4>
    <ul>
        <li>Created a Linux ECS (CentOS 7.6).</li>
        <li>Purchased and attached a 10 GB EVS disk named <code>volume-linuxadd</code>.</li>
    </ul>

<h4>Initializing the Disk on Linux:</h4>
    <ul>
        <li>Logged into the Linux ECS and verified the new disk was attached as <code>/dev/vdb</code> using <code>fdisk -l</code>.</li>
        <li>Partitioned the disk using <code>fdisk /dev/vdb</code>. I created a new primary partition (n), made it partition 1, accepted the defaults, and wrote the changes (w).</li>
        <li>Formatted the new partition (<code>/dev/vdb1</code>) with the ext4 file system:
<pre><code>mkfs -t ext4 /dev/vdb1</code></pre></li>
        <li>Created a mount point and mounted the partition:
<pre><code>mkdir /mnt/sdc
mount /dev/vdb1 /mnt/sdc</code></pre></li>
    </ul>

<h4>Using EVS Snapshots for Data Backup and Restore:</h4>
    <ul>
        <li>Created a test file on the mounted EVS disk:
<pre><code>cd /mnt/sdc
mkdir snapshot
echo "snapshot test" > snapshot/test.file</code></pre></li>
        <li>From the EVS console, I created a snapshot of the <code>volume-linuxadd</code> disk and named it <code>volume-linuxdata</code>.</li>
        <li>I then used this snapshot to create a new disk, which I named <code>volume-snapshot</code>.</li>
        <li>This new disk was attached to my Linux ECS, appearing as <code>/dev/vdc</code>.</li>
        <li>I created a new mount point and mounted the restored disk's partition:
<pre><code>mkdir /mnt/mdc
mount /dev/vdc1 /mnt/mdc</code></pre></li>
    </ul>

<h4><strong>Success Verification:</strong></h4>
    <p>I checked the contents of the restored disk. The command <code>cat /mnt/mdc/snapshot/test.file</code> returned "snapshot test", confirming the snapshot successfully captured the data, which was then restored to a new disk.</p>

<h2>Part 2: Object Storage Service (OBS) Practice</h2>
    <p>This exercise focused on managing unstructured data using OBS. My objectives were to create a bucket and perform basic object operations like uploading, downloading, and deleting.</p>

<h3>Creating a Bucket:</h3>
    <ul>
        <li>Navigated to the OBS console in the AP-Singapore region.</li>
        <li>Clicked "Create Bucket" and configured it with the name <code>test-vivi-huzaifa</code>.</li>
        <li>Settings: Standard storage class and Private bucket policy.</li>
    </ul>

<h3>Object Operations:</h3>
    <ul>
        <li><strong>Upload:</strong> Entered the bucket, clicked "Upload Object," and uploaded a local file (<code>background.jpg</code>).</li>
        <li><strong>Download:</strong> After the upload, I selected the object and successfully downloaded it back to my local machine.</li>
        <li><strong>Delete:</strong> Finally, I selected the object again and deleted it from the bucket.</li>
    </ul>

<h3><strong>Success Verification:</strong></h3>
    <p>This exercise demonstrated the simple and intuitive lifecycle of creating buckets and managing objects (upload, download, delete) in OBS.</p>

<h2>Part 3: Scalable File Service (SFS) Practice</h2>
    <p>This lab explored SFS, a fully-managed, high-performance shared file storage service. The goal was to mount the same SFS file system on both a Linux and a Windows server to verify shared access.</p>

<h3>Environment Setup:</h3>
    <ul>
        <li>Used one Linux ECS and one Windows ECS, both in the same VPC.</li>
        <li>Created and bound Elastic IPs (EIPs) to each ECS.</li>
        <li>In the SFS console, created a new SFS Turbo file system named <code>sfs-mp</code> using the NFS protocol.</li>
    </ul>

<h3>Mounting SFS on the Linux ECS:</h3>
    <ul>
        <li>Logged into the Linux ECS and installed the NFS client: <code>sudo yum -y install nfs-utils</code>.</li>
        <li>Created a local mount point: <code>mkdir /localfolder</code>.</li>
        <li>Mounted the file system using its mount address from the SFS console:
<pre><code>mount -t nfs -o vers=3,timeo=600,nolock <sfs-mount-address> /localfolder</code></pre></li>
        <li>Created a test file in the shared directory: <code>echo "Hello HuaweiCloud SFS" > /localfolder/new</code>.</li>
    </ul>

<h3>Mounting SFS on the Windows ECS:</h3>
    <ul>
        <li>Logged into the Windows ECS and used Server Manager to install the Client for NFS feature.</li>
        <li>After a system restart, I opened Command Prompt.</li>
        <li>Mounted the same SFS file system to the X: drive:
<pre><code>mount -o nolock <sfs-mount-address> X:</code></pre></li>
    </ul>

<h3><strong>Success Verification:</strong></h3>
    <p>On the Windows ECS, I navigated to the new X: drive and found the file named <code>new</code> that was created from the Linux server. I opened the file and confirmed its content was "Hello HuaweiCloud SFS." This successfully verified that SFS provides a shared file system accessible by both Linux and Windows servers simultaneously.</p>

<h2>Overall Conclusion</h2>
    <p>Through these hands-on exercises, I have gained a solid practical understanding of Huawei Cloud's storage solutions. I successfully demonstrated:</p>
    <ul>
        <li>The portability and data persistence of EVS disks.</li>
        <li>The data protection capabilities of EVS snapshots.</li>
        <li>The ease of use of OBS for managing unstructured object data.</li>
        <li>The power of SFS for creating cross-platform shared file systems.</li>
    </ul>
    <p>This experience is invaluable for designing and implementing robust and scalable storage architectures on Huawei Cloud.</p>

