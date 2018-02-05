#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++

class SeedController < ApplicationController
  before_action :authenticate_user!

  def start
    @dir =  Rails.root.join('uploads', current_user.id.to_s)
    Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
    @file = Rails.root.join('uploads', current_user.id.to_s, 'seed')
    File.new(@file, 'w+') unless File.exist?(@file)
    @uid = current_user.id
  end

  def show
    @dir =  Rails.root.join('uploads', current_user.id.to_s)
    @file = Rails.root.join('uploads', current_user.id.to_s, 'seed')
    @uid = current_user.id
  end

  def create
    file_content = params[:file_tag]
    f = Rails.root.join('uploads', params[:uid_tag], 'seed')
    file = File.open(f, 'w+')
    file.write(file_content)
    #file.write("\n")
    file.close
    redirect_to domains_start_url, notice: "The seed file is saved!"
  end

  def discovery
    #puts "Sending test email: "
    #UserMailer.discovery_completion_notice("yli8@yahoo.com", "yesterday", "today").deliver_later
    puts "starting the sidekiq on the discovery job"
    DiscoveryWorker.perform_async(current_user.id)
  end

  def distest
    @uid = current_user.id.to_s
    puts "You're hitting distest controller"
  end



end
