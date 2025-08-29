# 🛡️ Nginx Service

**Purpose**: Web server that handles all incoming internet requests and provides SSL encryption.

## 🎯 What This Service Does

Think of Nginx as the **front door** of your website:
- 🌐 Receives all requests from the internet
- 🔒 Provides HTTPS/SSL encryption for security
- 🚦 Routes requests to the right service (WordPress or PHPMyAdmin)
- 📁 Serves static files (images, CSS, JavaScript)

## 📁 Files Explained

### `Dockerfile`
```dockerfile
FROM debian:bullseye                    # Base Linux system
RUN apt-get install nginx openssl       # Install nginx and SSL tools
COPY ./conf/default /etc/nginx/conf.d/  # Copy our configuration
CMD ["/bin/bash", "/tmp/script.sh"]     # Run startup script
```

### `conf/default` - Nginx Configuration
```nginx
server {
    listen 443 ssl;                     # Listen for HTTPS requests
    server_name abouzanb.42.fr;         # Your domain name
    
    # SSL certificate files
    ssl_certificate /etc/nginx/ssl/certificate.crt;
    ssl_certificate_key /etc/nginx/ssl/private.key;
    
    # Route WordPress requests
    location / {
        try_files $uri /index.php$args;
    }
    
    # Route PHP requests to WordPress container
    location ~ \.php$ {
        fastcgi_pass wordpress:9000;    # Send to WordPress service
    }
}

server {
    listen 8080 ssl;                     # PHPMyAdmin on port 8080
    location / {
        proxy_pass http://phpmyadmin:80; # Send to PHPMyAdmin service
    }
}
```

### `tools/script.sh` - Startup Script
```bash
# Create SSL certificate directory
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
openssl req -x509 -nodes \
    -out /etc/nginx/ssl/certificate.crt \
    -keyout /etc/nginx/ssl/private.key \
    -subj /C=MO/L=BN/O=1337/CN=abouzanb.42.fr

# Start nginx
nginx -g "daemon off;"
```

## 🔧 How It Works

### **Request Flow**
1. **User visits** `https://abouzanb.42.fr`
2. **Nginx receives** the request on port 443
3. **SSL encryption** secures the connection
4. **Nginx forwards** request to WordPress container
5. **WordPress processes** the request
6. **Nginx returns** the response to user

### **SSL/HTTPS Process**
1. **Certificate generation** when container starts
2. **Automatic encryption** of all communications
3. **Secure protocols** (TLS 1.2, TLS 1.3)
4. **Self-signed certificate** (fine for development)

## 🚀 Usage

### **Build and Run**
```bash
# Build nginx container
docker compose build nginx

# Start nginx service
docker compose up nginx

# Check if running
docker ps | grep nginx
```

### **Test Configuration**
```bash
# Test nginx config syntax
docker exec nginx nginx -t

# Reload configuration
docker exec nginx nginx -s reload

# View nginx logs
docker logs nginx
```

### **SSL Certificate Management**
```bash
# View current certificate
docker exec nginx openssl x509 -in /etc/nginx/ssl/certificate.crt -text

# Check certificate expiration
docker exec nginx openssl x509 -in /etc/nginx/ssl/certificate.crt -noout -dates
```

## 🔧 Customization

### **Change Domain Name**
Edit `conf/default`:
```nginx
server_name your-domain.com;  # Change this line
```

Also update SSL certificate generation in `tools/script.sh`:
```bash
-subj /C=US/L=City/O=Org/CN=your-domain.com
```

### **Add Real SSL Certificate**
Replace self-signed certificate with real one:
```bash
# Copy your certificates to nginx container
docker cp your-cert.crt nginx:/etc/nginx/ssl/certificate.crt
docker cp your-key.key nginx:/etc/nginx/ssl/private.key

# Restart nginx
docker restart nginx
```

### **Enable Additional Security**
Add to `conf/default`:
```nginx
# Security headers
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";

# Disable server version
server_tokens off;
```

### **Enable Caching**
Add to `conf/default`:
```nginx
# Cache static files
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

## 🚨 Troubleshooting

### **Nginx Won't Start**
```bash
# Check configuration syntax
docker exec nginx nginx -t

# Check error logs
docker logs nginx

# Common issues:
# - Port 443 already in use
# - Invalid configuration syntax
# - Missing SSL certificates
```

### **SSL Certificate Issues**
```bash
# Regenerate certificate
docker exec nginx rm -f /etc/nginx/ssl/*
docker restart nginx

# Check certificate validity
docker exec nginx openssl verify /etc/nginx/ssl/certificate.crt
```

### **Can't Connect to Backend Services**
```bash
# Test connectivity to WordPress
docker exec nginx ping wordpress

# Test connectivity to PHPMyAdmin
docker exec nginx ping phpmyadmin

# Check if services are on same network
docker network inspect inception_anas
```

### **Port Conflicts**
```bash
# Check what's using port 443
sudo lsof -i :443

# Stop conflicting services
sudo systemctl stop apache2  # If Apache is running
sudo systemctl stop nginx    # If system nginx is running
```

## 🔍 Monitoring

### **View Access Logs**
```bash
# Follow access logs in real-time
docker exec nginx tail -f /var/log/nginx/access.log

# View error logs
docker exec nginx tail -f /var/log/nginx/error.log
```

### **Check Performance**
```bash
# View nginx status
docker exec nginx nginx -s status

# Check resource usage
docker stats nginx

# Test response time
curl -w "%{time_total}" https://abouzanb.42.fr
```

## 🔒 Security Features

- ✅ **SSL/TLS encryption** for all communications
- ✅ **Modern protocols** (TLS 1.2, TLS 1.3)
- ✅ **Reverse proxy** hides internal services
- ✅ **No direct access** to database or WordPress
- ✅ **Security headers** (can be configured)

---

🛡️ **Nginx acts as your security gateway, ensuring all web traffic is encrypted and properly routed!**
