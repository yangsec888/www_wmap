[<img src='./wmap_logo.jpg' width='350' height='350'>](https://github.com/yangsec888/www_wmap)
=====================

- [1 Setup Hosting Environment](#1-setup-hosting-environment)
  - [1.1 Docker Prerequisites (Recommended)](#11-docker-prerequisites-recommended)
  - [1.2 Service Account Setup (Alternative)](#12-service-account-setup-alternative)
- [2 Runtime Environment Setup](#2-runtime-environment-setup)
  - [2.1 Install MariaDB v10.4.x](#21-install-mariadb-v104x)
  - [2.2 Install Redis v5.x Server](#22-install-redis-v5x-server)
  - [2.3 Install RVM environment:](#23-install-rvm-environment)
  - [2.4 Install Ruby on Rails](#24-install-ruby-on-rails)
  - [2.5 Down Project Source Code](#25-download-project-source-code)
  - [2.6 Install Sidekiq](#26-install-sidekiq)
  - [2.7 Install JS runtime](#27-install-js-runtime)
  - [2.8 Generate the application encryption key](#28-generate-the-application-encryption-key)
  - [2.9 Configure the rails environment variables](#29-configure-the-rails-environment-variables)
  - [2.10 Puma Application Server](#210-puma-application-server)
  - [2.11 Install NGINX](#211-install-nginx)
  - [2.12 Create a certificate](#212-create-a-certificate)
  - [2.13 Configure the Web Server](#213-configure-the-web-server)
  - [2.14 Setup Ubuntu Firewall](#214-setup-ubuntu-firewall)
  - [2.15 Setup Postfix as Send Only SMTP Server](#215-setup-postfix-as-send-only-smtp-server)
- [3 Start the Rails Server](#3-start-the-rails-server)
---

## 1 Setup Hosting Environment
The WMAP application can be deployed using either Docker containers (recommended) or traditional Linux installation.

### 1.1 Docker Prerequisites (Recommended)
The easiest way to run WMAP is using Docker and Docker Compose. This approach provides:
- Consistent environment across development and production
- Isolated services (web, database, redis, sidekiq, smtp)  
- Simplified dependency management
- Easy scaling and maintenance

#### Install Docker and Docker Compose:
```sh
# Ubuntu/Debian
$ sudo apt-get update
$ sudo apt-get install docker.io docker-compose

# Or follow official Docker installation guide
# https://docs.docker.com/get-docker/
```

#### Verify Installation:
```sh
$ docker --version
$ docker-compose --version
```

### 1.2 Service Account Setup (Alternative)
For traditional Linux installation, create a service account "deploy" for the Rails app running environment. Add the service account to the special group 'wheel' for sudo access.
```sh
# adduser deploy
# addgroup wheel
# usermod -aG wheel deploy
```

## 2 Runtime Environment Setup

**Note**: If using Docker (Section 1.1), most of these dependencies are handled automatically by containers. This section covers traditional Linux installation.

WMAP App requires [Ruby on Rails](http://rubyonrails.org) v5.2.x, [MariaDB](https://www.mysql.com/) v10.4.x database, [Redis](https://redis.io/) 5.x in-memory data store, in order to run properly.

Install the environment dependencies, and ensure the database server is running. For example, in our Linux box

### 2.1 Install MariaDB v10.4.x
* [How to Install MariaDB in Ubuntu 18.0.4](https://linuxize.com/post/how-to-install-mariadb-on-ubuntu-18-04/)

```sh
$ sudo apt -y install mariadb-server mariadb-client
```
#### Start Maria DB:
```sh
$ sudo systemctl start mysql
```

#### Install the mysql client support
You would need mysql client support, in order to connect to the database:
```sh
$ sudo apt-get install libmysqlclient-dev
$ gem install mysql2 -v '0.5.2' --source 'https://rubygems.org/'
```

### 2.2 Install Redis v5.x Server
The app use Redis to handle the async job queue. Refer to [this article](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04) for detail installation instructions.

```sh
$ sudo apt-get install redis-server redis-tools
```

#### Configure Redis Server
Use the [example file](config/redis.conf) for the reference:
```sh
$ sudo vi /etc/redis/redis.conf
```
#### Running the redis server:
```sh
$ sudo systemctl restart redis.service
```
You can also use our deployment [redis.service](/config/systemd/redis.service) under Ubuntu 18.0.4 instance for further reference.

#### Check the redis service:
```sh
$ sudo systemctl status redis
$ redis-cli ping    
```
Expecting ‘PONG’ response for success.

### 2.3 Install RVM environment
Refer to https://rvm.io/

### 2.4 Install Ruby on Rails
```sh
$ rvm list
=* ruby-2.6.3 [ x86_64 ]
$ ruby -v
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
```

### 2.5 Download Project Source Code

```sh
$ cd ~/apps
$ git clone https://github.com/yangsec888/www_wmap.git
$ cd www_wmap
```

### 2.6 Install Sidekiq
Make sure the sidekiq gem is installed:
```sh
$ gem install sidekiq
```

#### Configure Sidekiq as service:
This [post](https://gist.github.com/reabiliti/7204115b433e7bd986343d7709f05c2a) provides detail configuration instructions for running your sidekiq as a service.  
```sh
$ sudo vi /lib/systemd/system/sidekiq.service
```
You can also use our deployment [sidekiq.service](/config/systemd/sidekiq.service) under Ubuntu 18.0.4 instance for further reference.

#### Enable Sidekiq service:
```sh
$ sudo systemctl daemon-reload
$ sudo systemctl start sidekiq
```

#### Trouble-shooting Sidekiq:
```sh
$ ps uax | grep sidekiq
$ sudo systemctl status sidekiq
```

### 2.7 Install JS runtime
```sh
$ sudo apt install nodejs
```

### 2.8 Generate the application encryption key
Refer to [this article](https://github.com/rails/rails/blob/master/railties/lib/rails/commands/credentials/USAGE) for details:
```sh
$ rails credentials:help
```

### 2.9 Configure the rails environment variables
Here are the environmental variables you might need to add to environment:
```sh
$ vi ~/.bashrc
...
export PATH="$PATH:$HOME/.rvm/bin"
export RAILS_ENV=production
export SECRET_KEY_BASE=xxxx
export RAILS_MASTER_KEY=xxxx

# Add MariaDB Connectivity credential
export DBUSER=xxxx
export DBPASS=xxxx
export DATABASE_URL=mysql2://root:@localhost:3306/www_wmap_development

# Add Redis connection url
export REDIS_URL=redis://localhost:6379/0
```

### 2.10 Puma Application Server
Puma is the build-in application server for Rails 5. You might want to configure it in 'config/puma.rb'
Refer to [How to Deploy a Rails App with Puma and Nginx](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04) for  detail explanations.

#### Puma Configuration
Refer to [puma.rb](/config/puma.rb) for detail.

### 2.11 Install NGINX
We'll use Nginx web server for the web server layer. It's perfect server to render static application asset. In addition, it'll be setup to proxy traffic for Rails service running in the Puma application server layer.

```sh
$ sudo apt-get install nginx
```

### 2.12 Create a certificate
As a free option, you can try out Letsencrypt service: [Use Let's Encrypt Certificate Authority](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04) to secure the site.
```sh
deploy@www:~$ sudo add-apt-repository ppa:certbot/certbot
deploy@www:~$ sudo apt install python-certbot-nginx
deploy@www:~$ sudo certbot --nginx -d wmap.io -d www.wmap.io
deploy@www:~$ sudo certbot renew --dry-run
deploy@www:~$ sudo vi /etc/nginx/sites-available/www_wmap
```

### 2.13 Configure the Web Server
We use Nginx web server for performance consideration. Make sure to tight up with your Nginx application configuration. Refer to [nginx.conf](/config/nginx/default.conf) for more details.

#### Run Nginx as Service
You can also use our deployment [nginx.service](/config/systemd/nginx.service) under Ubuntu 18.0.4 instance for further reference.

### 2.14 Setup Ubuntu Firewall
How to [Setup a Firewall with UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04) on Ubuntu:


## 2.15 Docker-based SMTP Server Setup
The App uses a containerized postfix SMTP server for sending notification emails from Sidekiq background jobs. The SMTP container is configured as send-only with no authentication required for internal Docker network relay.

### SMTP Container Configuration
The `docker-compose.yml` includes a dedicated SMTP service using the stable `catatnight/postfix` image:

```yaml
smtp:
  image: "catatnight/postfix"
  container_name: "wmap_smtp"
  ports:
    - "25:25"
  volumes:
    - ${PWD}/config/postfix/main.cf:/etc/postfix/main.cf:ro
    - ${PWD}/config/postfix/mailname:/etc/mailname:ro
  environment:
    - maildomain=wmap.cloud
  restart: always
  networks:
    - www_wmap_network
```

### Postfix Configuration
The postfix configuration in `config/postfix/main.cf` is optimized for:
- **Send-only operation**: No mail receiving capabilities
- **No authentication**: Accepts relay from Docker networks without auth  
- **Docker network relay**: Permits all container networks (127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- **Stability**: Uses proven postfix settings for containerized environments

### Environment Variables
Ensure your `.env` file contains:
```bash
SMTP_ADDRESS=smtp
SMTP_PORT=25
SMTP_DOMAIN=wmap.cloud
SMTP_AUTHENTICATION=none
SMTP_ENABLE_STARTTLS_AUTO=false
```

### Rails Integration
The Rails ActionMailer configuration automatically uses these environment variables. No additional Rails configuration is needed - both development and production environments are pre-configured to work with the SMTP container.

### Starting the SMTP Service
The SMTP container starts automatically with the full Docker stack:
```sh
$ docker-compose up -d
```

### Alternative Images
For reference, other stable postfix Docker images include:
- `boky/postfix` - More actively maintained
- `juanluisbaptiste/postfix` - Popular alternative


## 3 Start the Rails Server

### Docker-based Deployment (Recommended)
The application is containerized and can be started with Docker Compose:

```sh
# Create environment file with your configuration
$ cp .env.example .env
# Edit .env with your database credentials and SMTP settings

# Start all services (web, database, redis, sidekiq, smtp, nginx)
$ docker-compose up -d

# Run database migrations
$ docker-compose exec web rake db:create
$ docker-compose exec web rake db:migrate

# Check service status
$ docker-compose ps
```

The application will be available at:
- **HTTP**: http://localhost
- **HTTPS**: https://localhost (if SSL certificates are configured)

### Individual Service Management
```sh
# View logs for specific services
$ docker-compose logs web
$ docker-compose logs sidekiq
$ docker-compose logs smtp

# Restart specific services
$ docker-compose restart web
$ docker-compose restart sidekiq

# Stop all services
$ docker-compose down
```

### Native Installation (Alternative)
For development or custom deployments without Docker:

```sh
$ bundle install
$ rake db:create
$ rake db:migrate
$ rails server
```
You should be able to use local browser to test out the above Web GUI running.
