[<img src='/wmap_logo.jpg' width='350' height='350'>](https://github.com/yangsec888/www_wmap)
=====================

- [1 Setup Hosting Environment](#1-setup-hosting-environment)
  - [1.1 Service Account Setup](#1.1-service-account-setup)
- [2 Runtime Environment Setup](#2-runtime-environment-setup)
  - [2.1 Install MariaDB v10.4.x](#2-1-install-mariadb-v10-4-x)
  - [2.2 Install Redis v5.x Server](#2-2-install-redis-v5-x-server)
  - [2.3 Install RVM environment:](#2-3-install-rvm-environment)
  - [2.4 Install Ruby on Rails](#2-4-install-ruby-on-rails)
  - [2.5 Down Project Source Code](#2-5-download-project-source-code)
  - [2.6 Install Sidekiq](#2-6-download-project-source-code)
  - [2.7 Install JS runtime](#2-7-install-js-runtime)
  - [2.8 Generate the application encryption key](#2-8-generate-the-application-encryption-key)
  - [2.9 Configure the rails environment variables](#2-9-configure-the-rails-environment-variables)
  - [2.10 Puma Application Server](#2-10-puma-application-server)
  - [2.11 Install NGINX](#2-11-install-nginx)
  - [2.12 Create a certificate](#2-12-create-a-certificate)
  - [2.13 Configure the Web Server](#2-13-configure-the-web-server)
  - [2.14 Setup Ubuntu Firewall](#2-14-setup-ubuntu-firewall)
  - [2.15 Setup Postfix as Send Only SMTP Server](#2-15-setup-postfix-as-send-only-smtp-server)
- [3 Start the Rails Server](#3-start-the-rails-server)
---

## 1 Setup Hosting Environment
Setup the runtime environment in Ubuntu 18.0.4 Linux distribution. Make sure the distribution is patched up to the latest.

### 1.1 Service Account Setup
To start, we'll create a service account "deploy" for the Rails app running environment. We'll add the service account to the special group 'wheel', which is allowed to have 'sudo' access.
```sh
# adduser deploy
# addgroup wheel
# usermod -aG wheel deploy
```

## 2 Runtime Environment Setup

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


## 2.15 Setup Postfix as Send Only SMTP Server
The App would need to send out notification email of async jobs. Such as upon successful asset discovery job. In order to do that, you would need to setup a SMTP send out only server.
Refer to [this article](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-debian-10) for detail explanations and instructions.

After configuring the postfix main.cf file, don't forget to refresh the postfix system:
```sh
$ sudo postfix reload
```


## 3 Start the Rails Server

```sh
$ bundle install
$ rake db:create
$ rake db:migration
$ rails server
```
You should be able to use local browser to test out the above Web GUI running.
