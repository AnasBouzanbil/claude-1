# Inception: WordPress Deployment with Docker and Ansible

This repository contains an automated deployment solution for a complete WordPress stack using Docker and Ansible. The playbook automates the process of provisioning a server, installing dependencies, and orchestrating the containerized services.

## Architecture

The deployment consists of the following containerized services:
* **Nginx**: Web server acting as a reverse proxy for the application.
* **WordPress**: The core content management system.
* **MariaDB**: Relational database for WordPress data.
* **phpMyAdmin**: Web interface for database management.

## Prerequisites

To run this deployment, you will need:
* Ansible installed on your local control machine.
* SSH access to the target server(s) with root privileges (or a user with `sudo` access).
* A target server running a compatible Linux distribution (e.g., Debian/Ubuntu).

## Project Structure

* `playbook.yaml`: The main Ansible playbook that orchestrates the deployment.
* `playbooks/`: Directory containing specific deployment steps (system setup, Docker installation, file copying).
* `roles/`: Directory containing Ansible roles for each service (nginx, wordpress, mariadb, phpmyadmin).
* `hosts.ini`: Ansible inventory file defining the target servers.
* `env.example.txt`: Template for the required environment variables.
* `inception/`: Directory containing the Docker Compose configuration and related project files.

## Setup and Usage

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Configure the inventory:**
   Edit the `hosts.ini` file and replace `[ipaddress]` with the actual IP address or hostname of your target server. Ensure the `ansible_user` is correctly set (default is `root`).

3. **Set up environment variables:**
   Copy the example environment file and fill in your specific configuration details:
   ```bash
   cp env.example.txt .env
   ```
   Open the `.env` file and configure the database credentials, WordPress settings, and container ports. This file will be used to populate the environment variables for the Docker containers.

4. **Run the playbook:**
   Execute the Ansible playbook to start the deployment process:
   ```bash
   ansible-playbook -i hosts.ini playbook.yaml
   ```

The playbook will perform the following actions:
* Setup necessary system packages.
* Install Docker and related dependencies.
* Create required project directories on the remote host.
* Copy the project files and configuration.
* Start the Docker containers using the defined roles.
