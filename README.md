# Terraform and Ansible Collaboration

This repository contains Terraform code to provision a machine in AWS and configure it using Ansible. It demonstrates how to use Terraform for infrastructure provisioning and Ansible for configuration management, enabling a seamless workflow for cloud deployments.

## Repository Structure

- `main.tf`: Contains the Terraform code to create and manage AWS resources.
- `ansible.cfg`: Ansible configuration file.
- `patch_apache_install.yml`: An Ansible playbook to install and configure Apache on the provisioned machine.

## Prerequisites

- Terraform v1.0 or higher
- Ansible v2.9 or higher
- AWS account credentials configured in your environment

## Usage

1. **Clone the repository:**

   ```bash
   git clone https://github.com/cjcheema/terraform_ansible_collaboration.git
   cd terraform_ansible_collaboration
   ```

2. **Initialize Terraform:**

   ```bash
   terraform init
   ```

3. **Apply Terraform configurations:**

   ```bash
   terraform apply
   ```

   This command will create the necessary AWS resources as defined in `main.tf`.

4. **Run Ansible playbook:**

   Terraform configuration is capable to execute Ansible playbook automatically to install patches, apache and configure it in provisioned instances:

   ```bash
   ansible-playbook -i ${self.public_ip}, –private-key ${var.private_key_path} patch_apache_install.yml
   ```

## Read more

Check out my article to learn how to utilize this Terraform configuration for deploying resources on AWS Cloud. This guide will help you understand the step-by-step process, from setting up your environment to deploying infrastructure efficiently using Terraform and Ansible:
https://www.cjcheema.com/2024/08/28/terraform-and-ansible-collaboration-for-aws-cloud-deployment/

## Contributing

Feel free to submit issues or pull requests. For major changes, please open an issue first to discuss what you would like to change.
