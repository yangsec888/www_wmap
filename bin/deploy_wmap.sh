#!/bin/bash
################################################################################
# WMAP Portal Rails App Deployment Script
# Version 0.1,
# Last Update: 1/29/2018
# Developed by Yang Li
################################################################################
# Usage:
#  Push out the development environment into production - from the development:
#    $ sh deploy_wmap.sh
################################################################################
# Application home directory in development machine
home_dev="/Users/ylee/"
wmap_home_dev=${home_dev}/www_wmap/
# Application home directory in production machines
home_prod="/home/deploy/"
wmap_home_prod=${home_prod}/apps/
# Application folders to be deployed are declared as an array 'wmapds'
declare -a wmapds=(app/ shared/ lib/ public/ test/ db/ config/)
# Application files to be deployed
declare -a wmapfs=(Gemfile lib/application_responder.rb)
# Step 1 - Prepare
cd $home_dev
# Step 2 - Deploying the aplication folders

rsync -av "www_wmap" deploy@wmap:$wmap_home_prod
# Step 4 - Setup remote server environment
echo "Setup production server rails 5 environment ..."
# ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; rails g bootstrap:install static'
ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; export RAILS_ENV=production; bundle exec rake db:migrate'
#ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle update rails'
ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle install'
ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; RAILS_ENV=production bundle exec rake db:migrate'
ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle exec rake assets:clean'
ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle exec rake assets:precompile'

# Step 5 - Restart the remote web service
echo "Stopping Nginx web service ..."
ssh deploy@wmap 'source ~/.bash_profile; sudo service nginx stop'
echo "Stopping Puma application server service ..."
ssh deploy@wmap 'killall bundle'
echo "Stopping Sidekiq service ..."
ssh deploy@wmap 'source ~/.bash_profile; sudo service sidekiq stop'
sleep 3
#
echo "Starting Puma application server service ..."
ssh deploy@wmap 'source ~/.bash_profile; cd ~/apps/www_wmap; bundle exec puma -e production &'
sleep 3
echo "Starting Sidekiq service ..."
ssh deploy@wmap 'source ~/.bash_profile; sudo service sidekiq start'
echo "Starting Nginx web service ..."
ssh deploy@wmap 'source ~/.bash_profile; sudo service nginx start'
echo "Done"
