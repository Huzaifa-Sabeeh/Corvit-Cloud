<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise WordPress Hosting on Huawei Cloud</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 960px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px 40px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }
        header {
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        h1 {
            color: #d73a49; /* Huawei Red */
            margin: 0;
        }
        h2 {
            color: #0366d6;
            border-bottom: 1px solid #eaecef;
            padding-bottom: 5px;
            margin-top: 40px;
        }
        h3 {
            color: #24292e;
            margin-top: 30px;
        }
        p, li {
            font-size: 16px;
        }
        ul {
            list-style-type: square;
            padding-left: 20px;
        }
        code {
            background-color: #eef;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 15px;
        }
        pre {
            background-color: #24292e;
            color: #f6f8fa;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
        }
        pre code {
            background-color: transparent;
            padding: 0;
            font-size: 14px;
        }
        strong {
            color: #24292e;
        }
        .report-meta {
            font-size: 0.9em;
            color: #586069;
        }
        .architecture-diagram {
            border: 1px dashed #ccc;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            background-color: #fafafa;
        }
    </style>
</head>
<body>

    <div class="container">
        <header>
            <h1>Enterprise WordPress Hosting on Huawei Cloud</h1>
            <p class="report-meta">A Comprehensive Implementation Guide</p>
            <p class="report-meta"><strong>Prepared by:</strong> Huzaifa Sabeeh</p>
            <p class="report-meta"><strong>Date:</strong> October 26, 2023</p>
        </header>

        <!-- Executive Summary Section -->
        <h2>1. Executive Summary</h2>
        <p>
            Hosting WordPress for an enterprise requires more than a single virtual machine. It demands an architecture that is <strong>secure, scalable, resilient, and high-performing</strong>. Huawei Cloud provides a comprehensive suite of services that can be orchestrated to build a robust hosting environment for business-critical WordPress sites.
        </p>
        <p>
            This report outlines a best-practice architecture and a step-by-step guide for deploying a fault-tolerant WordPress solution on Huawei Cloud. The proposed architecture leverages a managed database, load balancing, auto-scaling, and object storage to ensure high availability and optimal performance, while services like Web Application Firewall (WAF) provide an essential security layer. This approach moves beyond a single point of failure and creates a dynamic infrastructure that can handle fluctuating traffic loads effectively.
        </p>

        <!-- Architectural Overview Section -->
        <h2>2. Proposed Architecture for Enterprise WordPress</h2>
        <p>
            A simple, single-server setup is inadequate for enterprise needs. We recommend a decoupled, scalable architecture composed of the following Huawei Cloud services:
        </p>
        <ul>
            <li><strong>Virtual Private Cloud (VPC):</strong> Provides a logically isolated network for all resources, ensuring security and control.</li>
            <li><strong>Elastic Load Balancer (ELB):</strong> Distributes incoming traffic across multiple web servers to prevent overload and ensure high availability.</li>
            <li><strong>Auto Scaling (AS):</strong> Automatically adds or removes ECS instances (web servers) based on traffic demand, ensuring performance and optimizing costs.</li>
            <li><strong>Elastic Cloud Server (ECS):</strong> Instances running the WordPress application (PHP/Nginx). These are treated as stateless and disposable.</li>
            <li><strong>Relational Database Service (RDS) for MySQL:</strong> A fully managed, highly available, and automatically backed-up database service, offloading critical database management tasks.</li>
            <li><strong>Object Storage Service (OBS):</strong> Used to store and serve static assets like images, videos, CSS, and JS files, reducing the load on web servers and improving site speed.</li>
            <li><strong>Web Application Firewall (WAF):</strong> Placed in front of the ELB to protect the WordPress site from common web exploits like SQL injection and cross-site scripting (XSS).</li>
        </ul>

        <div class="architecture-diagram">
            <h3>Architectural Diagram</h3>
            <pre>
[ End Users ]
      |
[ Internet ]
      |
[ Web Application Firewall (WAF) ]
      |
[ Elastic Load Balancer (ELB) ]
      |
      |--- [ Auto Scaling Group ] ---|
      |            |                 |
[ ECS 1 ]      [ ECS 2 ] ...   [ ECS n ]
(WordPress)    (WordPress)     (WordPress)
      |--------------|----------------|
                     |
[ Relational Database Service (RDS) for MySQL ]
(Stores posts, users, settings)

[ Object Storage Service (OBS) ]
(Stores media uploads, static assets)
            </pre>
        </div>

        <!-- Implementation Guide Section -->
        <h2>3. Step-by-Step Implementation Guide</h2>
        
        <h3>Phase 1: Foundational Infrastructure Setup</h3>
        <ol>
            <li><strong>Create a VPC:</strong> In the Huawei Cloud console, navigate to VPC and create a new VPC (e.g., <code>vpc-wordpress</code>) with at least two subnets in different Availability Zones (AZs) for high availability.</li>
            <li>
                <strong>Configure Security Groups:</strong> Create a security group for each component:
                <ul>
                    <li><code>sg-elb-public</code>: Allows inbound traffic on ports 80 (HTTP) and 443 (HTTPS) from anywhere (0.0.0.0/0).</li>
                    <li><code>sg-web-servers</code>: Allows inbound traffic on ports 80 and 22 (SSH) from the ELB's security group and your office IP for management.</li>
                    <li><code>sg-rds-private</code>: Allows inbound traffic on port 3306 (MySQL) only from the <code>sg-web-servers</code> security group.</li>
                </ul>
            </li>
            <li>
                <strong>Launch RDS for MySQL Instance:</strong>
                <ul>
                    <li>Navigate to RDS and create a new MySQL instance.</li>
                    <li>Select the <code>vpc-wordpress</code> VPC and the <code>sg-rds-private</code> security group.</li>
                    <li>Choose a "HA" (High Availability) instance type, which creates a primary and standby instance in different AZs.</li>
                    <li>Set the administrator password and securely note the database endpoint, username, and password.</li>
                </ul>
            </li>
        </ol>

        <h3>Phase 2: Preparing the WordPress Server Image</h3>
        <p>Creating a "golden image" is crucial for auto-scaling. This ensures every new server launched is identical.</p>
        <ol>
            <li><strong>Launch a Temporary ECS:</strong> Create a single ECS instance in your VPC. Use a Linux distribution like CentOS or Ubuntu. Assign it the <code>sg-web-servers</code> security group.</li>
            <li>
                <strong>Install LEMP Stack:</strong> Connect via SSH and install Nginx, MySQL Client (not server), and PHP.
                <pre><code># Example for CentOS
sudo yum update -y
sudo yum install -y nginx php php-fpm php-mysqlnd php-json php-gd</code></pre>
            </li>
            <li>
                <strong>Configure WordPress:</strong>
                <ul>
                    <li>Download the latest version of WordPress and extract it to the Nginx web root (e.g., <code>/var/www/html</code>).</li>
                    <li>Create the <code>wp-config.php</code> file from <code>wp-config-sample.php</code>.</li>
                    <li>Edit <code>wp-config.php</code> and enter the database details from your RDS instance.
                        <pre><code>define( 'DB_NAME', 'your_rds_db_name' );
define( 'DB_USER', 'your_rds_username' );
define( 'DB_PASSWORD', 'your_rds_password' );
define( 'DB_HOST', 'your_rds_endpoint.mysql.ap-southeast-1.huaweicloud.com' );</code></pre>
                    </li>
                    <li>Configure Nginx to serve the WordPress site.</li>
                </ul>
            </li>
            <li><strong>Integrate with OBS:</strong> Install and configure a WordPress plugin (e.g., "Media Cloud" or "WP-Stateless") to automatically offload media library uploads to an OBS bucket. This is a critical step for a stateless architecture.</li>
            <li><strong>Create a Custom Image:</strong> Once the ECS is fully configured and tested, shut it down and create a custom image from it in the ECS console. Name it something descriptive, like <code>wordpress-nginx-golden-image-v1</code>. Terminate the temporary ECS after the image is created.</li>
        </ol>

        <h3>Phase 3: Deploying the Scalable Architecture</h3>
        <ol>
            <li>
                <strong>Create an Auto Scaling Configuration:</strong>
                <ul>
                    <li>Go to the Auto Scaling service.</li>
                    <li>Create a new AS Configuration, selecting the custom WordPress image you just created (<code>wordpress-nginx-golden-image-v1</code>).</li>
                    <li>Select an appropriate instance type and choose the <code>sg-web-servers</code> security group.</li>
                </ul>
            </li>
            <li>
                <strong>Create an Auto Scaling Group:</strong>
                <ul>
                    <li>Create a new AS Group, linking it to the AS Configuration.</li>
                    <li>Select the VPC and the subnets in different AZs.</li>
                    <li>Set the desired instance counts (e.g., Min: 2, Desired: 2, Max: 10).</li>
                    <li>Configure scaling policies (e.g., scale out if CPU utilization > 75% for 5 minutes).</li>
                </ul>
            </li>
            <li>
                <strong>Set up the Elastic Load Balancer (ELB):</strong>
                <ul>
                    <li>Create a new ELB. Choose "Shared" and select your VPC and subnets.</li>
                    <li>Create a listener for port 443 (HTTPS) and upload your SSL certificate. You can also create a listener on port 80 to redirect to 443.</li>
                    <li>Create a backend server group and, instead of adding servers manually, associate it with your Auto Scaling Group. The ELB will now automatically manage traffic to the instances in the AS Group.</li>
                </ul>
            </li>
        </ol>

        <h3>Phase 4: Final Configuration and Security</h3>
        <ol>
            <li><strong>Configure DNS:</strong> Go to your domain registrar or Huawei Cloud DNS and create a CNAME or A record pointing your domain (e.g., <code>www.your-enterprise.com</code>) to the public IP address of the ELB.</li>
            <li>
                <strong>Deploy Web Application Firewall (WAF):</strong>
                <ul>
                    <li>In the WAF console, add your domain name.</li>
                    <li>Set the origin server address to the ELB's public IP.</li>
                    <li>WAF will provide a CNAME. Update your domain's DNS record to point to this WAF CNAME. All traffic will now be filtered by WAF before reaching your ELB.</li>
                    <li>Enable the default protection rules for WordPress.</li>
                </ul>
            </li>
            <li><strong>Complete WordPress Installation:</strong> Access your domain via a browser. You should see the famous WordPress five-minute installation screen. Complete it to create your admin user.</li>
        </ol>

        <!-- Management and Best Practices Section -->
        <h2>4. Ongoing Management and Best Practices</h2>
        <ul>
            <li><strong>Monitoring:</strong> Use Huawei Cloud Eye to monitor the health of your ELB, ECS instances (CPU, Memory), and RDS. Set alarms for critical metrics.</li>
            <li><strong>Backups:</strong>
                <ul>
                    <li><strong>Database:</strong> RDS is configured for automated daily backups by default. Verify these settings.</li>
                    <li><strong>Files:</strong> Your media is safe in OBS, which can have versioning enabled for extra protection.</li>
                    <li><strong>Application Code:</strong> Your core application is defined by the custom image. For updates, create a new image and perform a rolling update of the AS Configuration.</li>
                </ul>
            </li>
            <li><strong>Updates:</strong> To update WordPress core, themes, or plugins, launch a new temporary ECS from your latest golden image, perform the updates, test thoroughly, and then create a new golden image. Update the AS Configuration to use the new image, which will gracefully replace old instances with new ones.</li>
        </ul>

        <!-- Conclusion Section -->
        <h2>5. Conclusion</h2>
        <p>
            By following this guide, an enterprise can deploy a WordPress application on Huawei Cloud that is not just a website but a robust, resilient, and secure digital platform. This architecture provides high availability through multi-AZ deployment, automatic scaling to handle traffic spikes, and layered security with WAF and isolated networking. This setup empowers enterprises to focus on creating content and value, confident that their underlying infrastructure is built for performance and reliability.
        </p>

    </div>

</body>
</html>
