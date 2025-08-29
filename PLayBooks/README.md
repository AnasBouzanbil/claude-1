# 🤖 Ansible Automation - One-Click Deployment

This folder contains the **Ansible automation** that deploys the entire WordPress infrastructure with a single command. No manual setup required!

## 🎯 What Ansible Does For You

Ansible is like having a **robot assistant** that:
1. 📦 **Installs Docker** (if not already installed)
2. 🔧 **Sets up the environment** (creates folders, sets permissions)
3. 📁 **Copies project files** to the target server
4. 🚀 **Builds and starts** all WordPress services
5. ✅ **Configures auto-restart** (survives server reboots)

## 📁 Files Explained

### 🔧 `playbook.yaml` - The Main Automation Script
This file contains step-by-step instructions that Ansible follows:

```yaml
tasks:
  1. Update system packages
  2. Install Docker and Docker Compose
  3. Create data directories for WordPress and database
  4. Copy project files to server
  5. Build and start WordPress infrastructure
  6. Enable auto-restart on system reboot
```

### 📋 `hosts.ini` - Server Configuration
Tells Ansible which server to deploy to:
```ini
[hosts]
abouzanb@42.fr ansible_connection=local ansible_user=anas
```

This means: "Deploy to the local machine as user 'anas'"

## 🚀 How to Use Ansible

### **Option 1: Deploy Everything (Recommended)**
```bash
# Run the complete automation
ansible-playbook -i hosts.ini playbook.yaml
```

### **Option 2: Deploy to Remote Server**
```bash
# First, update hosts.ini with your server details:
# [hosts]
# your-server.com ansible_user=your-username

# Then deploy
ansible-playbook -i hosts.ini playbook.yaml
```

### **Option 3: Check What Will Happen (Dry Run)**
```bash
# See what Ansible would do without actually doing it
ansible-playbook -i hosts.ini playbook.yaml --check
```

## 🔍 What Happens Step by Step

### **Phase 1: System Preparation** ⚙️
1. **Update packages** - Makes sure system is up to date
2. **Install dependencies** - Adds required tools (curl, python3, etc.)
3. **Add Docker repository** - Prepares to install Docker

### **Phase 2: Docker Installation** 🐳
1. **Download Docker GPG key** - Security verification
2. **Add Docker repository** - Official Docker source
3. **Install Docker CE** - The main Docker engine
4. **Install Docker Compose** - Tool to manage multiple containers
5. **Enable Docker service** - Starts Docker automatically on boot

### **Phase 3: Project Setup** 📁
1. **Create project directory** - `/home/anas/inception`
2. **Create data directories** - For WordPress and database storage
3. **Copy project files** - All Docker configurations and scripts

### **Phase 4: Deployment** 🚀
1. **Build containers** - Creates custom Docker images
2. **Start services** - Launches WordPress, database, nginx, phpMyAdmin
3. **Verify deployment** - Ensures everything is running

## 🔧 Customization Options

### **Deploy to Different User**
Edit `hosts.ini`:
```ini
[hosts]
server.com ansible_user=your-username
```

### **Change Installation Directory**
Edit `playbook.yaml` and change:
```yaml
path: /home/your-username/inception  # Change this path
```

### **Skip Docker Installation**
If Docker is already installed, comment out the Docker installation tasks in `playbook.yaml`.

### **Deploy to Multiple Servers**
Add more servers to `hosts.ini`:
```ini
[hosts]
server1.com ansible_user=user1
server2.com ansible_user=user2
server3.com ansible_user=user3
```

## 🛡️ Security Features

### **What Ansible Ensures**
- ✅ Docker daemon starts automatically on boot
- ✅ All services restart if they crash
- ✅ Proper file permissions for data directories
- ✅ Secure package installation from official repositories

### **Password Management**
- Passwords are stored in `.env` files
- Never hardcoded in Ansible scripts
- Can be encrypted using Ansible Vault (advanced)

## 📊 Monitoring Deployment

### **Watch Ansible in Action**
```bash
# Run with verbose output to see details
ansible-playbook -i hosts.ini playbook.yaml -v

# Even more details
ansible-playbook -i hosts.ini playbook.yaml -vv
```

### **Check Deployment Status**
```bash
# After deployment, verify services are running
docker ps

# Check service logs
docker logs nginx
docker logs wordpress
docker logs mariadb
```

## 🚨 Troubleshooting

### **Common Issues & Solutions**

#### **"Permission Denied" Errors**
```bash
# Add your user to docker group
sudo usermod -aG docker $USER

# Log out and back in, then try again
```

#### **"Port Already in Use" Errors**
```bash
# Check what's using the ports
sudo lsof -i :443
sudo lsof -i :8080

# Stop conflicting services
sudo systemctl stop apache2
sudo systemctl stop nginx
```

#### **"Docker Not Found" After Installation**
```bash
# Restart the shell or logout/login
exit
# Then try the deployment again
```

#### **Ansible Can't Connect to Host**
```bash
# Test connection manually
ansible -i hosts.ini all -m ping

# Check SSH access (for remote servers)
ssh user@your-server.com
```

### **Debug Mode**
```bash
# Run with maximum verbosity
ansible-playbook -i hosts.ini playbook.yaml -vvv

# Run specific tasks only
ansible-playbook -i hosts.ini playbook.yaml --tags "docker"
```

## 🔄 Re-running Deployment

### **Safe Re-deployment**
```bash
# Ansible is idempotent - safe to run multiple times
ansible-playbook -i hosts.ini playbook.yaml
```

### **Force Clean Deployment**
```bash
# Stop everything first
cd inception && make down

# Then re-run Ansible
ansible-playbook -i hosts.ini playbook.yaml
```

## 📈 Advanced Usage

### **Ansible Vault for Passwords**
```bash
# Encrypt sensitive files
ansible-vault encrypt .env

# Run playbook with vault
ansible-playbook -i hosts.ini playbook.yaml --ask-vault-pass
```

### **Custom Variables**
Create `vars.yaml`:
```yaml
docker_user: anas
project_path: /home/anas/inception
domain_name: your-domain.com
```

Use in playbook:
```bash
ansible-playbook -i hosts.ini playbook.yaml -e @vars.yaml
```

## 🎯 Why Use Ansible?

### **Benefits**
- 🚀 **One-command deployment** - No manual steps
- 🔄 **Repeatable** - Same result every time
- 📝 **Documentation** - Playbook serves as deployment guide
- 🛡️ **Reliable** - Handles errors and edge cases
- 🔧 **Customizable** - Easy to modify for different environments

### **Perfect For**
- Setting up development environments
- Deploying to production servers
- Disaster recovery
- Team collaboration (everyone gets same setup)

---

🎉 **Your one-click WordPress deployment is ready!** Just run `ansible-playbook -i hosts.ini playbook.yaml` and watch the magic happen!
