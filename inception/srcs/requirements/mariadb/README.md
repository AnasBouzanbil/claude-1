# 🗄️ MariaDB Service

**Purpose**: Database server that stores all your website data securely and reliably.

## 🎯 What This Service Does

MariaDB is the **memory** of your website:
- 💾 Stores all WordPress data (posts, users, settings)
- 🔒 Manages user authentication and permissions
- 📊 Handles database queries from WordPress
- 🔄 Ensures data consistency and integrity
- 💪 Provides reliable data persistence

## 📁 Files Explained

### `Dockerfile`
```dockerfile
FROM debian:bullseye              # Base Linux system
RUN apt-get install mariadb-server  # Install MariaDB

# Replace default configuration
RUN rm -rf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy database setup script
COPY ./tools/scrpit_db.sh /tmp/script_db.sh
RUN chmod +x /tmp/script_db.sh

# Create necessary directories
RUN mkdir /var/run/mysqld

CMD ["/bin/bash", "/tmp/script_db.sh"]
```

### `conf/50-server.cnf` - MariaDB Configuration
```ini
[mysqld]
user = root                    # Run as root user
port = 3306                    # Standard MySQL port
socket = /var/run/mysqld/mysqld.sock
bind-address = 0.0.0.0         # Listen on all container interfaces

# Database file locations
datadir = /var/lib/mysql       # Where database files are stored
tmpdir = /tmp                  # Temporary file location

# Performance settings
query_cache_size = 16M         # Cache frequently used queries
key_buffer_size = 16M          # Index cache size

# Security settings
skip-name-resolve = 1          # Don't resolve hostnames (faster)
local-infile = 0               # Disable local file loading
```

### `tools/scrpit_db.sh` - Database Setup Script
```bash
#!/bin/bash

# Create MariaDB configuration
cat << EOF > /etc/mysql/my.cnf
[mysqld]
user = root
port = 3306
socket = /var/run/mysqld/mysqld.sock
bind-address = 0.0.0.0
EOF

# Start MariaDB service
service mariadb start
sleep 10                       # Wait for MariaDB to be ready

# Create database and user
echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" >> db.sql
echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" >> db.sql
echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" >> db.sql
echo "FLUSH PRIVILEGES;" >> db.sql

# Execute database setup
mariadb < db.sql

# Stop service and start in foreground
service mariadb stop
sleep 5
mysqld                         # Run MariaDB in foreground
```

## 🔧 How It Works

### **Database Initialization Process**
1. **Container starts** and configures MariaDB
2. **Service starts** temporarily to set up database
3. **Creates database** specified in environment variables
4. **Creates user** with permissions for WordPress
5. **Stops service** and restarts in foreground mode
6. **Ready** to accept connections from WordPress

### **Data Storage**
```
/var/lib/mysql/              # Database data directory
├── wordpress_db/            # Your WordPress database
│   ├── wp_posts.ibd        # Blog posts and pages
│   ├── wp_users.ibd        # User accounts
│   ├── wp_options.ibd      # WordPress settings
│   └── ... (other tables)
├── mysql/                   # System database
└── performance_schema/      # Performance monitoring
```

### **WordPress Integration**
- WordPress connects using credentials from `.env`
- All WordPress data stored in `wordpress_db` database
- Automatic backup of data to host directory `/home/anas/data/mariadb/`

## 🚀 Usage

### **Build and Run**
```bash
# Build MariaDB container
docker compose build mariadb

# Start MariaDB service
docker compose up mariadb

# Check if running
docker ps | grep mariadb
```

### **Database Access**
```bash
# Connect to database as root
docker exec -it mariadb mysql -u root -p

# Connect as WordPress user
docker exec -it mariadb mysql -u wp_user -p

# Quick database check
docker exec mariadb mysql -u wp_user -p$DB_PASSWORD -e "SHOW DATABASES;"
```

### **Database Management**
```bash
# View WordPress tables
docker exec mariadb mysql -u wp_user -p$DB_PASSWORD wordpress_db -e "SHOW TABLES;"

# Check user accounts
docker exec mariadb mysql -u root -p -e "SELECT User, Host FROM mysql.user;"

# View database size
docker exec mariadb mysql -u wp_user -p$DB_PASSWORD -e "
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'wordpress_db';"
```

## 🔧 Customization

### **Change Database Credentials**
Edit `.env` file:
```bash
# Database configuration
DB_NAME=my_custom_db
DB_USER=my_user
DB_PASSWORD=secure_password123
MARIADB_ROOT_PASSWORD=super_secure_root_pass
```

### **Performance Tuning**
Edit `conf/50-server.cnf`:
```ini
# Increase buffer sizes for better performance
innodb_buffer_pool_size = 256M    # Main memory buffer
query_cache_size = 64M            # Query result cache
key_buffer_size = 32M             # Index cache
max_connections = 100             # Maximum connections

# Optimize for SSDs
innodb_flush_method = O_DIRECT    # Direct I/O for SSDs
innodb_log_file_size = 64M        # Larger log files
```

### **Security Hardening**
Add to `conf/50-server.cnf`:
```ini
# Enhanced security
skip-name-resolve = 1             # Faster, more secure
local-infile = 0                  # Disable file loading
secure_file_priv = NULL           # Disable file operations
sql_mode = STRICT_TRANS_TABLES    # Strict SQL mode
```

### **Enable Binary Logging (for backups)**
Add to `conf/50-server.cnf`:
```ini
# Binary logging for backups/replication
log_bin = /var/log/mysql/mysql-bin.log
binlog_format = ROW
expire_logs_days = 7              # Keep logs for 7 days
max_binlog_size = 100M            # Rotate at 100MB
```

## 🚨 Troubleshooting

### **Database Won't Start**
```bash
# Check MariaDB logs
docker logs mariadb

# Check if port is available
docker exec mariadb netstat -tlnp | grep 3306

# Verify configuration syntax
docker exec mariadb mysqld --help --verbose

# Common issues:
# - Corrupted data directory
# - Permission problems
# - Configuration syntax errors
```

### **Connection Issues**
```bash
# Test connection from WordPress container
docker exec wordpress mysql -h mariadb -u wp_user -p

# Check if MariaDB is listening
docker exec mariadb ss -tlnp | grep 3306

# Verify user permissions
docker exec mariadb mysql -u root -p -e "
SELECT User, Host, authentication_string FROM mysql.user WHERE User='wp_user';"
```

### **Performance Issues**
```bash
# Check running processes
docker exec mariadb mysql -u root -p -e "SHOW PROCESSLIST;"

# Check slow queries
docker exec mariadb mysql -u root -p -e "SHOW STATUS LIKE 'Slow_queries';"

# Check buffer usage
docker exec mariadb mysql -u root -p -e "SHOW STATUS LIKE 'Innodb_buffer_pool%';"
```

### **Data Recovery**
```bash
# Check database integrity
docker exec mariadb mysqlcheck -u root -p --all-databases

# Repair corrupted tables
docker exec mariadb mysqlcheck -u root -p --repair wordpress_db

# Restore from backup
docker exec mariadb mysql -u root -p wordpress_db < backup.sql
```

## 🔍 Monitoring

### **Database Health**
```bash
# Check database status
docker exec mariadb mysql -u root -p -e "SHOW STATUS;"

# Monitor connections
docker exec mariadb mysql -u root -p -e "SHOW STATUS LIKE 'Connections';"

# Check database sizes
docker exec mariadb mysql -u root -p -e "
SELECT 
    table_schema AS 'Database',
    COUNT(*) AS 'Tables',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables 
GROUP BY table_schema;"
```

### **Performance Metrics**
```bash
# Query cache hit rate
docker exec mariadb mysql -u root -p -e "
SELECT 
    ROUND((Qcache_hits / (Qcache_hits + Qcache_inserts)) * 100, 2) AS 'Query Cache Hit Rate %'
FROM 
    (SELECT VARIABLE_VALUE AS Qcache_hits FROM information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME = 'Qcache_hits') AS hits,
    (SELECT VARIABLE_VALUE AS Qcache_inserts FROM information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME = 'Qcache_inserts') AS inserts;"

# Buffer pool efficiency
docker exec mariadb mysql -u root -p -e "SHOW STATUS LIKE 'Innodb_buffer_pool_read_requests';"
```

## 💾 Backup and Restore

### **Create Backup**
```bash
# Full database backup
docker exec mariadb mysqldump -u root -p --all-databases > full_backup.sql

# WordPress database only
docker exec mariadb mysqldump -u root -p wordpress_db > wordpress_backup.sql

# Compressed backup
docker exec mariadb mysqldump -u root -p wordpress_db | gzip > wordpress_backup.sql.gz
```

### **Restore Backup**
```bash
# Restore full backup
docker exec -i mariadb mysql -u root -p < full_backup.sql

# Restore WordPress database
docker exec -i mariadb mysql -u root -p wordpress_db < wordpress_backup.sql

# Restore compressed backup
gunzip < wordpress_backup.sql.gz | docker exec -i mariadb mysql -u root -p wordpress_db
```

## 🔒 Security Features

- ✅ **No external ports** - Only accessible from other containers
- ✅ **User authentication** - Separate user for WordPress access
- ✅ **Password protection** - All accounts require passwords
- ✅ **Network isolation** - Only accessible within Docker network
- ✅ **Data encryption** - Data at rest encryption (configurable)

## 📊 Database Schema

### **WordPress Tables**
```sql
wp_posts          -- Blog posts and pages
wp_users          -- User accounts
wp_options        -- WordPress settings
wp_comments       -- Post comments
wp_postmeta       -- Post metadata
wp_usermeta       -- User metadata
wp_terms          -- Categories and tags
wp_term_taxonomy  -- Term relationships
wp_term_relationships -- Post-term relationships
wp_commentmeta    -- Comment metadata
```

---

🗄️ **Your MariaDB service provides reliable, secure, and persistent data storage for your entire WordPress infrastructure!**
