<!DOCTYPE html>
<html>
<head>
<h1>Huawei Cloud Compute Service Lab Report</h1>
</head>
<body>
<h1>Huawei Cloud Compute Service Lab Report</h1>
<p><strong>Prepared by:</strong> Huzaifa Sabeeh</p>
<h2>1. Introduction and Objectives</h2>
<p>This report documents the procedures I, Huzaifa Sabeeh, followed and the knowledge I gained from the Huawei Cloud Compute Service Lab. The primary objective of this exercise was to develop hands-on proficiency in provisioning, managing, and imaging Elastic Cloud Servers (ECSs) on the Huawei Cloud platform.</p>
<p>The lab focused on several core competencies, including:</p>
<ul>
<li>Setting up a foundational network environment using Virtual Private Cloud (VPC).</li>
<li>Provisioning and accessing both Windows and Linux ECS instances.</li>
<li>Modifying the specifications of a running ECS to scale its resources.</li>
<li>Creating custom private images from pre-configured ECS instances.</li>
<li>Managing and sharing these private images for collaborative or streamlined deployment purposes.</li>
<li>Deploying new ECS instances from a private image to ensure consistency and rapid provisioning.</li>
</ul>
<h2>2. Lab Procedure and Findings</h2>
<p>The lab was executed in a structured manner, beginning with environment setup and progressing to advanced image management. All activities were performed within the AP-Singapore region.</p>
<h3>Environment Setup (VPC):</h3>
<p>The first step was to create an isolated network environment. I successfully created a VPC with the following specifications:</p>
<ul>
<li>Name: <code>vpc-WP</code></li>
<li>Region: AP-Singapore</li>
<li>IPv4 CIDR Block: <code>192.168.0.0/16</code></li>
<li>Default Subnet: A subnet named <code>subnet-WP</code> was created in Availability Zone 1 (AZ1) with the CIDR block <code>192.168.0.0/24</code>.</li>
</ul>
<p>This VPC served as the secure network foundation for all subsequent ECS instances.</p>
<h3>ECS Provisioning and Access:</h3>
<p>With the network in place, I provisioned two different types of servers:</p>
<h4>Windows ECS (ecs-windows):</h4>
<ul>
<li>Specifications: Pay-per-use, General computing, <code>s6.large.2</code> (2 vCPUs, 4 GB RAM).</li>
<li>Image: A public image of Windows Server 2012 R2 Standard (64-bit).</li>
<li>Configuration: Deployed into the <code>vpc-WP</code> without an EIP. I set a secure password (<code>Huawei@1234</code>) for login.</li>
<li>Access: I used the Remote Login feature from the Huawei Cloud console, which provides a VNC-like interface. I successfully logged into the Windows desktop environment by pasting the password via the console's "Input Commands" tool.</li>
</ul>
<h4>Linux ECS (ecs-linux):</h4>
<ul>
<li>Specifications: Pay-per-use, same hardware specs as the Windows ECS.</li>
<li>Image: A public image of CentOS 7.6 (64-bit).</li>
<li>Configuration: Deployed into <code>vpc-WP</code>.</li>
<li>Access: Similar to the Windows ECS, I used the Remote Login feature. I logged in at the command line prompt by entering the username <code>root</code> and the configured password. The successful display of the "Welcome to Huawei Cloud Service" banner confirmed a successful login.</li>
</ul>
<h3>Modifying ECS Specifications:</h3>
<p>To understand resource scaling, I modified the specifications of the <code>ecs-windows</code> instance.</p>
<ul>
<li>I first stopped the <code>ecs-windows</code> ECS from the console.</li>
<li>Once stopped, I used the "Modify Specifications" option.</li>
<li>I upgraded the server's memory from 4 GB to 8 GB.</li>
<li>After the modification was confirmed ("Resized" status), I started the ECS again.</li>
<li>Upon logging back in, I verified in the Windows System Properties that the "Installed memory (RAM)" now correctly reflected 8.00 GB. This demonstrated the ease of vertically scaling an ECS.</li>
</ul>
<h3>Creating Private Images (Windows):</h3>
<p>The next phase involved creating a reusable "golden image" from my configured Windows ECS. This is a critical step for ensuring consistency in future deployments.</p>
<h4>Pre-configuration Steps on ecs-windows:</h4>
<p>Before creating the image, I performed several essential configuration steps to ensure new instances created from it would function correctly in an automated environment:</p>
<ul>
<li>DHCP Configuration: Verified that the network interface card (NIC) was set to "Obtain an IP address automatically" and "Obtain DNS server address automatically."</li>
<li>Remote Desktop: Enabled "Allow remote connections to this computer" in the System Properties.</li>
<li>Windows Firewall: Added a rule to allow "Windows Remote Management" for both private and public networks.</li>
<li>Cloudbase-Init Verification: Confirmed that the Cloudbase-Init service was installed. This service is crucial for injecting custom configurations (like hostnames and passwords) into new Windows instances at boot time. The lab confirmed this is installed by default on public images.</li>
</ul>
<h4>Image Creation:</h4>
<p>After completing the pre-configuration, I navigated to the Image Management Service (IMS), selected the running <code>ecs-windows</code> instance, and created a new private image named <code>image-windows2012</code>.</p>
<h3>Creating Private Images (Linux):</h3>
<p>I repeated the imaging process for the Linux ECS, which involved different but conceptually similar pre-configuration steps.</p>
<h4>Pre-configuration Steps on ecs-linux:</h4>
<ul>
<li>DHCP Configuration: Ensured the line <code>PERSISTENT_DHCLIENT="yes"</code> was present in the <code>/etc/sysconfig/network-scripts/ifcfg-eth0</code> file.</li>
<li>Plugin Verification: I confirmed that <code>CloudResetPwdAgent</code> and <code>Cloud-Init</code> were installed by default, which are the Linux equivalents for handling customization and password injection on boot.</li>
<li>Network Rule Deletion: I performed the critical step of checking for and deleting files in the <code>/etc/udev/rules.d</code> directory. This prevents "NIC name drift," ensuring network interfaces are named consistently on new ECS instances created from this image.</li>
</ul>
<h4>Image Creation:</h4>
<p>I then used IMS to create a private image from the <code>ecs-linux</code> instance, naming it <code>image-centos7.6</code>.</p>
<h3>Managing and Sharing Private Images:</h3>
<p>With two private images created, I explored the management capabilities within IMS.</p>
<h4>Replication:</h4>
<p>I successfully replicated the <code>image-windows2012</code> within the same region, creating a copy named <code>copy_image-windows2012</code>. This is useful for backups or for creating different versions of an image.</p>
<h4>Sharing:</h4>
<p>I simulated sharing an image with another user. This required:</p>
<ul>
<li>Obtaining the Project ID of the target user's account in the AP-Singapore region.</li>
<li>From my lab account, using the "Share" functionality on my private image to grant access to that Project ID.</li>
<li>Logging in as the target user and navigating to the "Images Shared with Me" tab to Accept the shared image.</li>
</ul>
<p>This process demonstrated how images can be securely shared across different projects or teams, facilitating collaborative development and standardized deployments.</p>
<h3>Deploying from a Private Image:</h3>
<p>The final and most important step was to validate the entire process. I used the "Apply for Server" option directly from my <code>image-windows2012</code> private image to launch a new ECS instance. The new server (<code>ecs-windows02</code>) was successfully created and, upon login, I confirmed that all the pre-configured settings (Remote Desktop, Firewall rules, etc.) were present. This verified that the private image worked as expected.</p>
<h2>3. Key Learnings and Conclusion</h2>
<p>This Compute Service Lab provided invaluable practical experience. My key takeaways are:</p>
<ul>
<li><strong>The Importance of Images:</strong> Private images are the cornerstone of efficient and scalable cloud operations. They ensure that every deployed server is consistent, reducing configuration errors and deployment time.</li>
<li><strong>Automation-Readiness is Key:</strong> The pre-configuration steps (DHCP, Cloud-Init, firewall rules) are not just about making one server work; they are about making an image that is ready for automated, hands-off deployment, which is essential for features like Auto Scaling.</li>
<li><strong>Platform-Specific Configurations:</strong> I learned the critical differences in preparing Windows (Cloudbase-Init, RDP) versus Linux (Cloud-Init, network rules) for imaging.</li>
<li><strong>Management and Collaboration:</strong> IMS provides powerful tools not only for creating images but for managing their lifecycle through replication and secure sharing, which is vital for enterprise environments.</li>
</ul>
<p>In conclusion, I have successfully demonstrated my ability to provision, manage, and create standardized, reusable server templates on Huawei Cloud. This skill is fundamental for building reliable, scalable, and maintainable cloud infrastructure.</p>
</body>
</html>
