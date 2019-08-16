# Setup Hosting Environment
Setup the runtime environment in RHEL 7.4 Linux distrobution

## 1. Service Account:
ID: ‘deploy' Service Group: ‘wheel' Password: 'MASKED'

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
Refer to https://community.rackspace.com/products/f/public-cloud-forum/7374/installing-mysql-server-on-red-hat-enterprise-linux
```sh
sudo yum install mariadb-server mariadb
```
### 5.2 Start Maria DB:
```sh
sudo systemctl start mariadb.service
```

## 6. Install and Run Redis server:
    1. sudo yum install redis
    2. Configure redis server:  sudo /sbin/chkconfig redis on
    3. Running the redis server: sudo service redis start
    4. Check the redis service: redid-cli ping   * expecting ‘PONG’ for success

## 7. Install Sidekiq:
```sh
gem install sidekiq --no-ri --no-rdoc
```
    1. Install rubygems-bundler: gem install rubygems-bundler
    2. Configure sidekiq as service:  /usr/lib/systemd/system/sidekiq.service
    3. Enable sidekiq service: sudo /sbin/chkconfig sidekiq on
    4. Running the sidekick service: sudo service sidekiq start
## 8. Install wmap front-end:
```sh
git clone https://github.com/yangsec888/www_wmap.git
    1. Update the rails environment: bundle install
    2. Create the database instance: rake db:create
    3. Create the database table: rake db:migrate
    4. Configure the rails environment variables: refer to ~/.bashrc
```

## 9. Install NGINX:
```sh
sudo yum install nginx
```
    1. Create a self-sign cert: https://www.humankode.com/ssl/create-a-selfsigned-certificate-for-nginx-in-5-minutes
    2. Configure the web server: refer to /etc/nginx/conf.d/www.wmap.conf

## 10. Setup RHEL Firewall-D:
    1.  Intro: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-using_firewalls
    2. Quick start: https://www.certdepot.net/rhel7-get-started-firewalld/

## 11. Setup RHEL Postfix Send Only, Open Relay (smtp mail)
    1. Intro: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/s1-email-mta
    2. Configuration: https://benjaminrojas.net/configuring-postfix-to-send-mail-from-mac-os-x-mountain-lion/
