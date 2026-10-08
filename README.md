# CloudForge — AWS Infrastructure Automation with Terraform

> A production-style AWS infrastructure project built using Terraform to automate networking, security, load balancing, and application deployment.

---

## 📌 About the Project

**CloudForge** is an Infrastructure as Code (IaC) project where AWS infrastructure is created and managed using **Terraform** instead of manually creating resources through the AWS Console.

The project creates a complete AWS environment containing:

- VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Application Load Balancer
- Target Group
- EC2 Instance
- Nginx
- IAM
- S3 Remote Terraform State

The main goal of this project is to understand how a real-world AWS application infrastructure can be designed, automated, secured, and maintained using Terraform.

---

# 🎯 Project Objectives

The main objectives of CloudForge are:

- Automate AWS infrastructure using Terraform.
- Understand AWS VPC networking.
- Separate public and private resources.
- Deploy the application server inside a private subnet.
- Expose the application using an Application Load Balancer.
- Control traffic using Security Groups.
- Store Terraform state remotely using Amazon S3.
- Organize Terraform code using reusable modules.
- Safely refactor Terraform infrastructure without recreating AWS resources.
- Validate the complete infrastructure and application.

---

# 🏗️ Architecture

```text
                         INTERNET
                             |
                             |
                             v
                  +----------------------+
                  |   Application Load   |
                  |      Balancer        |
                  |      Port 80         |
                  +----------+-----------+
                             |
                             |
                             v
                  +----------------------+
                  |     Target Group     |
                  |       HTTP :80       |
                  +----------+-----------+
                             |
                             |
                             v
                  +----------------------+
                  |      EC2 Instance    |
                  |    Private Subnet    |
                  |       Nginx :80      |
                  +----------------------+

                    AWS VPC
                  10.0.0.0/16
                       |
              +--------+--------+
              |                 |
              v                 v
        PUBLIC SUBNETS    PRIVATE SUBNETS
        10.0.1.0/24       10.0.11.0/24
        10.0.2.0/24       10.0.12.0/24
              |                 |
              v                 v
             ALB              EC2
              |
              v
        Internet Gateway

Private EC2
     |
     v
 NAT Gateway
     |
     v
Internet Gateway
     |
     v
 Internet
