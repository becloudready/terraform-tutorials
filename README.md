# Terraform Tutorials

A hands-on learning repository for Terraform infrastructure-as-code, cloud provisioning, and automation with AWS, Azure, GCP, and Ansible.

## Overview

This repository contains step-by-step Terraform labs and examples demonstrating:
- Terraform basics and syntax
- Terraform providers and resources
- AWS EC2, security groups, and AMI management
- Azure VM, networking, and resource provisioning
- Google Cloud Platform compute and networking
- Terraform state management and workspaces
- Ansible automation for WordPress and Jenkins deployment

## Key Topics Covered

- Infrastructure as Code (IaC)
- Terraform modules, variables, and outputs
- AWS Amazon Linux 2 AMI selection
- Secure AWS security group configuration
- Azure resource group, network, and VM deployment
- GCP VPC, subnet, firewall, and compute instance setup
- Terraform remote state and workspaces
- Provisioners and lifecycle rules

## Lab Structure

- `01-Infrastructure-as-Code-IaC-Basics/`
- `02-Terraform-Basics/`
- `03-Terraform-Fundamental-Blocks/`
- `04-Terraform-Resources/`
- `05-Terraform-Variables/`
- `06-Terraform-Datasources/`
- `07-Terraform-State/`
- `08-Terraform-Workspaces/`
- `09-Terraform-Provisioners/`
- `10-Terraform-Modules/`
- `13-Terraform-State-Import/`
- `14-Terraform-Graph/`
- `15-Terraform-Expressions/`
- `16-Terraform-Debug/`
- `lab-00/` - AWS EC2 example with Amazon Linux 2 and secure networking
- `lab-01/` - Jenkins deployment with Terraform and Ansible
- `lab-04/` - WordPress deployment using Terraform and Ansible roles

## Getting Started

1. Install Terraform CLI and required cloud CLI tools.
2. Change into the lab directory you want to run.
3. Initialize Terraform:

```bash
cd lab-04
terraform init
```

4. Review the plan:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

6. After deployment, locate the output values or the provisioned public IP address.

## Example: WordPress Lab

The WordPress lab uses Terraform provisioning together with Ansible roles to install and configure WordPress on a cloud VM.

```bash
cd lab-04
terraform init
terraform plan
terraform apply
```

## Best Practices

- Keep Terraform state secure and out of version control.
- Use `.gitignore` to exclude `.tfstate`, `.terraform`, and sensitive files.
- Use data sources for the latest cloud image IDs.
- Limit SSH access to trusted IP addresses.
- Tag resources and use descriptive variable names.

## Notes

This repository is designed for learning and demonstration purposes. Customize variables and provider settings before running in production.

