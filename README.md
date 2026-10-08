# CloudForge — Production AWS Infrastructure Automation with Terraform

> Production-style AWS infrastructure automated using Terraform with modular architecture, remote state management, secure networking, IAM, Application Load Balancer, and private EC2 deployment.

---

## 📌 PROJECT OVERVIEW

CloudForge is a production-style AWS infrastructure automation project built using **Terraform**.

The project demonstrates how to provision and manage a complete AWS environment using **Infrastructure as Code (IaC)** instead of manually creating resources through the AWS Console.

The infrastructure includes:

- AWS VPC
- Public and private subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- EC2
- Application Load Balancer
- Target Group
- Security Groups
- IAM
- S3 Remote Terraform State
- Terraform Modules
- Terraform State Refactoring using `moved` blocks
- Nginx application deployment

The final application is accessible through an **Application Load Balancer**, while the backend EC2 instance remains inside a **private subnet**.

---

## 🎯 OBJECTIVES

The main objectives of CloudForge are:

- Automate AWS infrastructure using Terraform.
- Understand AWS networking and subnet architecture.
- Separate public and private infrastructure.
- Deploy an application on a private EC2 instance.
- Expose the application through an Application Load Balancer.
- Implement secure Security Group rules.
- Store Terraform state remotely in Amazon S3.
- Organize infrastructure using reusable Terraform modules.
- Safely refactor existing Terraform resources using `moved` blocks.
- Validate infrastructure using Terraform plan and application health checks.

---

## 🏗️ ARCHITECTURE

```text
                         INTERNET
                             |
                             v
                  +----------------------+
                  |   Application Load   |
                  |      Balancer        |
                  |      Port 80         |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |     Target Group     |
                  |       HTTP :80       |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |      Private EC2     |
                  |        Nginx         |
                  |       Port 80        |
                  +----------------------+

                  AWS VPC: 10.0.0.0/16
                  |
        +---------+---------+
        |                   |
        v                   v
  PUBLIC SUBNETS       PRIVATE SUBNETS
  10.0.1.0/24          10.0.11.0/24
  10.0.2.0/24          10.0.12.0/24
        |                   |
        v                   v
       ALB              EC2 + Nginx
        |
        v
 Internet Gateway

Private Subnets
       |
       v
 NAT Gateway
       |
       v
 Internet Gateway
       |
       v
 Internet
