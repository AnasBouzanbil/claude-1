# Cloud-1 Inception Project

## Universal Multi-User Setup

This project works on any Linux host with any user automatically.

### Quick Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AnasBouzanbil/claude-1.git
   cd claude-1
   ```

2. **Create environment file:**
   ```bash
   cp env.example.txt inception/.env
   # Edit inception/.env if needed (optional)
   ```

3. **Deploy with Ansible:**
   ```bash
   ansible-playbook -i hosts.ini playbook.yaml
   ```

### How It Works

- **Automatic User Detection**: Uses `$HOME` and `$USER` environment variables
- **Dynamic Paths**: Data directories created in current user's home automatically
- **No Manual Configuration**: Works out of the box for any user

### What Gets Created

- Data directories in `$HOME/data/` (automatically detected)
- WordPress files in `$HOME/inception/`
- Docker volumes mounted to user-specific paths

### Features

- ✅ **Universal**: Works with any username (anas, amine, root, etc.)
- ✅ **Zero Configuration**: No scripts to run, works automatically
- ✅ **Dynamic**: Automatically adapts to current user and system
- ✅ **Clean**: Simple setup without unnecessary complexity


https://freemyip.com/update?token=95c162afa7d8d44f2dc6caca&domain=abouzanb.freemyip.com