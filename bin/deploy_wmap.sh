#!/bin/bash
################################################################################
# WMAP Portal Rails App Deployment Script
# Version 0.3,
# Created: 1/29/2018
# Last Update: 08/17/2019
# Developed by Sam (Yang) Li
################################################################################
# Usage:
#  Push out the development environment into production - from the development:
#    $ sh deploy_wmap.sh
################################################################################
# Application home directory in development machine
home_dev="/Users/sli/"
wmap_app_dev=${home_dev}/www_wmap/
# Application home directory in production machines
prod_host="wmap.io"
home_prod="/home/deploy/"
wmap_app_prod=${home_prod}/apps/
wmap_prod=${home_prod}/wmap/
# Application folders to be deployed are declared as an array 'wmapds'
declare -a wmapds=(app/ shared/ lib/ public/ test/ db/ config/)
# Application files to be deployed
declare -a wmapfs=(Gemfile lib/application_responder.rb)
# Step 1 - Prepare
cd $home_dev
# Step 2 - Deploying the aplication folders
#rsync -avq --exclude-from .exclude_wmap.txt wmap/.git "wmap" deploy@${prod_host}:${wmap_prod}  2>/dev/null
rsync -avq --exclude-from ${wmap_app_dev}/.exclude_www_wmap.txt "www_wmap" deploy@${prod_host}:${wmap_app_prod} 2>/dev/null

# Step 4 - Setup remote server environment
echo "Setup production server rails 5 environment ..."
# ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; rails g bootstrap:install static'
ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; export RAILS_ENV=production; bundle exec rake db:migrate' 2> /dev/null
#ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle update' 2> /dev/null
ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle install' 2> /dev/null
ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; RAILS_ENV=production bundle exec rake db:migrate' 2> /dev/null
ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle exec rake assets:clean' 2> /dev/null
ssh -q deploy@${prod_host} 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle exec rake assets:precompile' 2> /dev/null
sleep 5

# Step 5 - Restart the remote services
echo "Stopping Postfix mail service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile;  sudo postfix stop'
echo "Stopping Nginx web service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile; sudo systemctl stop nginx'
echo "Stopping Puma application server service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile; bundle exec pumactl -P /home/deploy/apps/www_wmap/shared/tmp/puma.pid stop'
#echo "Stopping Sidekiq service ..."
#ssh -q deploy@${prod_host} 'source ~/.bash_profile; sudo service sidekiq stop'
sleep 3
echo "Stopping Sidekiq service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile;  sudo systemctl stop sidekiq'

##
echo "Starting Puma application server service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile; bundle exec pumactl -P /home/deploy/apps/www_wmap/shared/tmp/puma.pid start &'
sleep 3

echo "Starting Nginx web service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile; sudo systemctl start nginx'
echo "Done"

echo "Starting Sidekiq service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile; sudo systemctl start sidekiq'
echo "Done"

echo "Start Postfix service ..."
ssh -q deploy@${prod_host} 'source ~/.bash_profile; sudo postfix start'
