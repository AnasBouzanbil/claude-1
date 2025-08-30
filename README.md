# Cloud-1 Inception Project

## Universal Multi-User Setup

This project works on any Linux host with any user (not just 'anas').

### Quick Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AnasBouzanbil/claude-1.git
   cd claude-1
   ```

2. **Setup environment (automatically detects current user):**
   ```bash
   ./setup-env.sh
   ```

3. **Deploy with Ansible:**
   ```bash
   ansible-playbook -i hosts.ini playbook.yaml
   ```

### What Gets Created

- Data directories in `$HOME/data/` (current user's home)
- WordPress files in `$HOME/inception/`
- Docker volumes mounted to user-specific paths
- Environment configured for current user

### Features

- ✅ **Universal**: Works with any username (anas, amine, root, etc.)
- ✅ **Dynamic paths**: Uses `$HOME` and `$USER` variables
- ✅ **Auto-detection**: Automatically configures for current user
- ✅ **Clean separation**: Each user gets their own data directories

### Manual Setup

If you prefer manual setup:

```bash
# Copy environment template
cp env.example.txt inception/.env
# Edit inception/.env to match your user/paths
```
