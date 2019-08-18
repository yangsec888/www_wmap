# Setup Hosting Environment
Setup the runtime environment in Ubuntu 18.0.4 Linux distrobution

## 1. Service Account Setup:
```sh
ID: ‘deploy' Service
Group: ‘wheel'
Password: 'MASKED'
```

## 2. Install RVM environment:
Refer to https://rvm.io/

## 3. Install Ruby and Ruby on Rails:
```sh
[deploy@linux ~]$ rvm list
=* ruby-2.5.1 [ x86_64 ]
[deploy@linux ~]$ ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]
```

## 4.  Install the wmap Gem:
Refer to: https://github.com/yangsec888/wmap/blob/master/README.rdoc  

## 5.  Install the MariaDB database instance:
### 5.1 Install DB
Refer to https://computingforgeeks.com/install-mariadb-10-on-ubuntu-18-04-and-centos-7/
```sh
sudo yum install mariadb-server mariadb
```
### 5.2 Start Maria DB:
```sh
sudo apt -y install mariadb-server mariadb-client
```

## 6. Install and Run Redis server:
Refer to https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04

6.1. Install Redis server
  ```sh
    sudo apt install redis-server
  ```

6.2. Configure redis server:
  ```sh
    sudo vi /etc/redis/redis.conf
  ```

6.3. Running the redis server:
  ```sh
    sudo systemctl restart redis.service
  ```

6.4. Check the redis service:
  ```sh
    sudo systemctl status redis
    redid-cli ping   * expecting ‘PONG’ for success
  ```

## 7. Install Sidekiq:
  Download sidekiq gem:
  ```sh
  gem install sidekiq --no-ri --no-rdoc
  ```

7.1. Configure sidekiq as service: https://gist.github.com/reabiliti/7204115b433e7bd986343d7709f05c2a
  ```sh
    sudo vi /lib/systemd/system/sidekiq.service
  ```

7.2. Enable sidekiq service:
  ```sh
   sudo systemctl daemon-reload
   sudo systemctl start sidekiq
  ```

7.3. Trouble-shooting sidekiq:
  ```sh
  ps uax | grep sidekiq
  sudo systemctl status sidekiq
  ```

## 8. Install wmap front-end:
```sh
git clone https://github.com/yangsec888/www_wmap.git
```

8.1. Update the rails environment: bundle install
8.2. Create the database instance: rake db:create
8.3. Create the database table: rake db:migrate
8.4. Generate the application encryption key: refer to https://github.com/rails/rails/blob/master/railties/lib/rails/commands/credentials/USAGE
```sh
rails credentials:help
```

8.4. Configure the rails environment variables: refer to ~/.bashrc


## 9. Puma Application Server
Puma is the build-in application server for Rails 5. You might want to configure it in 'config/puma.rb'
Note:
Generate a master key:
```sh
```

## 10. Install NGINX:
We'll use Nginx web server for the web server layer. It's perfect server to render static application asset. In addition, it'll be setup to proxy traffic for Rails service running in the Puma application server layer.

```sh
  sudo apt-get install nginx
```

10.1. Create a self-sign cert. Refer to this [link](https://www.humankode.com/ssl/create-a-selfsigned-certificate-for-nginx-in-5-minutes) for reference.

10.2. Configure the web server:
Make sure it's tight up with your Puma application configuration. Refer to this file '/etc/nginx/sites-available/www_wmap'
```
upstream www_wmap {
  server unix:///home/deploy/apps/www_wmap/shared/sockets/puma.sock;
}

server {
  listen 80;
  listen 443 ssl;
  server_name wmstools04.us.randomhouse.com;
  ssl_certificate /etc/ssl/certs/www_wmap.crt;
  ssl_certificate_key /etc/ssl/private/www_wmap.key;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;

  root /home/deploy/apps/www_wmap/public;
  access_log /home/deploy/apps/www_wmap/shared/log/nginx.access.log;
  error_log /home/deploy/apps/www_wmap/shared/log/nginx.error.log info;

  location @www_wmap {

    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://www_wmap;
    add_header Cache-Control no-cache;
  }

  #location ^~ /assets/ {
  location ^~ "^/assets/.+-[0-9a-f]{32}.*" {
    gzip_static on;
    expires 1y;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @www_wmap;

  error_page 500 502 503 504 /500.html;
  client_max_body_size 30M;
  keepalive_timeout 10;
}
```

## 11. Setup RHEL Firewall-D:
11.1.  Intro: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-using_firewalls

11.2. Quick start: https://www.certdepot.net/rhel7-get-started-firewalld/

## 12. Setup RHEL Postfix Send Only, Open Relay (smtp mail)
12.1. Intro: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/s1-email-mta

12.2. Configuration: https://benjaminrojas.net/configuring-postfix-to-send-mail-from-mac-os-x-mountain-lion/
