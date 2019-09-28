# Setup Hosting Environment
Setup the runtime environment in Ubuntu 18.0.4 Linux distrobution

## 1. Service Account Setup
To start, we'll create a service account "deploy" for the Rails app running environment. We'll add the service account to the special group 'wheel', which is allowed to have 'sudo' access.
```sh
# adduser deploy
# addgroup wheel
# usermod -aG wheel deploy
```

## 2. Install RVM environment:
Refer to https://rvm.io/

## 3. Install Ruby and Ruby on Rails:
```sh
$ rvm list
=* ruby-2.6.3 [ x86_64 ]
$ ruby -v
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
```

## 4.  Install the wmap Gem:
Refer to: https://github.com/yangsec888/wmap/blob/master/README.rdoc  

## 5.  Install the MariaDB database instance:
### 5.1 Install DB
Refer to https://computingforgeeks.com/install-mariadb-10-on-ubuntu-18-04-and-centos-7/
```sh
$ sudo apt -y install mariadb-server mariadb-client
```
### 5.2 Start Maria DB:
```sh
$ sudo systemctl start mysql
```

## 6. Install and Run Redis server:
The app use Redis to handle the async job queue. Refer to [this article](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04) for detail installation instructions.

### 6.1. Install Redis server
```sh
$ sudo apt install redis-server
```

### 6.2. Configure redis server:
```sh
$ sudo vi /etc/redis/redis.conf
```

### 6.3. Running the redis server:
```sh
$ sudo systemctl restart redis.service
```
You can also use our deployment [redis.service](/config/systemd/redis.service) under Ubuntu 18.0.4 instance for further reference.

### 6.4. Check the redis service:
```sh
$ sudo systemctl status redis
$ redis-cli ping    
```
Expecting ‘PONG’ response for success.

## 7. Install Sidekiq:
Download sidekiq gem:
```sh
$ gem install sidekiq
```

### 7.1. Configure Sidekiq as service:
This [post](https://gist.github.com/reabiliti/7204115b433e7bd986343d7709f05c2a) provides detail configuration instructions for running your sidekiq as a service.  
```sh
$ sudo vi /lib/systemd/system/sidekiq.service
```
You can also use our deployment [sidekiq.service](/config/systemd/sidekiq.service) under Ubuntu 18.0.4 instance for further reference.

### 7.2. Enable Sidekiq service:
```sh
$ sudo systemctl daemon-reload
$ sudo systemctl start sidekiq
```

### 7.3. Trouble-shooting Sidekiq:
```sh
$ ps uax | grep sidekiq
$ sudo systemctl status sidekiq
```
## 8. Install JS runtime:
```sh
$ sudo apt install nodejs
```

## 9. Install wmap front-end:
```sh
$ git clone https://github.com/yangsec888/www_wmap.git
```

### 9.1. Update the rails environment:
```sh
$ bundle install
```

### 9.2. Create the database instance:
```sh
$ rake db:create
```

### 9.3. Create the database table:
```sh
$ rake db:migrate
```

### 9.4. Generate the application encryption key:
Refer to [this article](https://github.com/rails/rails/blob/master/railties/lib/rails/commands/credentials/USAGE) for details:
```sh
$ rails credentials:help
```

### 9.5. Configure the rails environment variables:
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

## 10. Puma Application Server
Puma is the build-in application server for Rails 5. You might want to configure it in 'config/puma.rb'
Refer to [How to Deploy a Rails App with Puma and Nginx](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04) for  detail explanations.

### 10.1 Puma Configuration
Refer to [puma.rb](/config/puma.rb) for detail.

## 11. Install NGINX:
We'll use Nginx web server for the web server layer. It's perfect server to render static application asset. In addition, it'll be setup to proxy traffic for Rails service running in the Puma application server layer.

```sh
$ sudo apt-get install nginx
```

### 11.1. Create a self-sign cert. Refer to this [link](https://www.humankode.com/ssl/create-a-selfsigned-certificate-for-nginx-in-5-minutes) for reference.

### 11.2. Configure the web server:
Make sure it's tight up with your Puma application configuration. Refer to [nginx.conf](/config/nginx.conf) for more details.

### 11.3. Run Nginx as Service
You can also use our deployment [nginx.service](/config/systemd/nginx.service) under Ubuntu 18.0.4 instance for further reference.

## 12. Setup Ubuntu Firewall:
How to [Setup a Firewall with UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04) on Ubuntu:


## 13. Setup Postfix as Send Only SMTP Server
The App would need to send out notification email of async jobs. Such as upon successful asset discovery job. In order to do that, you would need to setup a SMTP send out only server.
Refer to [this article](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-debian-10) for detail explanations and instructions.

After configuring the postfix main.cf file, don't forget to refresh the postfix system:
```sh
$ sudo postfix reload
```
