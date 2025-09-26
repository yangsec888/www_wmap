# OWASP Web Mapper Portal

[![OWASP Lab](https://img.shields.io/badge/owasp-lab%20project-yellow.svg)](https://owasp.org/projects/)
[![Docker](https://img.shields.io/badge/docker-supported-blue.svg)](https://hub.docker.com/)
[![Rails](https://img.shields.io/badge/rails-5.x-red.svg)](https://rubyonrails.org/)

[<img src="wmap_logo.jpg" alt="WMAP Logo" width="350" height="350">](https://github.com/yangsec888/www_wmap)

A comprehensive web application discovery and asset tracking platform designed to help security professionals and organizations maintain visibility over their web application infrastructure at scale.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Demo](#demo)
- [Prerequisites](#prerequisites)
- [Technology Stack](#technology-stack)
- [Quick Start](#quick-start)
- [Docker Deployment](#docker-deployment)
- [Linux Deployment](#linux-deployment)
- [Usage](#usage)
- [LDAP Support](#ldap-support)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [Support](#support)
- [License](#license)

## 🎯 Overview

The **OWASP Web Mapper Portal** is a powerful web application that serves as the frontend interface for the [OWASP Web Mapper Project](https://owasp.org/www-project-web-mapper/). Built on Ruby on Rails, it provides an intuitive platform for discovering, mapping, and tracking web application assets across your infrastructure.

**Key Benefits:**
- 🔍 **Automated Discovery**: Systematically discover web applications and services
- 📊 **Asset Tracking**: Maintain comprehensive inventory of web assets
- 🎯 **Scalable**: Handle enterprise-level asset discovery operations
- 🔐 **Security-Focused**: Built with security best practices in mind
- 🌐 **Enterprise-Ready**: LDAP integration and role-based access control

To explore the full capabilities of the backend WMAP library, visit the [WMAP gem repository](https://github.com/yangsec888/wmap).

## ✨ Features

- **Web Asset Discovery**: Automated scanning and discovery of web applications
- **Domain Tracking**: Comprehensive domain and subdomain enumeration
- **Host Management**: Track and manage discovered hosts and services
- **Report Generation**: Generate detailed reports on discovered assets
- **Background Processing**: Asynchronous task processing with Sidekiq
- **User Management**: Role-based access control with Devise authentication
- **LDAP Integration**: Enterprise single sign-on support
- **RESTful API**: JSON API endpoints for integration

## 🔧 Prerequisites

Before installing WMAP Portal, ensure you have the following requirements:

### System Requirements
- **OS**: Linux (Ubuntu 18.04+, CentOS 7+) or macOS 10.14+
- **Memory**: Minimum 4GB RAM (8GB+ recommended)
- **Storage**: At least 10GB free disk space
- **Network**: Internet connectivity for asset discovery

### Software Dependencies
- **Docker & Docker Compose** (recommended) OR
- **Ruby**: 2.6+ with Bundler
- **Database**: MySQL 5.7+ or MariaDB 10.3+
- **Redis**: 5.0+ (for background job processing)
- **Node.js**: 14+ (for asset compilation)

## 🛠️ Technology Stack

WMAP Portal is built on modern, production-ready technologies:

### Backend Framework
- **[Ruby on Rails 5.x](https://rubyonrails.org/)** - Full-stack web application framework
- **[WMAP Gem](https://github.com/yangsec888/wmap)** - Core asset discovery and mapping engine

### Authentication & Security
- **[Devise](https://github.com/plataformatec/devise)** - Authentication and user session management
- **[devise_ldap_authenticatable](https://github.com/cschiewek/devise_ldap_authenticatable)** - LDAP/AD integration

### Frontend Technologies
- **[Twitter Bootstrap](https://getbootstrap.com/)** - Responsive UI framework
- **[jQuery](https://jquery.com/)** - JavaScript library for DOM manipulation
- **[CodeMirror](https://codemirror.net/)** - In-browser code editing component
- **[jsTree](https://www.jstree.com/)** - Interactive tree component for hierarchical data

### Background Processing
- **[Sidekiq](https://github.com/mperham/sidekiq)** - Efficient background job processing
- **[Redis](https://redis.io/)** - In-memory data store for job queues and caching

### Database & Infrastructure
- **[MariaDB](https://mariadb.org/)** - Primary database (MySQL-compatible)
- **[Postfix](http://www.postfix.org/)** - Email notification service
- **[Nginx](https://nginx.org/)** - Web server and reverse proxy (in Docker setup)

## 🚀 Quick Start

Get WMAP Portal up and running in minutes:

### Option 1: Docker (Recommended)

```bash
# Clone the repository
git clone https://github.com/yangsec888/www_wmap.git
cd www_wmap

# Start all services
docker-compose up -d

# Access the application
open http://localhost
```

### Option 2: Local Development

```bash
# Clone and setup
git clone https://github.com/yangsec888/www_wmap.git
cd www_wmap

# Install dependencies
bundle install
yarn install  # or npm install

# Setup database
rails db:create db:migrate db:seed

# Start the application
rails server
```

Access the application at `http://localhost:3000`

## 🎥 Demo

### Video Walkthrough

Watch this comprehensive demonstration of the Web Mapper's asset discovery capabilities:
[![Web Mapper Demo](https://img.youtube.com/vi/TL1occsk3Fc/0.jpg)](https://www.youtube.com/watch?v=TL1occsk3Fc "Web Mapper Asset Discovery Demo")

### Live Demo Instance

Experience the platform firsthand with our live demo instance:

**🌐 Demo URL**: [www.wmap.cloud](https://www.wmap.cloud/)  
**👤 Demo Credentials**:
- Username: `admin`
- Password: `admin123`

> **Note**: This is a shared demo environment. Please be respectful when testing features.


## 🐳 Docker Deployment

Docker provides a standardized development and deployment experience across different environments.

### Why Docker?

- **Consistency**: Identical development, testing, and production environments
- **Portability**: Deploy to any Docker-compatible infrastructure
- **Isolation**: Containerized services prevent dependency conflicts
- **Scalability**: Easy to scale individual services

### Container Architecture

The application runs as a multi-container setup:

- **`wmap_web`**: Main Rails application server
- **`wmap_db`**: MariaDB database server
- **`wmap_redis`**: Redis for background job queuing
- **`www_wmap_sidekiq_1`**: Background job processor
- **`www_wmap_nginx_1`**: Reverse proxy and static file server

### Production Deployment

1. **Clone and start services:**
   ```bash
   git clone https://github.com/yangsec888/www_wmap.git
   cd www_wmap
   docker-compose up -d
   ```

2. **Verify deployment:**
   ```bash
   docker-compose ps
   ```
   
   Expected output:
   ```
   Name                     State    Ports
   ----------------------------------------
   wmap_db                  Up       0.0.0.0:3306->3306/tcp
   wmap_redis               Up       6379/tcp
   wmap_web                 Up       0.0.0.0:3000->3000/tcp
   www_wmap_nginx_1         Up       0.0.0.0:80->80/tcp
   www_wmap_sidekiq_1       Up       3000/tcp
   ```

3. **Access the application:**
   Open your browser to `http://localhost`

### Troubleshooting

**Check container status:**
```bash
docker-compose ps
```

**View service logs:**
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs wmap_web
```

**Restart services:**
```bash
docker-compose restart
```

**Clean restart:**
```bash
docker-compose down
docker-compose up -d
```

### Custom Builds (Development)

For customization or development:

1. **Modify the application code**

2. **Rebuild the web container:**
   ```bash
   docker build . -t yangsec888/www_wmap_web:latest
   ```

3. **Update docker-compose.yml if needed**

4. **Restart with new image:**
   ```bash
   docker-compose up -d --build
   ```

## 🖥️ Linux Deployment

For native Linux deployment without Docker, detailed instructions are available in the [Setup.md](Setup.md) guide.

### System Requirements
- Ubuntu 18.04+ or CentOS 7+
- Ruby 2.6+ with development headers
- MySQL/MariaDB server
- Redis server
- Node.js and Yarn

### Quick Linux Setup
```bash
# Install system dependencies (Ubuntu)
sudo apt-get update
sudo apt-get install -y ruby ruby-dev build-essential mysql-server redis-server nodejs npm

# Install application
git clone https://github.com/yangsec888/www_wmap.git
cd www_wmap
bundle install
yarn install

# Configure database and start
rails db:setup
rails server
```

## 📖 Usage

### Getting Started

1. **Access the Portal**
   - Navigate to the application URL in your browser
   - Log in with your credentials (or demo credentials for the test instance)

2. **Initial Setup**
   - Click the **"Start"** button on the home page
   - Follow the guided setup wizard

3. **Asset Discovery**
   - Configure discovery parameters (target domains, IP ranges)
   - Launch discovery scans
   - Monitor progress in real-time

4. **View Results**
   - Navigate to the **"Discovery"** menu tab
   - Review discovered assets and services
   - Generate reports and export data

### Key Features

- **Dashboard**: Overview of discovered assets and recent activity
- **Domains**: Manage and track domain assets
- **Hosts**: Detailed host information and services  
- **Reports**: Generate comprehensive asset reports
- **Settings**: Configure discovery parameters and user preferences

## 🔐 LDAP Support

WMAP Portal supports enterprise LDAP/Active Directory integration for single sign-on.

### Configuration

1. **Enable LDAP authentication** in your Rails environment
2. **Configure LDAP settings** in `config/ldap.yml`:
   ```yaml
   production:
     host: ldap.company.com
     port: 636
     encryption: simple_tls
     base: ou=people,dc=company,dc=com
     uid: sAMAccountName
     bind_dn: CN=ldapuser,OU=Service Accounts,DC=company,DC=com
     password: your_ldap_password
   ```

3. **Restart the application** to apply changes

### LDAP Module

The integration uses [devise_ldap_authenticatable](https://github.com/cschiewek/devise_ldap_authenticatable) for seamless enterprise authentication.

## 🤝 Contributing

We welcome contributions to the OWASP Web Mapper Portal! Here's how to get involved:

### Development Setup

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`  
3. **Make your changes** and add tests
4. **Run the test suite**: `rails test`
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to your branch**: `git push origin feature/amazing-feature`
7. **Create a Pull Request**

### Code Standards

- Follow Ruby style guidelines
- Write comprehensive tests
- Update documentation for new features
- Ensure all CI checks pass

### Reporting Issues

- Use GitHub Issues for bug reports
- Provide detailed reproduction steps
- Include system information and error logs

## 🗺️ Roadmap

### Current Priorities

- ✅ **Docker containerization** - Complete
- ✅ **LDAP integration** - Complete  
- ✅ **RESTful API** - Complete

### Upcoming Features

- 🔄 **Integration & deployment tests** - In Progress
- 🔄 **Performance optimization** - In Progress
- 📅 **Rails 6.x upgrade** - Planned
- 📅 **Enhanced reporting** - Planned
- 📅 **API rate limiting** - Planned
- 📅 **Advanced asset correlation** - Planned

### Long-term Vision

- **Cloud-native deployment** options (Kubernetes, AWS ECS)
- **Machine learning** for asset classification
- **Integration** with popular security tools
- **Multi-tenancy** support

## 📞 Support

### Community Support

- **GitHub Issues**: [Report bugs and request features](https://github.com/yangsec888/www_wmap/issues)
- **OWASP Project Page**: [Official project information](https://owasp.org/www-project-web-mapper/)
- **Documentation**: [Setup guides and tutorials](Setup.md)

### Commercial Support

For enterprise support and custom development, please contact the project maintainers.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**[OWASP Web Mapper Project](https://owasp.org/www-project-web-mapper/)**

⭐ **Star this repository if you find it useful!** ⭐

</div>
