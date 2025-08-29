# 🚀 Inception Project - Complete WordPress Infrastructure

A fully automated WordPress hosting infrastructure built with **Docker** and deployed with **Ansible**. This project creates a production-ready website with database management, SSL security, and automatic deployment.

## 🎯 What This Project Does

This project builds a **complete website hosting system** that includes:
- 📱 **WordPress Website** - Your main website where you can write blogs, create pages
- 🗄️ **Database** - Stores all your website data (users, posts, settings)
- 🛡️ **Security** - SSL certificates for encrypted connections (HTTPS)
- 🔧 **Database Manager** - Easy web interface to manage your database
- 🤖 **Auto-Deployment** - One command deploys everything automatically

## 🏗️ Project Structure

```
📁 inception/           # Main WordPress infrastructure
├── 📁 srcs/           # Docker containers and configurations
│   ├── 🐳 docker-compose.yml    # Orchestrates all services
│   ├── 📁 requirements/         # Individual service configurations
│   │   ├── 📁 nginx/            # Web server & SSL
│   │   ├── 📁 wordpress/        # WordPress application
│   │   ├── 📁 mariadb/          # Database server
│   │   └── 📁 phpmyadmin/       # Database management tool
│   └── 🔧 .env                 # Environment configuration
├── 🛠️ Makefile                 # Build and deployment commands
└── 📋 README.md                # Documentation

📁 ansible/            # Automated deployment
├── 🔧 playbook.yaml   # Deployment automation script
├── 📋 hosts.ini       # Server configuration
└── 📋 README.md       # Ansible documentation
```

## ⚡ Quick Start

### 1. **Deploy Everything Automatically (Recommended)**
```bash
# Run the Ansible automation (installs Docker + deploys project)
ansible-playbook -i hosts.ini playbook.yaml
```

### 2. **Manual Deployment**
```bash
# Go to inception folder
cd inception/

# Build and start all services
make re

# Check if everything is running
docker ps
```

## 🌐 Access Your Services

Once deployed, you can access:

| Service | URL | Purpose |
|---------|-----|---------|
| **WordPress Site** | `https://abouzanb.42.fr` | Your main website |
| **PHPMyAdmin** | `https://abouzanb.42.fr:8080` | Database management |
| **WordPress Admin** | `https://abouzanb.42.fr/wp-admin` | Website administration |

## 🔐 Default Login Credentials

**WordPress Admin:**
- Username: `admin`
- Password: `admin123!`
- Email: `admin@abouzanb.42.fr`

**Database Access:**
- Database: `wordpress_db`
- User: `wp_user`
- Password: `wp_pass`

> ⚠️ **Security Note**: Change these passwords in production!

## 🛠️ Available Commands

```bash
# Build all containers
make build

# Start all services
make up

# Stop all services
make down

# Rebuild everything (clean start)
make re

# Complete cleanup (removes data)
make rmall
```

## 🏗️ System Architecture

```
🌐 Internet
    ↓
🛡️ Nginx (Port 443/8080) - SSL Termination & Reverse Proxy
    ↓
📱 WordPress (PHP-FPM) - Website Application
    ↓
🗄️ MariaDB - Database Storage
    ↑
🔧 PHPMyAdmin - Database Management Interface
```

## 🔧 What Makes This Special

### ✅ **Production Ready Features**
- **SSL/TLS Encryption** - Secure HTTPS connections
- **Data Persistence** - All data survives server restarts
- **Auto-Restart** - Services automatically restart after reboot
- **Custom Built** - All containers built from scratch (no pre-made images)
- **Isolated Network** - Services communicate securely

### 🤖 **Automation Features**
- **One-Command Deployment** - Ansible automates everything
- **Docker Installation** - Automatically installs Docker if needed
- **User Management** - Creates WordPress users automatically
- **Environment Configuration** - Easy configuration via .env files

## 📚 Detailed Documentation

For more detailed information, check the documentation in each folder:

- 📋 [Inception Infrastructure Guide](./inception/README.md)
- 🤖 [Ansible Deployment Guide](./PLayBooks/README.md)
- 🐳 [Docker Services Documentation](./inception/srcs/requirements/README.md)

## 🛡️ Security Features

- ✅ Database not directly accessible from internet
- ✅ SSL certificates for encrypted communication
- ✅ Internal Docker network isolation
- ✅ Environment variable protection
- ✅ No default passwords in production

## 🔄 Data Persistence

All important data is stored persistently:
- **WordPress files** → `/home/anas/data/wordpress/`
- **Database data** → `/home/anas/data/mariadb/`
- **User uploads & themes** → Preserved across restarts

## 🚨 Troubleshooting

**Services won't start?**
```bash
# Check service status
docker ps

# View service logs
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Permission issues?**
```bash
# Fix data directory permissions
sudo chown -R $USER:$USER /home/anas/data/
```

**Need to reset everything?**
```bash
make rmall  # This will delete all data!
```

## 👨‍💻 Author

**Anas Bouzanbil**
- GitHub: [@AnasBouzanbil](https://github.com/AnasBouzanbil)
- Email: abouzanb@student.42.fr

---

🎉 **Congratulations!** You now have a complete, production-ready WordPress hosting infrastructure!
